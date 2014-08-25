//
//  BookWeixinViewController.h
//  weixinast
//
//  Created by Jackie on 14-8-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "objectInputAdjustAndUploadImage.h"
#import "ImageViewFromUrl.h"



@interface BookWeixinViewController : objectInputAdjustAndUploadImage

@property NSDictionary *Book;

@property (weak, nonatomic) IBOutlet ImageViewFromUrl *uploadimg;
@property (weak, nonatomic) IBOutlet UISwitch *KeywordSwitch;

@property (weak, nonatomic) IBOutlet UITextField *Keyword;
@property (weak, nonatomic) IBOutlet UITextField *Title;
@property (weak, nonatomic) IBOutlet UITextField *Desc;


- (IBAction)selectimg:(id)sender;
- (IBAction)DescEditAction:(id)sender;
- (IBAction)NavBarLeftButton:(id)sender;
- (IBAction)NavBarRightButton:(id)sender;
- (IBAction)KeywordSwitchChange:(id)sender;


@end
