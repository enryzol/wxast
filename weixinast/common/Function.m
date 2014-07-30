//
//  Function.m
//  weixinast
//
//  Created by Jackie on 14-7-30.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "Function.h"
#import "AppDelegate.h"

@implementation Function{
    UIAlertView *alertView;
}


+ (id)sharedManager {
    static Function *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        alertView = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    }
    return self;
}

-(void)AlertViewShow:(NSString*)title{
    [alertView setTitle:title];
    [alertView show];
}

-(void)AlertViewHide{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)Post:(NSString*)url Params:(NSDictionary*)Param{
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:Param httpMethod:@"POST" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@",[completedOperation responseString]);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
}

-(void)Post:(NSString*)url Params:(NSDictionary*)Param CompletionHandler:(void (^)(MKNetworkOperation *completed))completionHandler{
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:Param httpMethod:@"POST" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        completionHandler(completedOperation);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
}

-(void)Post:(NSString*)url Params:(NSDictionary*)Param CompletionHandler:(void (^)(MKNetworkOperation *completed))completionHandler ErrorHander:(void (^)(NSError *))ErrorHander{
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:Param httpMethod:@"POST" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        completionHandler(completedOperation);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        ErrorHander(error);
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
}


























@end
