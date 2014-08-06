//
//  SettingUserInfoViewController.h
//  weixinast
//
//  Created by Jackie on 14-7-31.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingUserInfoViewController : UIViewController


- (IBAction)Back:(id)sender;
- (IBAction)Password:(id)sender;
- (IBAction)Email:(id)sender;
- (IBAction)advice:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (weak, nonatomic) IBOutlet UITextField *Username;


@end
