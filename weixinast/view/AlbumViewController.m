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

#define AAAAA (NSInteger)101;

@interface AlbumViewController () <UIActionSheetDelegate,UIAlertViewDelegate>

@end

@implementation AlbumViewController{
    
    NSMutableArray *TableViewData ;
    
//    int ALERTVIEW_DELETE_ALBUM ;
//    ALERTVIEW_DELETE_ALBUM = 101

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - load data 

-(void)loadDataFromServer{
    
    
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Album/alist/?LToken=%@",[Api LToken]];
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:nil httpMethod:@"GET" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        id json = [completedOperation responseJSON];
        
        if(TableViewData == nil){
            TableViewData = [[NSMutableArray alloc] init];
        }
        
        TableViewData = json;
        
        NSLog(@"AlbumViewController - loadDataFromServer - %@" , [completedOperation responseString]);
        
        [self.abTableView reloadData];
        [self.abTableView headerEndRefreshing];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [self.abTableView headerEndRefreshing];
        
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
    
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
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"图集操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle: @"删除"otherButtonTitles:@"编辑",@"预览",@"分享", nil];
    [as setTag:indexPath.row];
    [as showInView:[UIApplication sharedApplication].keyWindow];
}



#pragma mark - action sheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSLog(@"%ld",(long)buttonIndex);
    
    NSString *title = [NSString stringWithFormat:@"'%@'删除以后将无法还原",[[TableViewData objectAtIndex:[actionSheet tag]] objectForKey:@"title"]];
    
    if(buttonIndex == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"正在删除图集" message:title delegate:self cancelButtonTitle:@"暂不删除" otherButtonTitles:@"立即删除", nil];
        
        [alert setTag: [actionSheet tag] ];
        [alert show];
        
    }else if (buttonIndex == 1){
        
        AlbumNEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumNEditViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        vc.Album = [TableViewData objectAtIndex:[actionSheet tag]];
        
    }else if (buttonIndex == 2){
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
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






#pragma mark - nav bar button

- (IBAction)NavBarLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)NavBarRightButton:(id)sender {
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Album/Add/?LToken=%@",[Api LToken]];
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:nil httpMethod:@"GET" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [[Function sharedManager] AlertViewHide];
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"创建成功" description:@"目录已被新建" type:TWMessageBarMessageTypeInfo duration:2.0f];
        [self.abTableView headerBeginRefreshing];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"创建失败" description:@"无法连接至服务器" type:TWMessageBarMessageTypeError duration:2.0f];
        [[Function sharedManager] AlertViewHide];
    }];
    
    [[Function sharedManager] AlertViewShow:@"正在创建新目录"];
    [ApplicationDelegate.Engin enqueueOperation:op];
    
    
}








@end
