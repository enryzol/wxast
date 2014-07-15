//
//  NHomeViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-12.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "NHomeViewController.h"
#import "AlbumViewController.h"

@interface NHomeViewController ()

@end

@implementation NHomeViewController

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
    NSLog(@"UserAction");
}

- (IBAction)UserAction:(id)sender {
    NSLog(@"UserAction");
}

- (IBAction)MessageAction:(id)sender {
}

- (IBAction)SettingAction:(id)sender {
}
@end