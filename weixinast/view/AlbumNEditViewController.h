//
//  AlbumNEditViewController.h
//  weixinast
//
//  Created by Jackie on 14-7-14.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "objectInputAdjustAndUploadImage.h"

@interface AlbumNEditViewController : objectInputAdjustAndUploadImage

@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NavLeftButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NavRightButton;

@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (weak, nonatomic) IBOutlet UITextField *Keyword;
@property (weak, nonatomic) IBOutlet UITextField *Desc;
- (IBAction)DescEditAction:(id)sender;

- (IBAction)NavBarLeftButton:(id)sender;
- (IBAction)NavBarRightButton:(id)sender;
- (IBAction)AlbumCoverAction:(id)sender;


- (IBAction)bgTapClose:(id)sender;

@end
