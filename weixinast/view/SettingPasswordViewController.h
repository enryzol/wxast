//
//  SettingPasswordViewController.h
//  weixinast
//
//  Created by Jackie on 14-8-1.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingPasswordViewController : UIViewController

@property NSString *password;

- (IBAction)Back:(id)sender;
- (IBAction)Save:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *npassword;
@property (weak, nonatomic) IBOutlet UITextField *bpassword;
- (IBAction)bgTap:(id)sender;

@end
