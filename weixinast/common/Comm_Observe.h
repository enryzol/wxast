//
//  Comm_Observe.h
//  weixinast
//
//  Created by Jackie on 14-8-8.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comm_Observe : NSObject


+ (id)sharedManager;

@property NSString *AlbumListReflush;
@property NSString *AlbumEditReflush;
@property NSString *AlbumPicListReflush;
@property NSString *BookEditViewControllerReflush;
@property NSString *BookPicViewControllerReflush;

@property BOOL LoginStatus ;

@end
