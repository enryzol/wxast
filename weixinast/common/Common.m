//
//  Common.m
//  weixinast
//
//  Created by Jackie on 14-6-20.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "Common.h"
#import "AppDelegate.h"

@implementation Common


+(CGColorRef) getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha {
    
    CGFloat r = (CGFloat) red/255.0;
    CGFloat g = (CGFloat) green/255.0;
    CGFloat b = (CGFloat) blue/255.0;
    CGFloat a = (CGFloat) alpha;
    
    return [[UIColor colorWithRed:r green:g blue:b alpha:a] CGColor];

}


+(UIImage*)imageFromURL:(NSString*)Url{
    
//    NSArray *tmp = [Url componentsSeparatedByString:@"/"];
//    
//    int i;
//    NSString *Host = [[NSString alloc] init];
//    NSString *File = [NSString stringWithFormat:@"%@",[tmp objectAtIndex:[tmp count]-1]];
//    for (i = 0; i<[tmp count]-1; i++) {
//        NSLog(@"%@",[tmp objectAtIndex:i]);
//        Host = [Host stringByAppendingFormat:@"%@/",[tmp objectAtIndex:i]];
//    }
    
    NSURL *imageURL = [NSURL URLWithString:Url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
   

//    NSString *file = [Url stringByReplacingOccurrencesOfString:@"http://img.host1.o-tap.cn/" withString:@"/"];
//    
//    MKNetworkOperation *op = [[MKNetworkOperation alloc] initWithURLString:file params:nil httpMethod:@"GET"];
//    
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        
//        UIImage *image = [UIImage imageWithData:[completedOperation responseData]];
//        
//        return image;
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        
//        
//    }];
//    
//    [ApplicationDelegate.CacheEngin enqueueOperation:op];

    
//    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@""];
//    MKNetworkOperation *op = [[MKNetworkOperation alloc] initWithURLString:@"" params:nil httpMethod:@"GET"];
//    [engine operationWithURLString:(NSString *) params:(NSDictionary *) httpMethod:(NSString *)]
    
    
    return image;
}


@end
