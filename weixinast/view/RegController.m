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
    
    [self.close addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchDown];
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

@end
