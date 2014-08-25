//
//  BookViewController.m
//  weixinast
//
//  Created by Jackie on 14-8-14.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "BookViewController.h"
#import "MJRefresh.h"
#import "Http.h"
#import "Common.h"
#import "AppDelegate.h"
#import "Api.h"
#import "Function.h"
#import "Comm_Observe.h"
#import "CommAction.h"
#import "AlbumBoardTableViewCell.h"
#import "BookEditViewController.h"

#import <ShareSDK/ShareSDK.h>

@interface BookViewController ()<UIActionSheetDelegate>{
    
    NSMutableArray *TableViewData ;
    
    CommAction * commAction;
    
}


@end

@implementation BookViewController

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
    
    [self.abTableView addHeaderWithTarget:self action:@selector(headerReFreshing)];
    [self.abTableView addFooterWithTarget:self action:@selector(footerReFreshing)];
    
    //    [self loadDataFromServer];
    [self.abTableView headerBeginRefreshing];
    
    TableViewData = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - load data

-(void)loadDataFromServer{

    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/alist/?LToken=%@",[Api LToken]];
    
    [[Function sharedManager] Post:url Params:nil CompletionHandler:^(MKNetworkOperation *completed) {
        id json = [completed responseJSON];
        
        if([[Function sharedManager] CheckJSONNull:json[@"list"]]){
            TableViewData = json[@"list"];
            [self.abTableView reloadData];
        }
        
        NSLog(@"AlbumViewController - loadDataFromServer - %@" , [completed responseString]);
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
    
    cell.Name.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"subject"];
    cell.uniqueID = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"cover"];
    
    [cell setImageWithURL:[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"cover"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"图集操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑",@"预览",@"分享",@"关闭",@"删除", nil];
    [as setTag:indexPath.row];
    [as showInView:[UIApplication sharedApplication].keyWindow];
}


#pragma mark - action sheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *title = [NSString stringWithFormat:@"'%@'删除以后将无法还原",[[TableViewData objectAtIndex:[actionSheet tag]] objectForKey:@"subject"]];
    
    if(buttonIndex == 4){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"正在删除图集" message:title delegate:self cancelButtonTitle:@"暂不删除" otherButtonTitles:@"立即删除", nil];
        
        [alert setTag: [actionSheet tag] ];
        [alert show];
        
    }else if (buttonIndex == 0){
        
        BookEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookEditViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        vc.Book = [TableViewData objectAtIndex:[actionSheet tag]];
        
    }else if (buttonIndex == 2){
        
        [actionSheet dismissWithClickedButtonIndex:0 animated:NO];
        [self Share:actionSheet.tag];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        //no delete
        
    }else if (buttonIndex == 1){
        //delete
        
        NSString *beid = [[TableViewData objectAtIndex:[alertView tag]] objectForKey:@"beid"];
        
        NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/Delete/?LToken=%@&beid=%@",[Api LToken],beid];
        
        
        [[Function sharedManager] Post:url Params:nil Message:@"正在删除" CompletionHandler:^(MKNetworkOperation *completed) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"删除成功" description:@"预约已被删除" type:TWMessageBarMessageTypeInfo duration:2.0f];
            [self.abTableView headerBeginRefreshing];
        } ErrorHander:^(NSError *error) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"登录" description:@"登录失败，无法连接到服务器" type:TWMessageBarMessageTypeError duration:2.0f];
        }];

        
    }
}


#pragma mark - share

-(void)Share:(NSInteger)index{
    NSLog(@"share");
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"0"  ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:[[TableViewData objectAtIndex:index] objectForKey:@"subject"]
                                                  url:@"http://i.o-tap.cn/"
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
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/Add/?LToken=%@",[Api LToken]];
    [[Function sharedManager] Post:url Params:nil Message:@"正在创建新预约" CompletionHandler:^(MKNetworkOperation *completed) {
        [[Function sharedManager] AlertViewHide];
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"创建成功" description:@"预约已被新建" type:TWMessageBarMessageTypeSuccess duration:2.0f];
        [self.abTableView headerBeginRefreshing];
    } ErrorHander:^(NSError *error) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"创建失败" description:@"无法连接至服务器" type:TWMessageBarMessageTypeError duration:2.0f];
        [[Function sharedManager] AlertViewHide];
    }];
    
}























@end
