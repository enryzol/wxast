//
//  BookPicViewController.m
//  weixinast
//
//  Created by Jackie on 14-8-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "BookPicViewController.h"
#import "AlbumBoardTableViewCell.h"
#import "BookPicEditViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "Api.h"
#import "Function.h"
#import "Comm_Observe.h"
#import "CommAction.h"


@interface BookPicViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@end



@implementation BookPicViewController{
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
    
    [self headerReFreshing];
    
    commAction = [[CommAction alloc] init];
    [commAction ObserverKey:@"BookPicViewControllerReflush" Callback:^(NSString *Key) {
        if ([[[Comm_Observe sharedManager] BookPicViewControllerReflush] isEqualToString:@"1"]) {
            [self headerReFreshing];
            [[Comm_Observe sharedManager] setBookPicViewControllerReflush:@"0"];
        }
    }];

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
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/piclist/?LToken=%@&beid=%@",[Api LToken],[self.Book objectForKey:@"beid"]];
    
    NSLog(@"%@",url);
    
    [[Function sharedManager] Post:url Params:nil CompletionHandler:^(MKNetworkOperation *completed) {
        
        id json = [completed responseJSON];
        if ([[Function sharedManager] CheckJSONNull:json[@"list"]]) {
            TableViewData = json[@"list"];
            [self.tableview reloadData];
        }
        NSLog(@"--%@",[completed responseString]);
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
    
    cell.Keyword.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"desc"];
    cell.Name.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"title"];
    
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
        
        BookPicEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookPicEditViewController"];
        vc.PictureInfo = [TableViewData objectAtIndex:actionSheet.tag];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (buttonIndex == 1){
        
        [self.tableview setEditing:YES];
        [self.NavBarRightButton setImage:[UIImage imageNamed:@"ico_done_100.png"] forState:UIControlStateNormal];
        
    }else if (buttonIndex == 2){
        
        NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/SetCover/?LToken=%@",[Api LToken]];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"biid"] forKey:@"biid"];
        [[Function sharedManager] Post:url Params:params];
        [[Comm_Observe sharedManager] setBookEditViewControllerReflush:@"1"];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if(buttonIndex == 0){
        //cancel
        
        NSLog(@"cancel");
    }else{
        //delete
        NSLog(@"delete");
        
        NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/DeletePic/?LToken=%@&biid=%@",[Api LToken] , [[TableViewData objectAtIndex:alertView.tag] objectForKey:@"biid"]];
        
        [[Function sharedManager] Post:url Params:nil CompletionHandler:^(MKNetworkOperation *completed) {
            [self loadDataFromServer];
        }];
        
    }
    
    
}


- (IBAction)NavBarLeftButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
};
- (IBAction)NavBarRightButton:(id)sender{
    
    if(self.tableview.editing){
        [self.NavBarRightButton setImage:[UIImage imageNamed:@"ico_add_100w.png"] forState:UIControlStateNormal];
        [self.tableview setEditing:NO];
        
        NSString *OrderBy = @"";
        
        for (int i = 0; i < [TableViewData count]; i++){
            //NSLog(@"%@",[TableViewData objectAtIndex:i]);
            OrderBy = [OrderBy stringByAppendingFormat:@"||%@#%d", [[TableViewData objectAtIndex:i] objectForKey:@"biid"], i+1];
        }
        
        NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/SaveOrderBy/?LToken=%@",[Api LToken]];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:OrderBy forKey:@"orderby"];
        [[Function sharedManager] Post:url Params:params];
    }else{
        BookPicEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookPicEditViewController"];
        vc.beid = [self.Book objectForKey:@"beid"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
};






















@end
