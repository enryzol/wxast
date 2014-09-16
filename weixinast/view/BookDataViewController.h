//
//  BookDataViewController.h
//  weixinast
//
//  Created by Jackie on 14-9-2.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDataViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property NSString * groupid ;
@property NSDictionary *Book ;
@property (weak, nonatomic) IBOutlet UILabel *BookStatus;

- (IBAction)NavBarLeftButton:(id)sender;
- (IBAction)CleanUp:(id)sender;


@end
