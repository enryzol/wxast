//
//  HomeViewController.h
//  weixinast
//
//  Created by Jackie on 14-6-20.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonHomeNav.h"

@interface HomeViewController : UIViewController< UIScrollViewDelegate,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet ButtonHomeNav *NavLeft;
@property (weak, nonatomic) IBOutlet ButtonHomeNav *NavMiddle;
@property (weak, nonatomic) IBOutlet ButtonHomeNav *NavRight;


- (IBAction)NavLeftClick:(id)sender;
- (IBAction)NavMiddleClick:(id)sender;
- (IBAction)NavRightClick:(id)sender;



@end
