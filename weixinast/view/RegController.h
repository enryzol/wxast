//
//  RegController.h
//  weixinast
//
//  Created by Jackie on 14-6-18.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "objectInputAdjustAndUploadImage.h"

@interface RegController : objectInputAdjustAndUploadImage

@property (weak, nonatomic) IBOutlet UIButton *close;

@property (weak, nonatomic) IBOutlet UITextField *Account;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *Bpassword;
@property (weak, nonatomic) IBOutlet UITextField *Email;


- (IBAction)Protocol:(id)sender;

- (IBAction)RegNewAction:(id)sender;

- (IBAction)bgTapClose:(id)sender;

-(IBAction) closeWindow;

@end
