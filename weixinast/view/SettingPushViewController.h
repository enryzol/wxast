//
//  SettingPushViewController.h
//  weixinast
//
//  Created by Jackie on 14-7-31.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingPushViewController : UIViewController

- (IBAction)Back:(id)sender;


@property (weak, nonatomic) IBOutlet UISwitch *BookPushSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *UserPushSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *MessagePushSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *SoundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *VibrateSwitch;

@property (weak, nonatomic) IBOutlet UITextField *BeginTime;
@property (weak, nonatomic) IBOutlet UITextField *EndTime;

- (IBAction)bgTap:(id)sender;


@end
