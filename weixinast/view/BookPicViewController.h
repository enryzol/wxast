//
//  BookPicViewController.h
//  weixinast
//
//  Created by Jackie on 14-8-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookPicViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property NSString * groupid ;
@property NSDictionary *Book ;

@property (weak, nonatomic) IBOutlet UIButton *NavBarRightButton;


- (IBAction)NavBarLeftButton:(id)sender;
- (IBAction)NavBarRightButton:(id)sender;

@end
