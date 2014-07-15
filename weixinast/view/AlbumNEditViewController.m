//
//  AlbumNEditViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-14.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "AlbumNEditViewController.h"
#import "DescEditViewController.h"
#import "AlbumPicListViewController.h"
#import "CommonProtocol.h"

#import "const.h"

@interface AlbumNEditViewController ()<CommonProtocol>

@end

@implementation AlbumNEditViewController

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
    
    [self.NavBar setFrame:CGRectMake(0, 0, 320, 64)];
    [self.NavBar setBackgroundImage:[UIImage imageNamed:@"bg_top.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.Name.delegate = self;
    self.Keyword.delegate = self;
    self.Desc.delegate = self;
    
    NSLog(@"%@",Global_DescEditReturn);
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


#pragma mark - 通用代理返回

-(void)CommonReturn:(NSString *)str Tag:(int)i{
    
    NSLog(@"CommonReturn - %@" , str);
    self.Desc.text = str;
    
}

#pragma mark -
#pragma mark 解决虚拟键盘挡住UITextField的方法

- (IBAction)bgTapClose:(id)sender {
    
    NSLog(@"bgTapClose");
    [self.Name resignFirstResponder];
    [self.Desc resignFirstResponder];
    [self.Keyword resignFirstResponder];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
}




- (IBAction)DescEditAction:(id)sender {
    DescEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DescEditViewController"];
    vc.SubjectStr = @"公众平台 - 内容概要";
    vc.ContentStr = self.Desc.text;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)NavBarLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)NavBarRightButton:(id)sender {
}

- (IBAction)AlbumCoverAction:(id)sender {
    AlbumPicListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPicListViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}




























@end
