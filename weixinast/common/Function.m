//
//  Function.m
//  weixinast
//
//  Created by Jackie on 14-7-30.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "Function.h"
#import "AppDelegate.h"
#import "Comm_Observe.h"

@implementation Function{
    UIAlertView *alertView;
    UIAlertController * AlertController;
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

        //AlertController = [	UIAlertController  alertControllerWithTitle:<#(NSString *)#> message:<#(NSString *)#> preferredStyle:<#(UIAlertControllerStyle)#>]
    }
    return self;
}


-(BOOL)CheckJSONNull:(id)Value{
    if(Value == (id)[NSNull null]){
        return false;
    }else if([Value isKindOfClass:[NSString class]] && [Value isEqualToString:@""]){
        return false;
    }else{
        return YES;
    }
}


-(void)AlertViewShow:(NSString*)title{
//    if(alertView == nil){
//        NSLog(@"asdfasdfasf alertView = null ");
//    }
    
//    alertView = nil;
//    alertView  = [[UIAlertView alloc] initWithTitle:nil message:title delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView setTitle:title];
    [alertView show];

}

-(void)AlertViewSetTitle:(NSString*)title{
    if(alertView != nil){
        [alertView setTitle:title];
    }
}


-(void)AlertViewHide{
    [alertView dismissWithClickedButtonIndex:0 animated:NO];
//   [alertView removeFromSuperview];
//    if(![alertView isHidden]){
//        
//        double delayInSeconds = 2.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            NSLog(@"asdfasdfasf AlertViewHide");
//            [alertView dismissWithClickedButtonIndex:0 animated:NO];
//        });
//
//    }
}

-(void)Post:(NSString*)url Params:(NSDictionary*)Param{
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:Param httpMethod:@"POST" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        id json = [completedOperation responseJSON];
        if ([self CheckJSONNull:json]) {
            [self CheckLogin:json];
        }
        
        NSLog(@"%@",[completedOperation responseString]);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
}

-(void)Post:(NSString*)url Params:(NSDictionary*)Param CompletionHandler:(void (^)(MKNetworkOperation *completed))completionHandler{
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:Param httpMethod:@"POST" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        id json = [completedOperation responseJSON];
        if ([self CheckJSONNull:json]) {
            [self CheckLogin:json];
        }
        
        completionHandler(completedOperation);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
}

-(void)Post:(NSString*)url Params:(NSDictionary*)Param CompletionHandler:(void (^)(MKNetworkOperation *completed))completionHandler ErrorHander:(void (^)(NSError *))ErrorHander{
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:Param httpMethod:@"POST" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        id json = [completedOperation responseJSON];
        
        if ([self CheckJSONNull:json]) {
            [self CheckLogin:json];
        }
        NSLog(@"%@",json);
        completionHandler(completedOperation);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        ErrorHander(error);
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
}

-(void)Post:(NSString*)url Params:(NSDictionary*)Param Message:(NSString*)message CompletionHandler:(void (^)(MKNetworkOperation *completed))completionHandler ErrorHander:(void (^)(NSError *error))ErrorHander{
    
    [self AlertViewShow:message];
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:Param httpMethod:@"POST" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self AlertViewHide];
        
        id json = [completedOperation responseJSON];
        if ([self CheckJSONNull:json]) {
            [self CheckLogin:json];
        }
        
        completionHandler(completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self AlertViewHide];
        ErrorHander(error);
    }];
    
    
    
    [ApplicationDelegate.Engin enqueueOperation:op];
}


-(void)CheckLogin:(id)json{
    
    @try {
        NSString *loginStatus = json[@"LoginStatus"];
        if(loginStatus != nil && [loginStatus isEqualToString:@"false"]){
            NSLog(@"LoginStatus - false");
            [[Comm_Observe sharedManager] setLoginStatus:NO];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
    
}


























@end
