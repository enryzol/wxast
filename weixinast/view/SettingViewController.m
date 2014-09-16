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
#import "DescEditViewController.h"
#import "Function.h"
#import "Api.h"


@interface SettingViewController ()<CommonProtocol>

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
    
    [Api CheckLoginStatus:self];
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

- (IBAction)advice:(id)sender {
    
    DescEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DescEditViewController"];
    vc.SubjectStr = @"意见反馈";
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)CommonReturn:(NSString *)str Tag:(int)i{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Setting/Advice/?LToken=%@",[Api LToken]];
    NSDictionary *param = @{@"advice" : str};
    
    [[Function sharedManager] Post:url Params:param Message:@"正在提交您的意义建议" CompletionHandler:^(MKNetworkOperation *completed) {
        
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"提交成功" description:@"" type:TWMessageBarMessageTypeSuccess duration:1.5f];
        
    } ErrorHander:^(NSError *error) {
        
    }];
    
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
