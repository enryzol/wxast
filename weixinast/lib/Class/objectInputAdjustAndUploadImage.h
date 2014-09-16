//
//  objectInputAdjustAndUploadImage.h
//  weixinast
//
//  Created by Jackie on 14-7-2.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"

@interface objectInputAdjustAndUploadImage : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PECropViewControllerDelegate>


-(IBAction)selectimg:(id)sender;

@property (nonatomic) BOOL keepingCropAspectRatio;
@property (nonatomic) CGRect Crop;

@end
