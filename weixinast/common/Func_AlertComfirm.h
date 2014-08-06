//
//  Func_AlertComfirm.h
//  weixinast
//
//  Created by Jackie on 14-8-4.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Func_AlertComfirm : NSObject<UIAlertViewDelegate>

-(void)alertComfirmTitle:(NSString*)title Message:(NSString*)message SureHandler:(void (^)())SureHandler;

@end
