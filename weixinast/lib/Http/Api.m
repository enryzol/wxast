//
//  Api.m
//  weixinast
//
//  Created by Jackie on 14-7-28.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "Api.h"
#import "AppDelegate.h"

@implementation Api



+(NSString*)LToken{
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    
    NSString *LToken = [userinfo objectForKey:@"LToken"];
    
    return LToken;
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
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:nil httpMethod:@"GET" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        id json = [completedOperation responseJSON];
        
        NSString *returnString = json[@"LToken"];
        
        if([returnString isEqualToString:@"null"]){
            [userinfo removeObjectForKey:@"LToken"];
            [userinfo synchronize];
        }else if ([returnString isEqualToString:@""]){
            
            
        }else if(![returnString isEqualToString:@""]){
            [userinfo setObject:json[@"LToken"] forKey:@"LToken"];
            [userinfo synchronize];
        }
        
        NSLog(@"Api.h - CheckUser - LToken - %@",json[@"LToken"]);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        NSLog(@"CheckUser - error - %@",error);

        
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
    
    return true;
}

@end
