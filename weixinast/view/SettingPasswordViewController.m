//
//  SettingPasswordViewController.m
//  weixinast
//
//  Created by Jackie on 14-8-1.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "SettingPasswordViewController.h"
#import "Function.h"
#import "Api.h"

@interface SettingPasswordViewController ()

@end

@implementation SettingPasswordViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)CheckPassword{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Setting/Password/?LToken=%@",[Api LToken]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.password forKey:@"password"];
    [param setValue:self.npassword.text forKey:@"npassword"];
    [param setValue:self.bpassword.text forKey:@"bpassword"];
    
    
    [[Function sharedManager] Post:url Params:param Message:@"正在保存" CompletionHandler:^(MKNetworkOperation *completed) {
        
        NSLog(@"%@",[completed responseString]);
        id json = [completed responseJSON];
        if([json[@"status"] isEqualToString:@"success"]){
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"密码更改成功" description:@"" type:TWMessageBarMessageTypeSuccess duration:2.0];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([json[@"status"] isEqualToString:@"errorPassword"]){
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"密码更改失败" description:@"请输入正确的原始密码" type:TWMessageBarMessageTypeSuccess duration:2.0];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([json[@"status"] isEqualToString:@"errorDoublePassword"]){
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"密码更改失败" description:@"两次新密码输入不一致" type:TWMessageBarMessageTypeSuccess duration:2.0];
        }
        
    } ErrorHander:^(NSError *error) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"密码更改失败" description:@"无法连接至服务器" type:TWMessageBarMessageTypeSuccess duration:2.0];
    }];
    
    
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

- (IBAction)Save:(id)sender {
    
    [self CheckPassword];
    
}
- (IBAction)bgTap:(id)sender {
    [self.npassword resignFirstResponder];
    [self.bpassword resignFirstResponder];
}
@end
