//
//  Func_PickerView.h
//  weixinast
//
//  Created by Jackie on 14-7-31.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Func_PickerView : NSObject <UIPickerViewDelegate,UIPickerViewDataSource>

-(void)Init:(UITextField*)textField Data:(NSMutableArray*)data Done:(UIBarButtonItem*)done;

@end
