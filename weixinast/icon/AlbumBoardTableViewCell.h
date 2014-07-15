//
//  AlbumBoardTableViewCell.h
//  weixinast
//
//  Created by Jackie on 14-7-12.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumBoardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Keyword;
@property (weak, nonatomic) IBOutlet UITextView *Desc;

@property NSString *uniqueID;

-(void)setImageWithURL:(NSString*)url;


@end
