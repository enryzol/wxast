//
//  AppDelegate.h
//  weixinast
//
//  Created by Jackie on 14-6-18.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//


#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MKNetworkEngine *CacheEngin;
@property (strong, nonatomic) MKNetworkEngine *Engin;

@end
