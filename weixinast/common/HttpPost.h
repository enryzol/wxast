//
//  HttpPost.h
//  weixinast
//
//  Created by Jackie on 14-7-4.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HttpPostDelegate <NSObject>

@required

-(void)PostComplete:(BOOL)Request;

@end



@interface HttpPost : NSObject

@property id<HttpPostDelegate>delegate;

+(void)PostURL:(NSString*)url Param:(NSMutableArray*)param ;

@end
