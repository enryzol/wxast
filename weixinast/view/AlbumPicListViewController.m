//
//  AlbumPicListViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-14.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "AlbumPicListViewController.h"
#import "AlbumBoardTableViewCell.h"

#import "AppDelegate.h"
#import "MJRefresh.h"


@interface AlbumPicListViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>

@end

@implementation AlbumPicListViewController{
    
    NSMutableArray *TableViewData ;
    
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

#pragma mark - load data

-(void)loadDataFromServer{
    
    NSString *url = [NSString stringWithFormat:@"/mobile/group/i/%@/g/1/%d",ApplicationDelegate.Package,self.groupid];
    
    NSLog(@"%@",url);
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        id json = [completedOperation responseJSON];
        
        if(TableViewData == nil){
            TableViewData = [[NSMutableArray alloc] init];
        }
        
        TableViewData = json[@"list"];
        
        //NSLog(@"%@",TableViewData);
        
        [self.tableview reloadData];
        [self.tableview headerEndRefreshing];
        
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Success" description:@"Reflesh Success" type:TWMessageBarMessageTypeSuccess duration:0.8f];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [self.tableview headerEndRefreshing];
        
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
}


#pragma mark - tableview

-(void)headerReFreshing{
    [self loadDataFromServer];
}

-(void)footerReFreshing{
    [self.tableview footerEndRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TableViewData count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"AlbumBoardCell01";
    AlbumBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.Desc.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"desc"];
    cell.Keyword.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    NSString *url = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"img"];
    cell.uniqueID = url;
    
    //[cell.Name sizeToFit];
    [cell setImageWithURL:url];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"编辑" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除图片" otherButtonTitles:@"编辑图片",@"图片排序", nil];
    
    [as showInView:[UIApplication sharedApplication].keyWindow];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    id buffer = [TableViewData objectAtIndex:sourceIndexPath.row];

    NSMutableArray *ss = [TableViewData mutableCopy];
    
    [ss removeObjectAtIndex:sourceIndexPath.row];
    [ss insertObject:buffer atIndex:destinationIndexPath.row];
    
    TableViewData = ss;
    
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


#pragma mark - action sheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" 确定删除图片？" message:@"图片删除将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert setTag:100];
        [alert show];
    }else if (buttonIndex == 1){
        
        
    }else if (buttonIndex == 2){
        
        [self.tableview setEditing:YES];
        //UIBarButtonItem *Done = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_done_100.png"] style:UIBarButtonItemStylePlain target:self action:@selector(TableviewDone)];
        //[self.NavBarRightButton setBackgroundImage:[UIImage imageNamed:@"ico_done_100.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self.NavBarRightButton setImage:[UIImage imageNamed:@"ico_done_100.png"]];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 100){
        if(buttonIndex == 0){
            //cancel
            
            NSLog(@"cancel");
        }else{
            //delete
            
            NSLog(@"delete");
        }

    }
}


- (IBAction)NavRightButtonAction:(id)sender {
    
    if(self.tableview.editing){
        [self.NavBarRightButton setImage:[UIImage imageNamed:@"ico_add_100w.png"]];
        [self.tableview setEditing:NO];
    }else{
        NSLog(@"add new");
    }
    
    
}

- (IBAction)NavLeftButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

















@end
