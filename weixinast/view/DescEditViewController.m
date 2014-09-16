//
//  DescEditViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-14.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "DescEditViewController.h"
#import "AlbumNEditViewController.h"
#import "Const.h"

@interface DescEditViewController ()

@end

@implementation DescEditViewController

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
 
    
    self.Subject.text = self.SubjectStr;
    self.textarea.text = [self.ContentStr stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
    
    
    
    NSLog(@"self.ContentStr -----%@" , self.ContentStr);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)test:(NSString*)str{
    
    self.Subject.text = str;
    
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
    [self.textarea resignFirstResponder];
}

- (IBAction)NavLeftButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)NavRightButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *s = [self.textarea.text stringByReplacingOccurrencesOfString: @"\n" withString: @"\r\n"];
    [self.delegate CommonReturn:s Tag:1];
}






















@end
