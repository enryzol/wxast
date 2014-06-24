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
    frame.size.height = self.view.frame.size.height - 80;
    self.abTableView.layer.frame = frame;
    
    [self.abTableView addHeaderWithTarget:self action:@selector(headerReFreshing)];
    [self.abTableView addFooterWithTarget:self action:@selector(footerReFreshing)];
    
    [self loadDataFromServer];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"title"];
    // Configure the cell...
    
    return cell;
    
}






@end
