//
//  Http.h
//  weixinast
//
//  Created by Jackie on 14-6-24.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Http : NSObject

+(void)getRequest:(NSString *)url File:(NSString*)file;

+(NSString *)md5:(NSString *)str;


@end
