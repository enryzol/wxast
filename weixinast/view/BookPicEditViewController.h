//
//  BookPicEditViewController.h
//  weixinast
//
//  Created by Jackie on 14-8-17.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "objectInputAdjustAndUploadImage.h"
#import "ImageViewFromUrl.h"

@interface BookPicEditViewController : objectInputAdjustAndUploadImage


@property (weak, nonatomic) IBOutlet UITextField *orderby;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UITextField *href;

@property (weak, nonatomic) IBOutlet UIButton *imgview;
@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (weak, nonatomic) IBOutlet ImageViewFromUrl *ImagePreView;

@property (weak, nonatomic) NSDictionary *PictureInfo;
@property (weak, nonatomic) NSString *beid;

@property int pid ;

-(IBAction)saveimg:(id)sender;

-(IBAction)selectimg:(id)sender;


- (IBAction)NavBarLeftButton:(id)sender;
- (IBAction)NavBarRightButton:(id)sender;

@end
