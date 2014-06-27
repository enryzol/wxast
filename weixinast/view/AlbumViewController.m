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
#import "AlbumTableViewCell.h"
#import "AlbumEditViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController{
    
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
    
    //[self.abTableView.layer.frame.size.height = ]
    CGRect frame = self.abTableView.layer.frame;
    frame.origin.y = 0;
    frame.size.height = self.view.frame.size.height;
    self.abTableView.layer.frame = frame;
    
    [self.abTableView addHeaderWithTarget:self action:@selector(headerReFreshing)];
    [self.abTableView addFooterWithTarget:self action:@selector(footerReFreshing)];
    
    [self loadDataFromServer];
    
//    NSThread *loadData = [[NSThread alloc] initWithTarget:self selector:@selector(loadDataFromServer) object:nil];
//    [loadData start];
    
  
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self loadDataFromServer];
//    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - load data 

-(void)loadDataFromServer{
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"lcm.appspeed.cn" customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:@"/mobile/album/i/Ts136918416475591/p/1/" params:nil httpMethod:@"GET"];
    
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
    
    [engine enqueueOperation:op];
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
    
    AlbumEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumEditViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    vc.groupid = [[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"groupid"] integerValue];
    [self.navigationItem setTitle:@"图集列表"];

}











@end
