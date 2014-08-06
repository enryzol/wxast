//
//  Func_AlertComfirm.m
//  weixinast
//
//  Created by Jackie on 14-8-4.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "Func_AlertComfirm.h"

@implementation Func_AlertComfirm{
    
    UIAlertView *alertView ;
    NSString *_title;
    NSString *_content;
    
     void(^_SureHandler)();
    
}



-(void)alertComfirmTitle:(NSString*)title Message:(NSString*)message SureHandler:(void (^)())SureHandler{
    _SureHandler = SureHandler;
    alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        _SureHandler();
    }
}


@end
