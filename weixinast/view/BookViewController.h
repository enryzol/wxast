//
//  BookViewController.h
//  weixinast
//
//  Created by Jackie on 14-8-14.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *abTableView;

- (IBAction)NavBarLeftButton:(id)sender;
- (IBAction)NavBarRightButton:(id)sender;

@end
