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
#import "Common.h"

#import "ImageViewFromUrl.h"
#import "const.h"
#import "AppDelegate.h"
#import "Api.h"
#import "Function.h"

@interface AlbumNEditViewController ()<CommonProtocol>

@end

@implementation AlbumNEditViewController{
    
    ImageViewFromUrl *AlbumPic ;
    UIImage *PostImgData;
    NSString * keywordIsOn;
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
    
    [self.NavBar setFrame:CGRectMake(0, 0, 320, 64)];
    [self.NavBar setBackgroundImage:[UIImage imageNamed:@"bg_top.png"] forBarMetrics:UIBarMetricsDefault];
    self.NavBar.topItem.title = [self.Album objectForKey:@"title"];
    
    self.Keyword.delegate = self;
    self.Desc.delegate = self;
    self.Title.delegate = self;
    
    self.Name.text = [self.Album objectForKey:@"title"];
    
    AlbumPic = [[ImageViewFromUrl alloc] initWithFrame:CGRectMake(210, 140, 70, 70) Url:[self.Album objectForKey:@"img"] Radius:10];
    
    [self.view addSubview:AlbumPic];
    
    NSLog(@"%@",Global_DescEditReturn);
    
    keywordIsOn = @"1";
    
    [self loadDataFromServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load data

-(void)loadDataFromServer{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Album/KeywordFromAlbum/?LToken=%@&groupid=%@",[Api LToken],[self.Album objectForKey:@"groupid"]];
    
    NSLog(@"%@",url);
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:nil httpMethod:@"GET" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [[Function sharedManager] AlertViewHide];
        
        id json = [completedOperation responseJSON];
        
        NSLog(@"%@",[completedOperation responseString]);
        
        [self.Keyword setText:json[@"keyword"]];
        [self.Desc setText:json[@"desc"]];
        [self.Title setText:json[@"return"]];
        [self.uploadimg setImageWithURL:json[@"image"] Radius:3];
        if(![json[@"status"] isEqualToString:@"1"]){
            [self.KeywordSwitch setOn:NO];
            [self.KeywordContainer setHidden:YES];
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        NSLog(@"%@",error);
        [[Function sharedManager] AlertViewHide];
        
    }];
    
    [[Function sharedManager] AlertViewShow:@"正在加载数据,请稍候"];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
}


#pragma mark - 通用代理返回

-(void)CommonReturn:(NSString *)str Tag:(int)i{
    
    NSLog(@"CommonReturn - %@" , str);
    self.Desc.text = str;
    
}


#pragma mark - 照相机
#pragma mark - crop view delegate

-(IBAction)selectimg:(id)sender{
    [super setKeepingCropAspectRatio:YES];
    [super setCrop:CGRectMake(0, 0, 360, 200)];
    [super selectimg:sender];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.uploadimg setBackgroundImage:croppedImage forState:UIControlStateNormal];
    self.uploadimg.image = croppedImage;
    
    PostImgData = [[UIImage alloc] init];
    PostImgData = croppedImage;
}
#pragma mark -
#pragma mark 解决虚拟键盘挡住UITextField的方法

- (IBAction)bgTapClose:(id)sender {
    
    NSLog(@"bgTapClose");
    [self.Name resignFirstResponder];
    [self.Desc resignFirstResponder];
    [self.Keyword resignFirstResponder];
    [self.Title resignFirstResponder];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0) + 340;//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark 按钮动作


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
    
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Album/SaveKeyword/?LToken=%@",[Api LToken]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[self.Album objectForKey:@"sid"] forKey:@"sid"];
    [params setValue:[self.Album objectForKey:@"groupid"] forKey:@"groupid"];
    [params setValue:self.Name.text forKey:@"name"];
    [params setValue:self.Keyword.text forKey:@"keyword"];
    [params setValue:self.Title.text forKey:@"title"];
    [params setValue:self.Desc.text forKey:@"desc"];
    [params setValue:keywordIsOn forKey:@"keywordIsOn"];
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:params httpMethod:@"POST" ssl:YES];
    
    if(PostImgData != nil){
        [op addData:UIImageJPEGRepresentation(PostImgData, 1.0f) forKey:@"img"];
    }
    
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //id json = [completedOperation responseJSON];
        //NSLog(@"%@",[completedOperation responseString]);
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"图集" description:@"数据保存成功" type:TWMessageBarMessageTypeSuccess duration:1.0f];
        
        [[Function sharedManager] AlertViewHide];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"图集" description:@"数据保存失败" type:TWMessageBarMessageTypeError duration:1.0f];
        
        [[Function sharedManager] AlertViewHide];
    }];
    
    //[[TWMessageBarManager sharedInstance] showMessageWithTitle:@"图集" description:@"正在保存数据" type:TWMessageBarMessageTypeInfo];
    
    [[Function sharedManager] AlertViewShow:@"正在保存数据,请稍候"];
    
    
    [ApplicationDelegate.Engin enqueueOperation:op];
    
}

- (IBAction)AlbumCoverAction:(id)sender {
    AlbumPicListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPicListViewController"];
    vc.groupid = [self.Album objectForKey:@"groupid"];
    vc.Album = self.Album;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)KeywordSwitchChange:(id)sender {
    
    UISwitch *switchButton = (UISwitch*)sender;
    
    if(switchButton.isOn){
        [UIView animateWithDuration:2000 animations:^{
            [self.KeywordContainer setHidden:NO];
        }];
        keywordIsOn = @"1";
    }else{
        [UIView animateWithDuration:2000 animations:^{
            [self.KeywordContainer setHidden:YES];
        }];
        keywordIsOn = @"0";
    }
}




























@end
