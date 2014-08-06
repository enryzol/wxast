//
//  Function.h
//  weixinast
//
//  Created by Jackie on 14-7-30.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Function : NSObject


+ (id)sharedManager;


-(BOOL)CheckJSONNull:(id)Value;

-(void)AlertViewShow:(NSString*)title;
-(void)AlertViewHide;


-(void)Post:(NSString*)url Params:(NSDictionary*)Param;
-(void)Post:(NSString*)url Params:(NSDictionary*)Param CompletionHandler:(void (^)(MKNetworkOperation *completed))completionHandler;
-(void)Post:(NSString*)url Params:(NSDictionary*)Param CompletionHandler:(void (^)(MKNetworkOperation *completed))completionHandler ErrorHander:(void (^)(NSError *error))ErrorHander;

-(void)Post:(NSString*)url Params:(NSDictionary*)Param Message:(NSString*)message CompletionHandler:(void (^)(MKNetworkOperation *completed))completionHandler ErrorHander:(void (^)(NSError *error))ErrorHander;

@end
