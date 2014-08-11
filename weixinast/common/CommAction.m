//
//  CommAction.m
//  weixinast
//
//  Created by Jackie on 14-8-8.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "CommAction.h"
#import "Comm_Observe.h"

@implementation CommAction{
    
    void(^_Handler)(NSString*);
    
}




-(void)ObserverKey:(NSString*)key Callback:(void (^)(NSString*))Handle{
    
    [[Comm_Observe sharedManager] addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
    _Handler = Handle;
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    _Handler(keyPath);
}





@end
