//
//  AlbumNEditViewController.h
//  weixinast
//
//  Created by Jackie on 14-7-14.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "objectInputAdjustAndUploadImage.h"
#import "ImageViewFromUrl.h"

@interface AlbumNEditViewController : objectInputAdjustAndUploadImage

@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NavLeftButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NavRightButton;

@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (weak, nonatomic) IBOutlet UITextField *Keyword;
@property (weak, nonatomic) IBOutlet UITextField *Title;
@property (weak, nonatomic) IBOutlet UITextField *Desc;
@property (weak, nonatomic) IBOutlet ImageViewFromUrl *uploadimg;

@property (weak, nonatomic) IBOutlet UISwitch *KeywordSwitch;

@property (weak, nonatomic) IBOutlet UIView *KeywordContainer;


@property NSDictionary * Album;

- (IBAction)selectimg:(id)sender;

- (IBAction)DescEditAction:(id)sender;
- (IBAction)NavBarLeftButton:(id)sender;
- (IBAction)NavBarRightButton:(id)sender;
- (IBAction)AlbumCoverAction:(id)sender;
- (IBAction)KeywordSwitchChange:(id)sender;


- (IBAction)bgTapClose:(id)sender;

@end
