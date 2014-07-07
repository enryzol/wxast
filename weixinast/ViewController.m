//
//  ViewController.m
//  weixinast
//
//  Created by Jackie on 14-6-18.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "ViewController.h"
#import "RegController.h"
#import "HomeViewController.h"
#import "common/Common.h"

@interface ViewController ()

@end

@implementation ViewController

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
    
    [Common imageFromURL:@"http://www.sss.com/sss.png"];
    
}

-(void)openRegView{
    
    RegController *vw = [self.storyboard instantiateViewControllerWithIdentifier:@"RegController"];
    
    vw.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:vw animated:YES completion:^{}];
    
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




- (IBAction)LoginAct:(id)sender {
    
    //[self performSegueWithIdentifier:@"LoginPush" sender:self];
    
    HomeViewController *hvw = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    //[self presentViewController:hvw animated:YES completion:^{}];
    
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:hvw];
    nc.navigationBarHidden = YES;
    [self presentViewController:nc animated:YES completion:^{}];
    
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    
//    
//}












@end
