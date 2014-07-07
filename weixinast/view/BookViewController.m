//
//  BookViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-7.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "BookViewController.h"
#import "MJRefresh.h"
#import "AlbumTableViewCell.h"

#import "AppDelegate.h"


@interface BookViewController (){
    NSMutableArray *TableViewData ;
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
    
    [self loadDataFromServer];
    
    [self.NavBar setFrame:CGRectMake(0, 0, 320, 64)];
    [self.NavBar setBackgroundColor:[UIColor blueColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load data

-(void)loadDataFromServer{
    
    
    NSString *url = [NSString stringWithFormat:@"/mobile/album/i/%@/p/1/",ApplicationDelegate.Package];
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        id json = [completedOperation responseJSON];
        
        if(TableViewData == nil){
            TableViewData = [[NSMutableArray alloc] init];
        }
        
        TableViewData = json;
        
        [self.abTableView reloadData];
        [self.abTableView headerEndRefreshing];
        
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Success" description:@"Reflesh Success" type:TWMessageBarMessageTypeSuccess duration:0.8f];
        
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
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%@" , [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"sid"]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        AlbumTableViewCell *cellview = [[AlbumTableViewCell alloc]
                                        initWithFrame:CGRectMake(0, 0, 320, 120)
                                        Image:[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"img"]
                                        Title:[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"title"]
                                        Desc:[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"desc"]];
        
        
        cellview.backgroundColor = [UIColor clearColor];
        cellview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [cell addSubview:cellview];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    AlbumEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumEditViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
//    vc.groupid = [[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"groupid"] integerValue];
//    [self.navigationItem setTitle:@"图集列表"];
    
}











- (IBAction)NavBarLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
