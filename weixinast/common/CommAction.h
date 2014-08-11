//
//  CommAction.h
//  weixinast
//
//  Created by Jackie on 14-8-8.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommAction : NSObject


-(void)ObserverKey:(NSString*)key Callback:(void (^)(NSString *Key))Handle;


@end
