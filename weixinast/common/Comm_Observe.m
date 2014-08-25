//
//  Comm_Observe.m
//  weixinast
//
//  Created by Jackie on 14-8-8.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "Comm_Observe.h"

@implementation Comm_Observe


+ (id)sharedManager {
    static Comm_Observe *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.AlbumListReflush = @"0";
        self.AlbumPicListReflush = @"0";
        self.BookEditViewControllerReflush = @"0";
        self.BookPicViewControllerReflush = @"0";
        self.LoginStatus = YES;
    }
    return self;
}


@end
