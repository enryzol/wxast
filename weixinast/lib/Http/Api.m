//
//  Api.m
//  weixinast
//
//  Created by Jackie on 14-7-28.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "Api.h"
#import "AppDelegate.h"
#import "Function.h"
#import "Comm_Observe.h"

@implementation Api



+(NSString*)LToken{
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    
    NSString *LToken = [userinfo objectForKey:@"LToken"];
    
    if(LToken == NULL || LToken == nil){
        [[Comm_Observe sharedManager] setLoginStatus:NO];
    }
    
    return LToken;
}

+(NSString*)Package{
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *Package = [userinfo objectForKey:@"user"];
    
    return Package[@"package"];
    
}

+(void)CheckLoginStatus:(id)sender{
    
    UIViewController *vc = (UIViewController*)sender;
    
    if(![[Comm_Observe sharedManager] LoginStatus]){
        
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        [userinfo removeObjectForKey:@"LToken"];
        [userinfo synchronize];
        
        [vc dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
    if ([self LToken] == NULL || [self LToken] == nil) {
        [vc dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}

+(BOOL)CheckUser{
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    
    NSString *LToken = [userinfo objectForKey:@"LToken"];
    
    NSString * url ;
    if(LToken != nil){
        url = [NSString stringWithFormat:@"/Device/iPhone/Check/Touch/%@",LToken];
    }else{
        NSLog(@"Api.h - LToken - %@" , LToken);
        return false;
    }
    
    [[Function sharedManager] Post:url Params:nil CompletionHandler:^(MKNetworkOperation *completed) {
        
        id json = [completed responseJSON];
        
        if ([[Function sharedManager] CheckJSONNull:json[@"LToken"]]) {
            NSString *returnString = json[@"LToken"];
            
            if([returnString isEqualToString:@"null"]){
                [userinfo removeObjectForKey:@"LToken"];
                [userinfo synchronize];
            }else if([returnString isEqualToString:@""]){
                
                
            }else if(![returnString isEqualToString:@""]){
                [userinfo setObject:json[@"LToken"] forKey:@"LToken"];
                [userinfo synchronize];
            }
        }
        
        
        NSLog(@"Api.h - CheckUser - LToken - %@",json[@"LToken"]);
    }];
    
    
//    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:nil httpMethod:@"GET" ssl:YES];
//    
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        
//        
//        
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        
//        NSLog(@"CheckUser - error - %@",error);
//
//        
//    }];
//    
//    [ApplicationDelegate.Engin enqueueOperation:op];
    
    return true;
}

@end
