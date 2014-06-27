//
//  AlbumEditViewController.h
//  weixinast
//
//  Created by Jackie on 14-6-25.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"

@interface AlbumEditViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PECropViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *CtnScrollView;
@property (weak, nonatomic) IBOutlet UITableView *imgTableView;
@property (nonatomic) int groupid;

@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UIButton *uploadimg;

@end
