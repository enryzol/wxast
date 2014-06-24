//
//  ViewController.h
//  weixinast
//
//  Created by Jackie on 14-6-18.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIView *loginView;

- (IBAction)bgTapClose:(id)sender;
- (IBAction)LoginAct:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *regButton;

@end
