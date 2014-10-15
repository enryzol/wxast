//
//  UserMessageViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "UserMessageViewController.h"
#import "AlbumBoardTableViewCell.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "Function.h"
#import "Api.h"
#import "Func_AlertComfirm.h"

@interface UserMessageViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>

@end

@implementation UserMessageViewController{
    
    NSMutableArray *TableViewData;
    Func_AlertComfirm * alertComfirm;
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
    
    [self.tableview addHeaderWithTarget:self action:@selector(headerReFreshing)];
    [self.tableview addFooterWithTarget:self action:@selector(footerReFreshing)];
    
    
    
    [self.NavBar setFrame:CGRectMake(0, 0, 320, 64)];
    [self.NavBar setBackgroundImage:[UIImage imageNamed:@"bg_top.png"] forBarMetrics:UIBarMetricsDefault];
    
    alertComfirm = [[Func_AlertComfirm alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadDataFromServer];
}


#pragma mark - server 

-(void)loadDataFromServer{
    
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/User/Message/?LToken=%@",[Api LToken]];
    
    NSLog(@"%@",url);
    
    [[Function sharedManager] Post:url Params:nil Message:@"正在加载数据" CompletionHandler:^(MKNetworkOperation *completed) {
        
        NSLog(@"%@",[completed responseString]);
        
        id json = [completed responseJSON];
        
        if([[Function sharedManager] CheckJSONNull:json[@"list"]]){
            TableViewData = json[@"list"];
        }else{
            TableViewData = nil;
        }
        [self.tableview reloadData];
        [self.tableview headerEndRefreshing];
        
    } ErrorHander:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableview headerEndRefreshing];
    }];
    
}

-(void)loadMoreFromServer{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/User/Message/?LToken=%@&count=%lu",[Api LToken],(unsigned long)[TableViewData count]];
    
    NSLog(@"%@",url);
    
    [[Function sharedManager] Post:url Params:nil Message:@"正在加载数据" CompletionHandler:^(MKNetworkOperation *completed) {
        
        id json = [completed responseJSON];
        
        if([[Function sharedManager] CheckJSONNull:json[@"list"]]){
            NSMutableArray *More = json[@"list"];
            
            NSMutableArray *_Tmp = [TableViewData mutableCopy];
            [_Tmp addObjectsFromArray:More];
            TableViewData = _Tmp;
            [self.tableview reloadData];
            [self.tableview footerEndRefreshing];
        }
        
        [self.tableview footerEndRefreshing];
        [Api CheckLoginStatus:self];
        
    } ErrorHander:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableview footerEndRefreshing];
        
    }];
}

-(void)DeleteMessage:(NSString*)Mid{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/User/MessageDelete/?LToken=%@&mid=%@",[Api LToken],Mid];
    
    NSLog(@"%@",url);
    
    [[Function sharedManager] Post:url Params:nil CompletionHandler:^(MKNetworkOperation *completed) {
        
        [self.tableview reloadData];
        
    } ErrorHander:^(NSError *error) {
        [self.tableview headerEndRefreshing];
    }];

}

-(void)MessageBlock:(NSString*)Mid Hour:(NSString*)hour{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/User/MessageBlock/?LToken=%@&mid=%@&block=%@",[Api LToken],Mid,hour];
    
    NSLog(@"%@",url);
    
    [[Function sharedManager] Post:url Params:nil Message:@"正在设置" CompletionHandler:^(MKNetworkOperation *completed) {
        
    } ErrorHander:^(NSError *error) {
        [self.tableview headerEndRefreshing];
    }];
    
}

-(void)UserSetMid:(NSString*)Mid Note:(NSString*)note{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/User/Setnote/?LToken=%@&mid=%@",[Api LToken],Mid];
    NSLog(@"%@",url);
    NSDictionary *prama = @{@"note": note};
    
    [[Function sharedManager] Post:url Params:prama Message:@"正在设置" CompletionHandler:^(MKNetworkOperation *completed) {
        
    } ErrorHander:^(NSError *error) {
        [self.tableview headerEndRefreshing];
    }];
    
}

#pragma mark - tableview degelate
-(void)headerReFreshing{
    [self loadDataFromServer];
}

-(void)footerReFreshing{
    [self loadMoreFromServer];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TableViewData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"UserMessageCell";
    AlbumBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    cell.Name.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.Desc.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"message"];
    cell.Keyword.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"ctime"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"系统"]){
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"屏蔽该用户24小时",@"不再接收该用户消息",@"备注该用户",@"删除", nil];
        [as setTag:indexPath.row];
        [as showInView:[UIApplication sharedApplication].keyWindow];
    }
    
}


#pragma mark - actionsheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 3) {
        [self DeleteMessage:[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"mid"]];
        
        NSLog(@"%ld",(long)actionSheet.tag);
        
        NSMutableArray *tmp = [TableViewData mutableCopy];
        [tmp removeObjectAtIndex:actionSheet.tag];
        TableViewData = tmp;
        [self.tableview reloadData];
        
    }else if (buttonIndex == 0){
        
        [alertComfirm alertComfirmTitle:@"该操作将屏蔽用户消息24小时" Message:@"" SureHandler:^{
            [self MessageBlock:[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"mid"] Hour:@"24"];
        }];
        
    }else if (buttonIndex == 1){
        
        [alertComfirm alertComfirmTitle:@"该操作永久屏蔽该用户消息" Message:@"" SureHandler:^{
            [self MessageBlock:[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"mid"] Hour:@"9999"];
        }];
        
    }else if (buttonIndex == 2){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请设置备注内容" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av setTag:actionSheet.tag];
        [av show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self UserSetMid:[[TableViewData objectAtIndex:alertView.tag] objectForKey:@"mid"] Note:[[alertView textFieldAtIndex:0] text]];
    }
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

- (IBAction)NavLeftButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}















@end
