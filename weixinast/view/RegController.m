//
//  RegController.m
//  weixinast
//
//  Created by Jackie on 14-6-18.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "RegController.h"
#import "AppDelegate.h"
#import "Api.h"
#import "Function.h"

@interface RegController ()

@end

@implementation RegController

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
    
    self.Account.delegate = self;
    self.Bpassword.delegate = self;
    self.Password.delegate = self;
    self.Email.delegate = self;
    
    
}

-(IBAction) closeWindow{
    [self dismissViewControllerAnimated:YES completion:^{}];
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

#pragma mark -
#pragma mark 解决虚拟键盘挡住UITextField的方法

- (IBAction)bgTapClose:(id)sender {
    [self.Account resignFirstResponder];
    [self.Password resignFirstResponder];
    [self.Bpassword resignFirstResponder];
    [self.Email resignFirstResponder];
    
    NSLog(@"bgTapClose");
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (IBAction)Protocol:(id)sender {
    NSString *url = [NSString stringWithFormat:@"http://dodo.o-tap.com/protocal/"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)RegNewAction:(id)sender {
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Check/Register/"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.Account.text forKey:@"Account"];
    [params setValue:self.Password.text forKey:@"Password"];
    [params setValue:self.Bpassword.text forKey:@"Bpassword"];
    [params setValue:self.Email.text forKey:@"Email"];
    [params setValue:ApplicationDelegate._deviceToken forKey:@"deviceToken"];
    
    NSLog(@"%@",params);
    
    [[Function sharedManager] Post:url Params:params Message:@"正在注册新账号" CompletionHandler:^(MKNetworkOperation *completed) {
       
        id json = [completed responseJSON];
        if([json[@"status"] isEqualToString:@"success"]){
            
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"注册成功" description:@"请直接登录" type:TWMessageBarMessageTypeInfo duration:1.5f];
            [self closeWindow];
            
        }else{
            
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"注册失败" description:json[@"errormsg"] type:TWMessageBarMessageTypeInfo duration:2.5f];
            
        }
        
        
    } ErrorHander:^(NSError *error) {
        
        	[[TWMessageBarManager sharedInstance] showMessageWithTitle:@"操作失败" description:@"请检查网络后重试" type:TWMessageBarMessageTypeInfo duration:1.5f];
        
    }];
    
    
}
















@end
