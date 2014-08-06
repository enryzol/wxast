//
//  SettingViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-31.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingPushViewController.h"
#import "SettingUserInfoViewController.h"
#import "Function.h"
#import "Api.h"


@interface SettingViewController ()

@end

@implementation SettingViewController

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
    NSLog(@"viewDidLoad");
    
    
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

- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)MessagePush:(id)sender {
    
    SettingPushViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingPushViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)UserPush:(id)sender {
    SettingUserInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingUserInfoViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)Logout:(id)sender {
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Check/Logout/?LToken=%@",[Api LToken]];
    [[Function sharedManager] Post:url Params:nil Message:@"正在注销" CompletionHandler:^(MKNetworkOperation *completed) {
        
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        [userinfo removeObjectForKey:@"LToken"];
        [userinfo removeObjectForKey:@"user"];
        [userinfo synchronize];
        
        [self dismissViewControllerAnimated:YES completion:^{}];
        
    } ErrorHander:^(NSError *error) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"操作失败" description:@"从服务器上注销失败" type:TWMessageBarMessageTypeInfo duration:1.5f];
    }];

}












@end
