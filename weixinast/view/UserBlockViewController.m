//
//  UserBlockViewController.m
//  weixinast
//
//  Created by Jackie on 14-8-4.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "UserBlockViewController.h"
#import "AlbumBoardTableViewCell.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "Function.h"
#import "Api.h"


@interface UserBlockViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@end

@implementation UserBlockViewController{
    NSMutableArray *TableViewData;
    UIActionSheet *deleteAS;
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
    
    [self loadDataFromServer];
    
    [self.NavBar setFrame:CGRectMake(0, 0, 320, 64)];
    [self.NavBar setBackgroundImage:[UIImage imageNamed:@"bg_top.png"] forBarMetrics:UIBarMetricsDefault];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview degelate
-(void)loadDataFromServer{
    
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/User/Block/?LToken=%@",[Api LToken]];
    
    NSLog(@"%@",url);
    
    [[Function sharedManager] Post:url Params:nil Message:@"正在加载数据" CompletionHandler:^(MKNetworkOperation *completed) {
        
        NSLog(@"%@",[completed responseString]);
        id json = [completed responseJSON];
        
        if([[Function sharedManager] CheckJSONNull:json[@"list"]]){
            TableViewData = json[@"list"];
            [self.tableview reloadData];
        }else{
            TableViewData = NULL;
        }
        [self.tableview reloadData];
        [self.tableview headerEndRefreshing];
        
        
    } ErrorHander:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableview headerEndRefreshing];
    }];
    
}


-(void)headerReFreshing{
    [self loadDataFromServer];
}

-(void)footerReFreshing{
    [self.tableview footerEndRefreshing];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TableViewData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"UserListCell";
    AlbumBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //cell.Name.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"title"];
    //[cell setImageWithURL:[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"img"]];
    
    if ([[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@""]) {
        cell.Name.text = @"用户";
    }else{
        cell.Name.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    
    cell.Keyword.text =[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"ctime"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    deleteAS = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    
    deleteAS.tag = indexPath.row;
    [deleteAS showInView:[UIApplication sharedApplication].keyWindow];
    
}

#pragma mark - actionsheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self MessageBlock:[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"wid"] Hour:@"0"];
    }
}

-(void)MessageBlock:(NSString*)Mid Hour:(NSString*)hour{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/User/MessageBlock/?LToken=%@&wid=%@&block=%@",[Api LToken],Mid,hour];
    
    NSLog(@"%@",url);
    
    [[Function sharedManager] Post:url Params:nil Message:@"正在设置" CompletionHandler:^(MKNetworkOperation *completed) {
        [self loadDataFromServer];
    } ErrorHander:^(NSError *error) {
        [self.tableview headerEndRefreshing];
    }];
    
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
