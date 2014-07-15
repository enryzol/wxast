//
//  DescEditViewController.h
//  weixinast
//
//  Created by Jackie on 14-7-14.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonProtocol.h"

@interface DescEditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *Subject;
@property (weak, nonatomic) IBOutlet UITextView *textarea;
@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (weak, nonatomic) NSString *SubjectStr;
@property (weak, nonatomic) NSString *ContentStr;

- (IBAction)NavLeftButtonAction:(id)sender;
- (IBAction)NavRightButtonAction:(id)sender;

@property (weak, nonatomic) id<CommonProtocol>delegate;

@end
