//
//  RegController.m
//  weixinast
//
//  Created by Jackie on 14-6-18.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "RegController.h"

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

-(void) closeWindow{
    
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
}


- (IBAction)RegNewAction:(id)sender {
}
@end
