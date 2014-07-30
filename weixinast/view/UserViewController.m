//
//  UserViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "UserViewController.h"
#import "UserMessageViewController.h"
#import "UserListViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController

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
    [self.NavBar setFrame:CGRectMake(0, 0, 320, 64)];
    [self.NavBar setBackgroundImage:[UIImage imageNamed:@"bg_top.png"] forBarMetrics:UIBarMetricsDefault];
    
    
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

- (IBAction)NavLeftButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)UserMessageAction:(id)sender {
    UserMessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserMessageViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)UserListAction:(id)sender {
    UserListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)UserBlockAction:(id)sender {
}














@end
