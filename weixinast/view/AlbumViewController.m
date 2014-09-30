//
//  AlbumViewController.m
//  weixinast
//
//  Created by Jackie on 14-6-23.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//


#import "AlbumViewController.h"
#import "MJRefresh.h"
#import "Http.h"
#import "Common.h"
#import "AlbumBoardTableViewCell.h"
#import "AlbumNEditViewController.h"
#import "AppDelegate.h"
#import "Api.h"
#import "Function.h"
#import "Comm_Observe.h"
#import "CommAction.h"
#import "DescEditViewController.h"

#import <ShareSDK/ShareSDK.h>

@interface AlbumViewController () <UIActionSheetDelegate,UIAlertViewDelegate,CommonProtocol>

@end

@implementation AlbumViewController{
    
    NSMutableArray *TableViewData ;
    
    CommAction * commAction;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    
    
    [self.abTableView addHeaderWithTarget:self action:@selector(headerReFreshing)];
    [self.abTableView addFooterWithTarget:self action:@selector(footerReFreshing)];
    
//    [self loadDataFromServer];
    [self.abTableView headerBeginRefreshing];
    
    [self.NavBar setFrame:CGRectMake(0, 0, 320, 64)];
    [self.NavBar setBackgroundImage:[UIImage imageNamed:@"bg_top.png"] forBarMetrics:UIBarMetricsDefault];
    
//    //Observer
//    commAction = [[CommAction alloc] init];
//    [commAction ObserverKey:@"AlbumListReflush" Callback:^(NSString *Key) {
//        if([[[Comm_Observe sharedManager] AlbumListReflush] isEqualToString:@"1"]){
//            [self loadDataFromServer];
//            [[Comm_Observe sharedManager] setAlbumListReflush:@"0"];
//        }
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    
    if([[[Comm_Observe sharedManager] AlbumListReflush] isEqualToString:@"1"]){
        [self loadDataFromServer];
        [[Comm_Observe sharedManager] setAlbumListReflush:@"0"];
    }else{
        [self loadDataFromServer];
    }
    
}

#pragma mark - load data

-(void)loadDataFromServer{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Album/alist/?LToken=%@",[Api LToken]];
    
    [[Function sharedManager] Post:url Params:nil CompletionHandler:^(MKNetworkOperation *completed) {
        
        id json = [completed responseJSON];
        
        if(TableViewData == nil){
            TableViewData = [[NSMutableArray alloc] init];
        }
        
        if([[Function sharedManager] CheckJSONNull:json[@"list"]]){
            TableViewData = json[@"list"];
            
            [self.abTableView reloadData];
            
        }
        NSLog(@"%@",[completed responseString]);
        
        [self.abTableView headerEndRefreshing];
        [Api CheckLoginStatus:self];
        
    } ErrorHander:^(NSError *error) {
        [self.abTableView headerEndRefreshing];
    }];
    
}

#pragma mark - table delegate

-(void)headerReFreshing{
    [self loadDataFromServer];
}

-(void)footerReFreshing{
    [self.abTableView footerEndRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TableViewData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"AlbumBoardCell";
    AlbumBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.Name.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.uniqueID = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"img"];
    
    [cell setImageWithURL:[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"img"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"图集操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑",@"预览",@"分享",@"删除",@"举报违规内容", nil];
    [as setTag:indexPath.row];
    [as showInView:[UIApplication sharedApplication].keyWindow];
}



#pragma mark - action sheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *title = [NSString stringWithFormat:@"'%@'删除以后将无法还原",[[TableViewData objectAtIndex:[actionSheet tag]] objectForKey:@"title"]];
    
    if(buttonIndex == 3){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"正在删除图集" message:title delegate:self cancelButtonTitle:@"暂不删除" otherButtonTitles:@"立即删除", nil];
        
        [alert setTag: [actionSheet tag] ];
        [alert show];
        
    }else if (buttonIndex == 0){
        
        AlbumNEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumNEditViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        vc.Album = [TableViewData objectAtIndex:[actionSheet tag]];
        
    }else if (buttonIndex == 2){
        
        [actionSheet dismissWithClickedButtonIndex:0 animated:NO];
        [self Share:actionSheet.tag];
        
    }else if(buttonIndex == 1){
        
        NSString *url = [NSString stringWithFormat:@"http://wx.o-tap.cn/mobile/album/i/%@/groupid/%@",[Api Package],[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"groupid"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }else if(buttonIndex == 4){
        
        DescEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DescEditViewController"];
        vc.SubjectStr = @"请输入简要的举报说明";
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 37113009){
        

        
    }else{
        if(buttonIndex == 0){
            //no delete
            
        }else if (buttonIndex == 1){
            //delete
            
            NSString *groupid = [[TableViewData objectAtIndex:[alertView tag]] objectForKey:@"groupid"];
            
            NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Album/Delete/?LToken=%@&groupid=%@",[Api LToken],groupid];
            
            MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:nil httpMethod:@"GET" ssl:YES];
            
            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"删除成功" description:@"目录已被删除" type:TWMessageBarMessageTypeInfo duration:2.0f];
                [self.abTableView headerBeginRefreshing];
                
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"登录" description:@"登录失败，无法连接到服务器" type:TWMessageBarMessageTypeError duration:2.0f];
                
            }];
            
            [ApplicationDelegate.Engin enqueueOperation:op];
        }
    }
    
    
}

//Commom protocal

-(void)CommonReturn:(NSString *)str Tag:(int)i{
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Setting/Report/?LToken=%@",[Api LToken]];
    NSDictionary *param = @{@"report" : str};
    
    [[Function sharedManager] Post:url Params:param Message:@"正在举报，请稍后" CompletionHandler:^(MKNetworkOperation *completed) {
        
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"举报成功" description:@"我们将在核实之后立即处理您所举报的内容" type:TWMessageBarMessageTypeSuccess duration:5.0f];
        
    } ErrorHander:^(NSError *error) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"举报失败" description:@"请查看您的网络，或者请登录官网举报相关内容" type:TWMessageBarMessageTypeError duration:2.0f];
    }];
}


#pragma mark - share

-(void)Share:(NSInteger)index{
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"0"  ofType:@"png"];
    
    NSString *url = [NSString stringWithFormat:@"http://wx.o-tap.cn/mobile/album/i/%@/groupid/%@",[Api Package],[[TableViewData objectAtIndex:index] objectForKey:@"groupid"]];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:[[TableViewData objectAtIndex:index] objectForKey:@"title"]
                                                  url:url
                                          description:[[TableViewData objectAtIndex:index] objectForKey:@"desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"分享成功" description:@"" type:TWMessageBarMessageTypeInfo];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    //NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"分享失败" description:@"" type:TWMessageBarMessageTypeError];
                                }
                            }];
}

#pragma mark - nav bar button

- (IBAction)NavBarLeftButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)NavBarRightButton:(id)sender {
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Album/Add/?LToken=%@",[Api LToken]];
    
    [[Function sharedManager] Post:url Params:nil Message:@"正在创建新图集" CompletionHandler:^(MKNetworkOperation *completed) {
        [[Function sharedManager] AlertViewHide];
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"创建成功" description:@"图集已被新建" type:TWMessageBarMessageTypeSuccess duration:2.0f];
        [self.abTableView headerBeginRefreshing];
    } ErrorHander:^(NSError *error) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"创建失败" description:@"无法连接至服务器" type:TWMessageBarMessageTypeError duration:2.0f];
        [[Function sharedManager] AlertViewHide];
    }];
    
    
}








@end
