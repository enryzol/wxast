//
//  NHomeViewController.h
//  weixinast
//
//  Created by Jackie on 14-7-12.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHomeViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *LoginNameLabel;


- (IBAction)Report:(id)sender;
- (IBAction)MemberSettingAction:(id)sender;

- (IBAction)AlbumAction:(id)sender;
- (IBAction)BookAction:(id)sender;
- (IBAction)UserAction:(id)sender;
- (IBAction)MessageAction:(id)sender;
- (IBAction)SettingAction:(id)sender;




@end
