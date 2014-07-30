//
//  ImageViewFromUrl.m
//  weixinast
//
//  Created by Jackie on 14-7-29.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "ImageViewFromUrl.h"
#import "AppDelegate.h"

@implementation ImageViewFromUrl{
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame Url:(NSString*)url Radius:(int)radius{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        [self setImageWithURL:url Radius:radius];
        
    }
    return self;
    
}

-(void)setImageWithURL:(NSString*)url Radius:(int)radius{
    
    if([url isEqualToString:@""] || url == nil){
        return ;
    }
    
    NSLog(@"imageviewfromurl - %@",url);
    
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 40, 16, 16)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicator.center = CGPointMake(40, 40);
    [self addSubview:indicator];
    [indicator startAnimating];
    

    
    
    //异步加载图片
    MKNetworkOperation *op = [[MKNetworkOperation alloc] initWithURLString:url params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        

            UIImage *img = [UIImage imageWithData:[completedOperation responseData]];
            
            self.image = img;
            self.layer.cornerRadius = radius;
            [self.layer setBorderWidth:0];
            [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [self.layer setMasksToBounds:YES];
            
            [indicator stopAnimating];
        
            if([completedOperation isCachedResponse]){
                NSLog(@" from cache");
            }else{
                NSLog(@" from server");
            }
        
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [ApplicationDelegate.CacheEngin enqueueOperation:op];
    
}


@end
