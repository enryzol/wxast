//
//  AlbumEditViewController.h
//  weixinast
//
//  Created by Jackie on 14-6-25.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"
#import "objectInputAdjustAndUploadImage.h"

@interface AlbumEditViewController : objectInputAdjustAndUploadImage<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *CtnScrollView;
@property (weak, nonatomic) IBOutlet UITableView *imgTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NavBarRightButton;

@property (nonatomic) int groupid;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *keyword;
@property (weak, nonatomic) IBOutlet UITextField *desc;


@property (weak, nonatomic) IBOutlet UIButton *uploadimg;

-(IBAction)selectimg:(id)sender;
- (IBAction)NavBarLeftButton:(id)sender;
- (IBAction)NavBarRightButton:(id)sender;

@end
