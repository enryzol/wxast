//
//  AlbumTableViewCell.m
//  weixinast
//
//  Created by Jackie on 14-6-24.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "AlbumTableViewCell.h"
#import "Common.h"
#import "AppDelegate.h"

@implementation AlbumTableViewCell{
    
    NSString *_img , *_title , *_desc;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame Image:(NSString*)img Title:(NSString*)title Desc:(NSString*)desc
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _img = img;
        _title = title;
        _desc = desc;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 
 */

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 200, 50)];
    
    label.text = _title;
    
    [self addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, 200, 50)];
    
    label1.text = _desc;
    [label1 setFont:[UIFont fontWithName:@"System" size:8.0f]];
    [label1 setTextColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1]];
    
    [self addSubview:label1];
    

    //异步加载图片
    MKNetworkOperation *op = [[MKNetworkOperation alloc] initWithURLString:_img params:nil httpMethod:@"GET"];

    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        UIImage *img = [UIImage imageWithData:[completedOperation responseData]];
        UIImageView *imgview = [[UIImageView alloc] initWithImage:img];
        imgview.contentMode = UIViewContentModeScaleAspectFit;
        CGRect frame = imgview.frame;
        frame.size.height = 80;
        frame.size.width = 80;
        frame.origin.x = 20 ;
        frame.origin.y = 20 ;
        imgview.frame = frame;
        [self addSubview:imgview];

    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        
        
    }];
    
    [ApplicationDelegate.CacheEngin enqueueOperation:op];
    
    
    
//    UIImage *img = [Common imageFromURL:@"http://img.host1.o-tap.cn/u/app//default/noexist.png"];
    
    
    //UIImage *img = [Common imageFromURL:_img];
//    UIImageView *imgview = [[UIImageView alloc] initWithImage:img];
//    imgview.contentMode = UIViewContentModeScaleAspectFit;
//    CGRect frame = imgview.frame;
//    frame.size.height = 80;
//    frame.size.width = 80;
//    frame.origin.x = 20 ;
//    frame.origin.y = 20 ;
//    imgview.frame = frame;
//    [self addSubview:imgview];
    
    NSLog(@"drawRect imgview");
    

    
    
    
    
    //[self.layer setBackgroundColor:[[UIColor yellowColor] CGColor]];
}




@end
