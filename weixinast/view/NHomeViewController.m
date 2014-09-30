//
//  NHomeViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-12.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "NHomeViewController.h"
#import "AlbumViewController.h"
#import "UserViewController.h"
#import "Api.h"
#import "Function.h"
#import "SettingViewController.h"
#import "UserMessageViewController.h"
#import "BookViewController.h"

@interface NHomeViewController ()

@end

@implementation NHomeViewController{
    
    NSDictionary *User ;
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
    
    User = [[NSDictionary alloc] init];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    User = [userinfo objectForKey:@"user"];
    
    self.LoginNameLabel.text = [User objectForKey:@"name"];
    
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

- (IBAction)MemberSettingAction:(id)sender {
}

- (IBAction)AlbumAction:(id)sender {
    
    AlbumViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)BookAction:(id)sender {
    
    BookViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)UserAction:(id)sender {
    UserViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)MessageAction:(id)sender {
    
    UserMessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserMessageViewController"];
    [self.navigationController pushViewController:vc animated:YES];

    
}

- (IBAction)Report:(id)sender{
    NSString *url = [NSString stringWithFormat:@"http://dodo.o-tap.com/report/"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)SettingAction:(id)sender {
    
    NSLog(@"SettingAction");

    
    SettingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}
@end
