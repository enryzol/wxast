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
    
    UILabel *Lable_img , *Label_title , *Label_desc;
    
    UIView *ImageView;
    
    UIActivityIndicatorView *indicator;
    
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
    
    if([self.Style isEqualToString:@"style01"]){
        
        Label_desc = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 200, 50)];
        Label_desc.text = _desc;
        [Label_desc setFont:[UIFont fontWithName:@"System" size:12.0f]];
        [Label_desc setTextColor:[UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1]];
        [self addSubview:Label_desc];
        
    }else{
        Label_title = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 200, 50)];
        Label_title.text = _title;
        [self addSubview:Label_title];
        
        Label_desc = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, 200, 50)];
        Label_desc.text = _desc;
        [Label_desc setFont:[UIFont fontWithName:@"System" size:8.0f]];
        [Label_desc setTextColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1]];
        [self addSubview:Label_desc];
    }
   
    
    
    
    ImageView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 40, 16, 16)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicator.center = CGPointMake(40, 40);
    [ImageView addSubview:indicator];
    [indicator startAnimating];
    
    [self addSubview:ImageView];

    //异步加载图片
    MKNetworkOperation *op = [[MKNetworkOperation alloc] initWithURLString:_img params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        UIImage *img = [UIImage imageWithData:[completedOperation responseData]];
        UIImageView *imgview = [[UIImageView alloc] initWithImage:img];
        imgview.contentMode = UIViewContentModeScaleAspectFit;
        
        [ImageView addSubview:imgview];

        CGRect frame = imgview.frame;
        frame.size.height = 80;
        frame.size.width = 80;
        frame.origin.x = 0 ;
        frame.origin.y = 0 ;
        imgview.frame = frame;

        [indicator stopAnimating];
        
        if([completedOperation isCachedResponse]){
            //NSLog(@" from cache");
        }else{
            //NSLog(@" from server");
        }

    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        
        
    }];
    
    [ApplicationDelegate.CacheEngin enqueueOperation:op];
    
}




@end
