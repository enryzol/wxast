//
//  UserListViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "UserListViewController.h"
#import "AlbumBoardTableViewCell.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "Function.h"
#import "Api.h"

@interface UserListViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@end

@implementation UserListViewController{
    NSMutableArray *TableViewData;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - tableview degelate
-(void)loadDataFromServer{
    
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/User/Follow/?LToken=%@",[Api LToken]];
    
    NSLog(@"%@",url);
    
    [[Function sharedManager] Post:url Params:nil Message:@"正在加载数据" CompletionHandler:^(MKNetworkOperation *completed) {
        
        NSLog(@"%@",[completed responseString]);
        id json = [completed responseJSON];
        
        if([[Function sharedManager] CheckJSONNull:json[@"list"]]){
            TableViewData = json[@"list"];
            [self.tableview reloadData];
            [self.tableview headerEndRefreshing];
        }
        
        self.NewFollerCount.text = json[@"count"];
        self.New7DaysFollerCount.text = json[@"count7"];
        [self.tableview headerEndRefreshing];
        
    } ErrorHander:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableview headerEndRefreshing];

    }];

}
-(void)loadMoreFromServer{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/User/Follow/?LToken=%@&count=%d",[Api LToken],[TableViewData count]];
    
    NSLog(@"%@",url);
    
    [[Function sharedManager] Post:url Params:nil Message:@"正在加载数据" CompletionHandler:^(MKNetworkOperation *completed) {
        
        NSLog(@"%@",[completed responseString]);
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
        
    } ErrorHander:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableview footerEndRefreshing];
        
    }];
    
}


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
    
    return 50;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"UserListCell";
    AlbumBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    

    cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    cell.Name.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.Keyword.text =[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"ctime"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
}


#pragma mark - actionsheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
}


- (IBAction)NavLeftButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}












@end
