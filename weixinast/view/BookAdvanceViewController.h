//
//  BookAdvanceViewController.h
//  weixinast
//
//  Created by Jackie on 14-8-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookAdvanceViewController : UIViewController

@property NSDictionary *Book;

@property (weak, nonatomic) IBOutlet UITextField *Count;
@property (weak, nonatomic) IBOutlet UITextField *Endtime;
@property (weak, nonatomic) IBOutlet UITextField *CountPerTime;
@property (weak, nonatomic) IBOutlet UISwitch *UserBookTime;
@property (weak, nonatomic) IBOutlet UITextField *BookContact;


- (IBAction)bgTap:(id)sender;

- (IBAction)NavBarLeftButton:(id)sender;
- (IBAction)NavBarRightButton:(id)sender;

@end
