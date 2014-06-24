//
//  Http.m
//  weixinast
//
//  Created by Jackie on 14-6-24.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "Http.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CommonCrypto/CommonDigest.h>

@implementation Http


+(void)getRequest:(NSString *)url File:(NSString*)file{
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:url customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:file params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        id json = [completedOperation responseJSON];
        
        NSLog(@"%@" , json);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
     
        NSLog(@"errrrror");
    
    }];
    
    [engine enqueueOperation:op];
}


// // Need to import for CC_MD5 access
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

@end
