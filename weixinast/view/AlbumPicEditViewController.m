//
//  AlbumPicEditViewController.m
//  weixinast
//
//  Created by Jackie on 14-6-27.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "AlbumPicEditViewController.h"
#import "AppDelegate.h"
#import "Common.h"
#import "Function.h"
#import "Api.h"
#import "Comm_Observe.h"
#import "Common.h"

@interface AlbumPicEditViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation AlbumPicEditViewController{
    UIImage *img ;
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
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    
    [self.NavBar setFrame:CGRectMake(0, 0, 320, 64)];
    [self.NavBar setBackgroundImage:[UIImage imageNamed:@"bg_top.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.href.delegate = self;
    self.desc.delegate = self;
    
    self.desc.text = [self.PictureInfo objectForKey:@"desc"];
    self.href.text = [self.PictureInfo objectForKey:@"link"];
    
    [self.ImagePreView setImageWithURL:[self.PictureInfo objectForKey:@"img"] Radius:5];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)selectimg:(id)sender{
    
    [self bgTapClose:self];
    
    [super setKeepingCropAspectRatio:NO];
    [super setCrop:CGRectMake(0, 0, 5000, 5000)];
    [super selectimg:sender];
}

- (IBAction)NavBarLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)NavBarRightButton:(id)sender {
    
    
    if(img == nil && self.PictureInfo == nil){
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"添加失败" description:@"请添加一张图片" type:TWMessageBarMessageTypeError];
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Album/SavePicture/?LToken=%@",[Api LToken]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[self.PictureInfo objectForKey:@"sid"] forKey:@"sid"];
    [params setValue:self.href.text forKey:@"link"];
    [params setValue:self.desc.text forKey:@"desc"];
    [params setValue:self.groupid forKey:@"groupid"];
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:params httpMethod:@"POST" ssl:YES];
    
    if(img != nil){
        [op addData:UIImageJPEGRepresentation(img, 1.0f) forKey:@"img"];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //id json = [completedOperation responseJSON];
        NSLog(@"%@",[completedOperation responseString]);
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"图集" description:@"数据保存成功" type:TWMessageBarMessageTypeSuccess duration:1.0f];
        
        [[Function sharedManager] AlertViewHide];
        [[Comm_Observe sharedManager] setAlbumPicListReflush:@"1"];
        
        if([self.PictureInfo objectForKey:@"sid"] == nil){
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"图集" description:@"数据保存失败" type:TWMessageBarMessageTypeError duration:1.0f];
        
        [[Function sharedManager] AlertViewHide];
    }];
  
    [[Function sharedManager] AlertViewShow:@"正在保存数据,请稍候"];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
    
}

-(void)LoadData{
    
    
}


- (IBAction)saveimg:(id)sender{
    
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    float height = 216.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
    
    
}

#pragma mark - crop view delegate
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    img = [[UIImage alloc] init];
    
    if(croppedImage.size.width > 800){
        img = [Common imageWithImage:croppedImage scaledToSize:CGSizeMake(500, croppedImage.size.height * 500 / croppedImage.size.width)];
    }else{
        img = croppedImage;
    }
    
    [self.imgview setBackgroundImage:croppedImage forState:UIControlStateNormal] ;
}


#pragma mark -
#pragma mark 解决虚拟键盘挡住UITextField的方法

- (IBAction)bgTapClose:(id)sender {
    [self.href resignFirstResponder];
    [self.desc resignFirstResponder];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}




















@end
