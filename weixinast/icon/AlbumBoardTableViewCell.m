//
//  AlbumBoardTableViewCell.m
//  weixinast
//
//  Created by Jackie on 14-7-12.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "AlbumBoardTableViewCell.h"
#import "AppDelegate.h"

@implementation AlbumBoardTableViewCell{
    UIActivityIndicatorView *indicator;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        NSLog(@"%@",self.uniqueID);
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setImageWithURL:(NSString*)url{
    
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 40, 16, 16)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicator.center = CGPointMake(40, 40);
    [self.Image addSubview:indicator];
    [indicator startAnimating];
    
    self.Image.image = nil;
    
    //异步加载图片
    MKNetworkOperation *op = [[MKNetworkOperation alloc] initWithURLString:url params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        if([url isEqualToString:self.uniqueID]){
            UIImage *img = [UIImage imageWithData:[completedOperation responseData]];
            
            self.Image.image = img;
            
            self.Image.layer.cornerRadius = 5.0f;
            [self.Image.layer setBorderWidth:0];
            [self.Image.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [self.Image.layer setMasksToBounds:YES];
            
            
            [indicator stopAnimating];
            
            if([completedOperation isCachedResponse]){
                //NSLog(@" from cache");
            }else{
                //NSLog(@" from server");
            }
        }

        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        
        
    }];
    
    [ApplicationDelegate.CacheEngin enqueueOperation:op];
    
}
@end
