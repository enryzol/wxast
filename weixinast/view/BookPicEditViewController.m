//
//  BookPicEditViewController.m
//  weixinast
//
//  Created by Jackie on 14-8-17.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "BookPicEditViewController.h"
#import "AppDelegate.h"
#import "Common.h"
#import "Function.h"
#import "Api.h"
#import "Comm_Observe.h"


@interface BookPicEditViewController ()

@end

@implementation BookPicEditViewController{
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
    
    
    [self.ImagePreView setImageWithURL:[self.PictureInfo objectForKey:@"img"] Radius:5];
    self.desc.text = [self.PictureInfo objectForKey:@"desc"];
    self.href.text = [self.PictureInfo objectForKey:@"title"];
    
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


-(IBAction)selectimg:(id)sender{
    [super setKeepingCropAspectRatio:NO];
    [super setCrop:CGRectMake(0, 0, 5000, 5000)];
    [super selectimg:sender];
}

-(IBAction)saveimg:(id)sender{
    
}

- (IBAction)NavBarLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)NavBarRightButton:(id)sender {
    
    
    if(img == nil && self.PictureInfo == nil){
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"添加失败" description:@"请添加一张图片" type:TWMessageBarMessageTypeError];
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/SavePicture/?LToken=%@",[Api LToken]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[self.PictureInfo objectForKey:@"biid"] forKey:@"biid"];
    [params setValue:self.href.text forKey:@"title"];
    [params setValue:self.desc.text forKey:@"desc"];
    [params setValue:self.beid forKey:@"beid"];
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:params httpMethod:@"POST" ssl:YES];
    
    if(img != nil){
        [op addData:UIImageJPEGRepresentation(img, 1.0f) forKey:@"img"];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        //id json = [completedOperation responseJSON];
        NSLog(@"%@",[completedOperation responseString]);
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"图集" description:@"数据保存成功" type:TWMessageBarMessageTypeSuccess duration:1.0f];
        
        [[Function sharedManager] AlertViewHide];
        [[Comm_Observe sharedManager] setBookPicViewControllerReflush:@"1"];
        
        if([self.PictureInfo objectForKey:@"biid"] == nil){
            [self.navigationController popViewControllerAnimated:YES];
        }
        [Api CheckLoginStatus:self];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"图集" description:@"数据保存失败" type:TWMessageBarMessageTypeError duration:1.0f];
    }];
    
    [[Function sharedManager] AlertViewShow:@"正在保存数据,请稍候"];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
    
}

-(void)LoadData{
    
    
}



#pragma mark - crop view delegate
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [self.navigationController popViewControllerAnimated:YES];
    img = [[UIImage alloc] init];
    img = croppedImage;
    
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
