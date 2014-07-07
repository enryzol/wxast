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
    
    NSURL *imageURL = [NSURL URLWithString:Url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}


/* 
#import "AppDelegate.h"
NSString *url = [NSString stringWithFormat:@"http://lcm.appspeed.cn/mobile/group/i/Ts136918416475591/g/%d",self.pid];

MKNetworkOperation *op = [[MKNetworkOperation alloc] initWithURLString:url params:nil httpMethod:@"GET"];

[op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
        self.orderby.text = jsonObject[@"name"];
        self.desc.text = jsonObject[@"desc"];
        
        self.imgview.image = [Common imageFromURL:jsonObject[@"img"]];
    }];
    
} errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    
}];

[ApplicationDelegate.Engin enqueueOperation:op];
 */


@end
