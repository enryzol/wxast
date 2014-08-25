//
//  BookWeixinViewController.m
//  weixinast
//
//  Created by Jackie on 14-8-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "BookWeixinViewController.h"
#import "DescEditViewController.h"
#import "CommonProtocol.h"
#import "Common.h"

#import "ImageViewFromUrl.h"
#import "const.h"
#import "AppDelegate.h"
#import "Api.h"
#import "Function.h"
#import "Comm_Observe.h"


@interface BookWeixinViewController ()<CommonProtocol>

@end

@implementation BookWeixinViewController{
    UIImage *PostImgData;
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
    
    [self LoadFromServer];
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

#pragma mark - loadfromserver
-(void)LoadFromServer{
    
    [[Function sharedManager] Post:[NSString stringWithFormat:@"/Device/iPhone/Book/KeywordFromBook?LToken=%@&beid=%@",[Api LToken],[self.Book objectForKey:@"beid"]] Params:nil Message:@"正在加载数据" CompletionHandler:^(MKNetworkOperation *completed) {
        
        NSLog(@"%@",[completed responseString]);
        
        id json = [completed responseJSON];
        
        if([[Function sharedManager] CheckJSONNull:json[@"info"]]){
            
            
            self.Keyword.text = json[@"info"][@"keyword"];
            self.Title.text = json[@"info"][@"return"];
            [self.Desc setText:json[@"info"][@"desc"]];

            [self.uploadimg setImageWithURL:json[@"info"][@"image"] Radius:3];
            if(![json[@"info"][@"status"] isEqualToString:@"1"]){
                [self.KeywordSwitch setOn:NO];
            }
        }
        
    } ErrorHander:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"加载失败" description:@"请检查网络后重试" type:TWMessageBarMessageTypeError];
    }];
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


- (IBAction)DescEditAction:(id)sender {
    DescEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DescEditViewController"];
    vc.SubjectStr = @"公众平台 - 内容概要";
    vc.ContentStr = [NSString stringWithFormat:@"%@",self.Desc.text];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)bgTapClose:(id)sender {
    [self.Keyword resignFirstResponder];
    [self.Title resignFirstResponder];
    [self.Desc resignFirstResponder];
}

- (IBAction)NavBarLeftButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
};

- (IBAction)NavBarRightButton:(id)sender{
    NSMutableDictionary * param  = [[NSMutableDictionary alloc] init];
    
    [param setValue:(self.KeywordSwitch.isOn)?@"1":@"0" forKey:@"KeywordSwitch"];
    [param setValue:self.Title.text forKey:@"title"];
    [param setValue:self.Keyword.text forKey:@"keyword"];
    [param setValue:self.Desc.text forKey:@"desc"];
    [param setValue:[self.Book objectForKey:@"beid"] forKey:@"beid"];
    
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:[NSString stringWithFormat:@"/Device/iPhone/Book/SaveWeixin?LToken=%@",[Api LToken]] params:param httpMethod:@"POST" ssl:YES];
    
    if(PostImgData != nil){
        [op addData:UIImageJPEGRepresentation(PostImgData, 1.0f) forKey:@"img"];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSLog(@"%@",[completedOperation responseString]);
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"预约" description:@"数据保存成功" type:TWMessageBarMessageTypeSuccess duration:1.0f];
        
        [[Function sharedManager] AlertViewHide];
        [Api CheckLoginStatus:self];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"预约" description:@"数据保存失败" type:TWMessageBarMessageTypeError duration:1.0f];
        
        [[Function sharedManager] AlertViewHide];
    }];
    
    [[Function sharedManager] AlertViewShow:@"正在保存数据,请稍候"];
    
    [ApplicationDelegate.Engin enqueueOperation:op];

};

- (IBAction)KeywordSwitchChange:(id)sender {
    
    
}




















@end
