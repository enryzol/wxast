//
//  SettingUserInfoViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-31.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "SettingUserInfoViewController.h"
#import "SettingPasswordViewController.h"
#import "DescEditViewController.h"
#import "Function.h"
#import "Api.h"

@interface SettingUserInfoViewController ()<UIAlertViewDelegate,CommonProtocol>

@end

@implementation SettingUserInfoViewController{
    
//    int CONST_PASSWORD_TAG = 100;
//    int CONST_EMAIL_TAG = 101;
//    int CONST_ADVICE_TAG = 102;
    
    NSUserDefaults *userDefault;
    NSDictionary *user;
    
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
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
    user = [userDefault objectForKey:@"user"];
    
    self.Email.text = [user objectForKey:@"email"];
    self.Username.text = [user objectForKey:@"name"];
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

- (IBAction)Password:(id)sender {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请输入原密码" message:@"更改新密码前，请输入原始密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    av.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [av setTag:101];
    [av show];
}

- (IBAction)Email:(id)sender {
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请新邮件地址" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [av setTag:100];
    
    [av show];
    
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
    
    [[Function sharedManager] Post:url Params:param Message:@"正在保存" CompletionHandler:^(MKNetworkOperation *completed) {
        
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"保存成功" description:@"" type:TWMessageBarMessageTypeSuccess duration:1.5f];
        
    } ErrorHander:^(NSError *error) {
        
    }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        if (alertView.tag == 101) {
            SettingPasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingPasswordViewController"];
            
            vc.password = [alertView textFieldAtIndex:0].text;
            
            [self.navigationController pushViewController:vc animated:YES];
        }else if (alertView.tag == 100){
            
            NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Setting/Email/?LToken=%@",[Api LToken]];
            NSDictionary *param = @{@"email" : [alertView textFieldAtIndex:0].text};
            
            [[Function sharedManager] Post:url Params:param Message:@"正在保存" CompletionHandler:^(MKNetworkOperation *completed) {
                
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"保存成功" description:@"" type:TWMessageBarMessageTypeSuccess duration:1.5f];
                
                [user setValue:[alertView textFieldAtIndex:0].text forKey:@"email"];
                [userDefault setValue:user forKey:@"user"];
                [userDefault synchronize];
                
                self.Email.text = [alertView textFieldAtIndex:0].text;
                
            } ErrorHander:^(NSError *error) {
                
            }];
            
            
        }
       
        
    }
    
}




















@end
