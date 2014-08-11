//
//  UserListViewController.h
//  weixinast
//
//  Created by Jackie on 14-7-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListViewController : UIViewController


@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITextField *NewFollerCount;
@property (weak, nonatomic) IBOutlet UITextField *New7DaysFollerCount;


- (IBAction)NavLeftButtonAction:(id)sender;



@end
