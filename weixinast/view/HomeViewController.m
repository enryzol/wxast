//
//  HomeViewController.m
//  weixinast
//
//  Created by Jackie on 14-6-20.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "HomeViewController.h"
#import "ButtonHomeNav.h"
#import "Common.h"
#import "AlbumViewController.h"
#import "BookViewController.h"

#import <ShareSDK/ShareSDK.h>

@interface HomeViewController ()

@end

@implementation HomeViewController{
    
    UIScrollView *HomeScrollView ;
    
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
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    
    int height = 295;
    if(self.view.frame.size.height < 520){
        height = 225;
        [self adjustNavHeight:self.NavLeft];
        [self adjustNavHeight:self.NavMiddle];
        [self adjustNavHeight:self.NavRight];
    }
    
    HomeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - height, 320, height)];
    HomeScrollView.backgroundColor = [UIColor whiteColor];
    HomeScrollView.pagingEnabled = YES;
    HomeScrollView.showsHorizontalScrollIndicator = YES;
    HomeScrollView.showsVerticalScrollIndicator = YES;
    [HomeScrollView setContentSize:CGSizeMake(320*3, height)];
    HomeScrollView.delegate = self;
    HomeScrollView.bounces = NO;
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    btn.backgroundColor = [UIColor orangeColor];
    [HomeScrollView addSubview:btn];
    
    [btn addTarget:self action:@selector(LinkAlbum:) forControlEvents:UIControlEventTouchDown];
    
    UIButton *btn_1 = [[UIButton alloc] initWithFrame:CGRectMake(120, 20, 80, 80)];
    btn_1.backgroundColor = [UIColor orangeColor];
    [HomeScrollView addSubview:btn_1];
    
    [btn_1 addTarget:self action:@selector(LinkBook:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn_2 = [[UIButton alloc] initWithFrame:CGRectMake(220, 20, 80, 80)];
    btn_2.backgroundColor = [UIColor orangeColor];
    [HomeScrollView addSubview:btn_2];
    
    [btn_2 addTarget:self action:@selector(Share) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn_3 = [[UIButton alloc] initWithFrame:CGRectMake(20, 120, 80, 80)];
    btn_3.backgroundColor = [UIColor orangeColor];
    [HomeScrollView addSubview:btn_3];
    
    [btn_3 addTarget:self action:@selector(scanQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(320, 0, 100, 50)];
    btn1.backgroundColor = [UIColor blackColor];
    [HomeScrollView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(640, 0, 100, 50)];
    btn2.backgroundColor = [UIColor blueColor];
    [HomeScrollView addSubview:btn2];
    
    
    
    //[self.view addSubview:btn];
    [self.view addSubview:HomeScrollView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.NavLeft Title:@"关注者" Count:2210 Notice:0];
    [self.NavMiddle Title:@"消息" Count:27 Notice:0];
    [self.NavRight Title:@"统计" Count:309 Notice:15];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self changeNavTo:0];
}

-(void)changeNavTo:(int)i{
    
    if(i==0){
        [self.NavLeft.layer setBackgroundColor:[Common getColorFromRed:250 Green:250 Blue:250 Alpha:1]];
        [self.NavMiddle.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
        [self.NavRight.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
    }else if (i==1){
        [self.NavLeft.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
        [self.NavMiddle.layer setBackgroundColor:[Common getColorFromRed:250 Green:250 Blue:250 Alpha:1]];
        [self.NavRight.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
    }else if (i==2){
        [self.NavLeft.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
        [self.NavMiddle.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
        [self.NavRight.layer setBackgroundColor:[Common getColorFromRed:250 Green:250 Blue:250 Alpha:1]];
    }
    
}

-(void)adjustNavHeight:(ButtonHomeNav*)button{
    CGRect frame = button.frame;
    frame.origin.y = frame.origin.y - 20;
    button.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int i = 0;
    i = scrollView.contentOffset.x / self.view.frame.size.width;
    [self changeNavTo:i];
    
}


#pragma mark -push 

-(void)LinkAlbum:(id)sender{
    AlbumViewController *ac = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumViewController"];
    [self.navigationController pushViewController:ac animated:YES];
}

-(void)LinkBook:(id)sender{
    BookViewController *ac = [self.storyboard instantiateViewControllerWithIdentifier:@"BookViewController"];
    [self.navigationController pushViewController:ac animated:YES];
}

-(void)Share{
    NSLog(@"share");
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"0"  ofType:@"png"];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

-(void)scanQRCode{

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    

    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
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

- (IBAction)NavLeftClick:(id)sender {
    [HomeScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self changeNavTo:0];
}

- (IBAction)NavMiddleClick:(id)sender {
    [HomeScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    [self changeNavTo:1];
}

- (IBAction)NavRightClick:(id)sender {
    [HomeScrollView setContentOffset:CGPointMake(640, 0) animated:YES];
    [self changeNavTo:2];
}
















@end
