//
//  ImageViewFromUrl.h
//  weixinast
//
//  Created by Jackie on 14-7-29.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewFromUrl : UIImageView

-(id)initWithFrame:(CGRect)frame Url:(NSString*)url Radius:(int)radius;

-(void)setImageWithURL:(NSString*)url Radius:(int)radius;
@end
