//
//  Common.m
//  weixinast
//
//  Created by Jackie on 14-6-20.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "Common.h"

@implementation Common


+(CGColorRef) getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha {
    
    CGFloat r = (CGFloat) red/255.0;
    CGFloat g = (CGFloat) green/255.0;
    CGFloat b = (CGFloat) blue/255.0;
    CGFloat a = (CGFloat) alpha;
    
//    NSLog(@"%f",r);
//    CGFloat components[4] = {r,g,b,a};
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    //CGColorRef color = (__bridge CGColorRef)(CFBridgingRelease(CGColorCreate(colorSpace, components)));
//    //CGColorSpaceRelease(colorSpace);
//    
//    CGColor col = [CGColorCreate(colorSpace, components)];
    
//    return [[UIColor yellowColor] CGColor];
    return [[UIColor colorWithRed:r green:g blue:b alpha:a] CGColor];
//    return color;
    
}

@end
