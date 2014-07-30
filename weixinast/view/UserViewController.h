//
//  UserViewController.h
//  weixinast
//
//  Created by Jackie on 14-7-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;

- (IBAction)NavLeftButtonAction:(id)sender;

- (IBAction)UserMessageAction:(id)sender;
- (IBAction)UserListAction:(id)sender;
- (IBAction)UserBlockAction:(id)sender;

@end
