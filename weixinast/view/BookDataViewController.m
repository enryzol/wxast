//
//  BookDataViewController.m
//  weixinast
//
//  Created by Jackie on 14-9-2.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "BookDataViewController.h"
#import "AlbumBoardTableViewCell.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "Api.h"
#import "Function.h"
#import "Comm_Observe.h"
#import "CommAction.h"
#import "Common.h"
#import "BookDataEditViewController.h"



@interface BookDataViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@end

@implementation BookDataViewController{
    
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
    
    
    [self.BookStatus setText:[NSString stringWithFormat:@"预约总数  %@ / %@",[self.Book objectForKey:@"booked"] ,[self.Book objectForKey:@"count"]]];
    
    [self.tableview addHeaderWithTarget:self action:@selector(headerReFreshing)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadDataFromServer];
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
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/getData/?LToken=%@&beid=%@",[Api LToken],[self.Book objectForKey:@"beid"]];
    
    
    [[Function sharedManager] Post:url Params:nil CompletionHandler:^(MKNetworkOperation *completed) {
        
        id json = [completed responseJSON];
        if ([[Function sharedManager] CheckJSONNull:json[@"list"]]) {
            TableViewData = json[@"list"];
            [self.tableview reloadData];
        }
        
        [self.tableview headerEndRefreshing];
        [Api CheckLoginStatus:self];
        
    } ErrorHander:^(NSError *error) {
        [self.tableview headerEndRefreshing];
    }];
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
    
    static NSString *CellIdentifier = @"AlbumBoardCell";
    AlbumBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.Keyword.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"ctime"];
    cell.Name.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.Desc.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"iphonenote"];
    
    //[cell.Name sizeToFit];
    //[cell setImageWithURL:url];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"预约数据" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"拨打电话",@"复制数据",@"编辑",@"删除",@"取消", nil];
    [as setTag:indexPath.row];
    [as showInView:[UIApplication sharedApplication].keyWindow];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"contact"]];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
        NSLog(@"%@",telUrl);
    }else if(buttonIndex == 1){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"联系人：%@\r\n%@",[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"name"],[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"iphonenote"]];
    }else if(buttonIndex == 3){
        
        NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/DeleteBookData/?LToken=%@",[Api LToken]];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"bid"] forKey:@"bid"];
        [params setValue:[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"beid"] forKey:@"beid"];
        [[Function sharedManager] Post:url Params:params CompletionHandler:^(MKNetworkOperation *completed) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"设置成功" description:@"" type:TWMessageBarMessageTypeInfo];
            [self loadDataFromServer];
        }];
        
    }else if (buttonIndex == 2){
        
        BookDataEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookDataEditViewController"];
        vc.bid = [[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"bid"];
        vc.beid = [[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"beid"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/DeleteBookAllData/?LToken=%@",[Api LToken]];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[self.Book objectForKey:@"beid"] forKey:@"beid"];
        [[Function sharedManager] Post:url Params:params CompletionHandler:^(MKNetworkOperation *completed) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"删除成功" description:@"" type:TWMessageBarMessageTypeInfo duration:0.8f];
            //[self loadDataFromServer];
            TableViewData = [[NSMutableArray alloc] init];
            [self.tableview reloadData];
        }];
    }
    
}



- (IBAction)NavBarLeftButton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)CleanUp:(id)sender {
    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"警告" message:@"删除所有数据后将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认删除", nil];
    [av show];
}























@end
