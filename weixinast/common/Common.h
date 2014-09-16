//
//  Common.h
//  weixinast
//
//  Created by Jackie on 14-6-20.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject


+(CGColorRef) getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha ;

+(UIImage*)imageFromURL:(NSString*)Url;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;


@end
