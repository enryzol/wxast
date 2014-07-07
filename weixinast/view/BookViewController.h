//
//  BookViewController.h
//  weixinast
//
//  Created by Jackie on 14-7-7.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *abTableView;

@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;

- (IBAction)NavBarLeftButton:(id)sender;


@end
