//
//  AlbumEditViewController.m
//  weixinast
//
//  Created by Jackie on 14-6-25.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "AlbumEditViewController.h"
#import "AlbumTableViewCell.h"
#import "AppDelegate.h"
#import "PECropViewController.h"
#import "PECropView.h"
#import "AlbumPicEditViewController.h"

@interface AlbumEditViewController ()

@end

@implementation AlbumEditViewController{
    
    UIPageControl *pc ;
    NSMutableArray *TableViewData;
    PECropView *cropView;
    
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
    
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view.
    
    //Content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64)];
       
    [self.NavBar setFrame:CGRectMake(0, 0, 320, 64)];
    [self.NavBar setBackgroundColor:[UIColor greenColor]];
    
    self.name.delegate = self;
    self.keyword.delegate = self;
    self.desc.delegate = self;
    
    CGRect svframe = self.CtnScrollView.frame;
    svframe.origin.y = 64;
    svframe.size.height = self.view.frame.size.height;
    self.CtnScrollView.frame = svframe;
    
    self.CtnScrollView.pagingEnabled = YES;
    self.CtnScrollView.scrollEnabled = YES;
    self.CtnScrollView.showsVerticalScrollIndicator = YES;
    [self.CtnScrollView setContentSize:CGSizeMake(640, self.view.frame.size.height)];
    self.CtnScrollView.delegate = self;
    
    pc = [[UIPageControl alloc] init];
    pc.center = CGPointMake(160, self.view.frame.size.height - 20);
    pc.numberOfPages = 2;
    pc.currentPage = 0;
    [pc setCurrentPageIndicatorTintColor:[UIColor blackColor]];
    [pc setPageIndicatorTintColor:[UIColor colorWithRed:200.0f/255 green:200.0f/255 blue:200.0f/255 alpha:1]];
    [self.view addSubview:pc];
    
    CGRect frame = self.imgTableView.frame;
    frame.size.height = self.view.frame.size.height - 64;
    self.imgTableView.frame = frame;
    
    //
//    [self.uploadimg addTarget:self action:@selector(UesrImageClicked) forControlEvents:UIControlEventTouchDown];
    
    [self LoadFromServer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)selectimg:(id)sender{
    
    [super setKeepingCropAspectRatio:YES];
    [super setCrop:CGRectMake(0, 0, 320, 200)];
    [super selectimg:sender];
}

- (IBAction)NavBarLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)NavBarRightButton:(id)sender {
    AlbumPicEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPicEditViewController"];
    vc.pid = 0;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - crop view delegate

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.uploadimg setBackgroundImage:croppedImage forState:UIControlStateNormal];
}


#pragma mark - Load Data

-(void)LoadFromServer{
    
    NSString *url = [NSString stringWithFormat:@"/mobile/group/i/%@/g/%d",ApplicationDelegate.Package,self.groupid];
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:nil httpMethod:@"GET"];
                              
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            self.name.text = jsonObject[@"name"];
            TableViewData = jsonObject[@"list"];
            [self.imgTableView reloadData];
            
            NSLog(@"%@",jsonObject);
        }];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
    
}

#pragma mark - Scrollview Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView.tag == 100){
        pc.currentPage = scrollView.contentOffset.x / 320;
    }
    
    if(pc.currentPage == 1){
        self.NavBarRightButton.style = UIBarButtonItemStyleBordered;
        self.NavBarRightButton.enabled = YES;
        self.NavBarRightButton.title = @"添加新图";
    }else{
        //[self.NavBarRightButton setTitle:@" 1 "];
        self.NavBarRightButton.style = UIBarButtonItemStylePlain;
        self.NavBarRightButton.enabled = NO;
        self.NavBarRightButton.title = nil;
    }
    
}

#pragma mark - Tableview Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TableViewData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%@" , [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"sid"]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        AlbumTableViewCell *cellview = [[AlbumTableViewCell alloc]
                                        initWithFrame:CGRectMake(0, 0, 320, 120)
                                        Image:[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"img"]
                                        Title:@""
                                        Desc:[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"desc"]];
        
        
        cellview.backgroundColor = [UIColor clearColor];
        cellview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [cell addSubview:cellview];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 120.0f;}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AlbumPicEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPicEditViewController"];
    
    NSLog(@"%@",[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"sid"]);
    
    vc.pid = [[[TableViewData objectAtIndex:indexPath.row] objectForKey:@"sid"] intValue];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark -
#pragma mark 解决虚拟键盘挡住UITextField的方法

- (IBAction)bgTapClose:(id)sender {
    
    NSLog(@"bgTapClose");
    [self.name resignFirstResponder];
    [self.desc resignFirstResponder];
    [self.keyword resignFirstResponder];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
}




















@end
