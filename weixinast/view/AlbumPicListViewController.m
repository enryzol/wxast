//
//  AlbumPicListViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-14.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "AlbumPicListViewController.h"
#import "AlbumBoardTableViewCell.h"
#import "AlbumPicEditViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "Api.h"
#import "Function.h"
#import "Comm_Observe.h"
#import "CommAction.h"


@interface AlbumPicListViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>

@end

@implementation AlbumPicListViewController{
    
    NSMutableArray *TableViewData ;
    CommAction *commAction;
    
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
    self.NavBar.topItem.title = [self.Album objectForKey:@"title"];
    
    
    //Observer
    commAction = [[CommAction alloc] init];
    [commAction ObserverKey:@"AlbumPicListReflush" Callback:^(NSString *Key) {
        if ([[[Comm_Observe sharedManager] AlbumPicListReflush] isEqualToString:@"1"]) {
            [self loadDataFromServer];
            [[Comm_Observe sharedManager] setAlbumPicListReflush:@"0"];
        }
    }];
}



-(void)viewWillAppear:(BOOL)animated{
    
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
    
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Album/aglist/?LToken=%@&group=%@",[Api LToken],self.groupid];
    
    NSLog(@"%@",url);
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:nil httpMethod:@"GET" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        id json = [completedOperation responseJSON];
        
        if(TableViewData == nil){
            TableViewData = [[NSMutableArray alloc] init];
        }
        
        TableViewData = json[@"list"];
        
        NSLog(@"%@",json);
        
        [self.tableview reloadData];
        [self.tableview headerEndRefreshing];
        
        
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
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"编辑" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图片编辑",@"图片排序",@"设为封面",@"图片删除", nil];
    
    [as setTag:indexPath.row];
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
    
    if(buttonIndex == 3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" 确定删除图片？" message:@"图片删除将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert setTag:[actionSheet tag]];
        [alert show];
    }else if (buttonIndex == 0){
        
        AlbumPicEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPicEditViewController"];
        
        vc.PictureInfo = [TableViewData objectAtIndex:actionSheet.tag];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (buttonIndex == 1){
        
        [self.tableview setEditing:YES];
        [self.NavBarRightButton setImage:[UIImage imageNamed:@"ico_done_100.png"]];
    }else if (buttonIndex == 2){
        
        
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    

        if(buttonIndex == 0){
            //cancel
            
            NSLog(@"cancel");
        }else{
            //delete
            NSLog(@"delete");
            
            NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Album/DeletePic/?LToken=%@&sid=%@",[Api LToken] , [[TableViewData objectAtIndex:alertView.tag] objectForKey:@"sid"]];
            
            [[Function sharedManager] Post:url Params:nil CompletionHandler:^(MKNetworkOperation *completed) {
                [self loadDataFromServer];
            }];
            
        }


}


- (IBAction)NavRightButtonAction:(id)sender {
    
    if(self.tableview.editing){
        [self.NavBarRightButton setImage:[UIImage imageNamed:@"ico_add_100w.png"]];
        [self.tableview setEditing:NO];
        
        NSString *OrderBy = @"";

        for (int i = 0; i < [TableViewData count]; i++){
            //NSLog(@"%@",[TableViewData objectAtIndex:i]);
            
            OrderBy = [OrderBy stringByAppendingFormat:@"||%@#%d", [[TableViewData objectAtIndex:i] objectForKey:@"sid"], i+1];
            
        }
        
        NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Album/SaveOrderBy/?LToken=%@",[Api LToken]];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:OrderBy forKey:@"orderby"];
        [[Function sharedManager] Post:url Params:params];
        
    }else{
        AlbumPicEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPicEditViewController"];
        vc.groupid = self.groupid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (IBAction)NavLeftButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


















@end
