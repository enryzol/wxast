//
//  BookDataEditViewController.h
//  weixinast
//
//  Created by Jackie on 14-9-3.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "objectInputAdjustAndUploadImage.h"

@interface BookDataEditViewController : objectInputAdjustAndUploadImage


@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *contact;
@property (weak, nonatomic) IBOutlet UILabel *note;
@property (weak, nonatomic) IBOutlet UITextField *count;
@property (weak, nonatomic) IBOutlet UITextField *date;

- (IBAction)bgTap:(id)sender;
- (IBAction)NavBarLeftButton:(id)sender;
- (IBAction)NavBarRightButton:(id)sender;

@property NSString *beid;
@property NSString *bid;

@end
