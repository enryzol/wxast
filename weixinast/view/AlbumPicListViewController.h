//
//  AlbumPicListViewController.h
//  weixinast
//
//  Created by Jackie on 14-7-14.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumPicListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NavBarRightButton;
@property NSString * groupid ;
@property NSDictionary * Album;

- (IBAction)NavRightButtonAction:(id)sender;
- (IBAction)NavLeftButtonAction:(id)sender;

@end
