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
    [self.NavBar setBackgroundColor:[UIColor greenColor]];
    
    self.orderby.delegate = self;
    self.desc.delegate = self;
    
    
    self.orderby.text = [NSString stringWithFormat:@"pid=%d",self.pid];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)selectimg:(id)sender{
    [super setKeepingCropAspectRatio:YES];
    [super setCrop:CGRectMake(0, 0, 500, 500)];
    [super selectimg:sender];
}

- (IBAction)NavBarLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)LoadData{
    
    NSString *url = [NSString stringWithFormat:@"/mobile/group/i/%@/g/%d",ApplicationDelegate.Package,self.pid];
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            self.orderby.text = jsonObject[@"orderby"];
            self.desc.text = jsonObject[@"desc"];
            
            [self.imgview setBackgroundImage:[Common imageFromURL:jsonObject[@"img"]] forState:UIControlStateNormal];
            
            //NSLog(@"%@",jsonObject);
        }];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
}


- (IBAction)saveimg:(id)sender{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"savealbumpic" forKey:@"do"];
    [params setValue:self.desc.text forKey:@"desc"];
    [params setValue:self.orderby.text forKey:@"orderby"];
    [params setValue:[NSString stringWithFormat:@"%d",self.pid] forKey:@"pid"];
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:ApplicationDelegate.PostUrl params:params httpMethod:@"POST"];
    
    [op addData:UIImageJPEGRepresentation(img, 1.0f) forKey:@"img"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"POST请求完成 %@" , [completedOperation responseString]);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"POST请求出错");
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
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
    [self.orderby resignFirstResponder];
    [self.desc resignFirstResponder];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
}




















@end
