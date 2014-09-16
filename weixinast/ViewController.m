//
//  ViewController.m
//  weixinast
//
//  Created by Jackie on 14-6-18.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "ViewController.h"
#import "RegController.h"
#import "NHomeViewController.h"
#import "common/Common.h"
#import "AppDelegate.h"
#import "Api.h"
#import "Function.h"
#import "Comm_Observe.h"

#import <ShareSDK/ShareSDK.h>

@interface ViewController ()

@end

@implementation ViewController{

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect LovinViewFrame = self.loginView.frame ;
    LovinViewFrame.origin.y = self.view.frame.size.height - LovinViewFrame.size.height ;
    self.loginView.frame = LovinViewFrame ;
    
    [self.regButton addTarget:self action:@selector(openRegView) forControlEvents:UIControlEventTouchDown];
    
    self.username.delegate = self;
    self.password.delegate = self;
    
    self.username.text = @"";
    self.password.text = @"";
    
    [self.username setReturnKeyType:UIReturnKeyDone];
    [self.password setReturnKeyType:UIReturnKeyDone];

}

-(void)viewWillAppear:(BOOL)animated{
    self.username.text = @"";
    self.password.text = @"";
}
-(void)viewDidAppear:(BOOL)animated{

    BOOL CheckUser = [Api CheckUser];
    if(CheckUser){
        [self LoginSuccess];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark 解决虚拟键盘挡住UITextField的方法

- (IBAction)bgTapClose:(id)sender {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    //CGRect rect = CGRectMake(0.0f, 20.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
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

-(void)openRegView{
    

    RegController *vw = [self.storyboard instantiateViewControllerWithIdentifier:@"RegController"];
    
    vw.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:vw animated:YES completion:^{}];
    
}



- (IBAction)LoginAct:(id)sender {
    
    

    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Check/Login/"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.username.text forKey:@"name"];
    [params setValue:self.password.text forKey:@"password"];
    [params setValue:ApplicationDelegate._deviceToken forKey:@"deviceToken"];
    
    NSLog(@"%@",params);
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:params httpMethod:@"POST" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [[Function sharedManager] AlertViewHide];
        
        id json = [completedOperation responseJSON];
        
        NSString *status = json[@"status"];
        if([status isEqualToString:@"error"]){
            
            [[TWMessageBarManager sharedInstance] hideAllAnimated:NO];
            
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"登录失败" description:@"用户名或密码错误" type:TWMessageBarMessageTypeError duration:1.0f];
            
            return ;
            
        }else if ([status isEqualToString:@"success"]){
            [[TWMessageBarManager sharedInstance] hideAllAnimated:NO];
            
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            
            NSString *LToken = json[@"LToken"];
            if(![LToken isEqualToString:@""] && LToken != NULL){
                [userinfo setObject:LToken forKey:@"LToken"];
                [userinfo synchronize];
                NSLog(@"%@",LToken);
            }
            
            NSDictionary *User = json[@"info"];
            [userinfo setObject:User forKey:@"user"];
            [userinfo synchronize];
            
            [[Comm_Observe sharedManager] setLoginStatus:YES];
            [self LoginSuccess];
            
        }
        
        //NSLog(@"%@",json);
        NSLog(@"responseString - %@",[completedOperation responseString]);
        
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"登录失败" description:@"无法连接到服务器" type:TWMessageBarMessageTypeError duration:1.0f];
        
        [[Function sharedManager] AlertViewHide];
        
    }];
    
    [[Function sharedManager] AlertViewShow:@"正在登录中,请稍候"];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
    
    
}

-(void)LoginSuccess{
    NHomeViewController *hvw = [self.storyboard instantiateViewControllerWithIdentifier:@"NHomeViewController"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:hvw];
    nc.navigationBarHidden = YES;
    [self presentViewController:nc animated:YES completion:^{}];
}











@end
