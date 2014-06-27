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
    
    CGRect svframe = self.CtnScrollView.frame;
    svframe.origin.y = 64;
    svframe.size.height = self.view.frame.size.height;
    self.CtnScrollView.frame = svframe;
    
    self.CtnScrollView.pagingEnabled = YES;
    self.CtnScrollView.scrollEnabled = YES;
    self.CtnScrollView.showsVerticalScrollIndicator = YES;
    [self.CtnScrollView setContentSize:CGSizeMake(640, self.view.frame.size.height)];
    self.CtnScrollView.delegate = self;
    //[self.view addSubview:Content];
    
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
    [self.uploadimg addTarget:self action:@selector(UesrImageClicked) forControlEvents:UIControlEventTouchDown];
    
    [self LoadFromServer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
}

#pragma mark - 上传图集

- (void)UesrImageClicked
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从电脑上传", @"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从电脑上传",@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    //[sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    
        
    
    }];
    
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    controller.toolbarHidden = YES;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGFloat width  = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);

    controller.keepingCropAspectRatio = YES;
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          360 ,
                                          200 );
    
    [self.navigationController pushViewController:controller animated:NO];
    
}

#pragma mark - crop view delegate

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.uploadimg setBackgroundImage:croppedImage forState:UIControlStateNormal];
    
    NSLog(@" %f " , self.view.frame.origin.y);
    NSLog(@" %f " , self.CtnScrollView.frame.origin.y);
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    //[controller dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - Load Data

-(void)LoadFromServer{
    
    NSString *url = [NSString stringWithFormat:@"http://lcm.appspeed.cn/mobile/group/i/Ts136918416475591/g/%d",self.groupid];
    MKNetworkOperation *op = [[MKNetworkOperation alloc] initWithURLString:url params:nil httpMethod:@"GET"];
                              
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            self.name.text = jsonObject[@"name"];
            TableViewData = jsonObject[@"list"];
            [self.imgTableView reloadData];
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





@end
