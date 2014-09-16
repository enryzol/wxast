//
//  BookEditViewController.h
//  weixinast
//
//  Created by Jackie on 14-8-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewFromUrl.h"

@interface BookEditViewController : UIViewController


@property NSDictionary * Book;


@property (weak, nonatomic) IBOutlet UITextField *Title;
@property (weak, nonatomic) IBOutlet UITextField *Desc;
@property (weak, nonatomic) IBOutlet ImageViewFromUrl *ImgCover;


- (IBAction)bgTap;
- (IBAction)NavBarLeftButton:(id)sender;
- (IBAction)NavBarRightButton:(id)sender;
- (IBAction)AdvanceButton:(id)sender;
- (IBAction)WeixinButton:(id)sender;
- (IBAction)PicEdit:(id)sender;
- (IBAction)Desc:(id)sender;

@end
