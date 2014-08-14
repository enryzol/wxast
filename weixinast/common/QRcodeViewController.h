//
//  QRcodeViewController.h
//  weixinast
//
//  Created by Jackie on 14-8-12.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//
//- (IBAction)Go:(id)sender {
//
//QRViewController *vw = [[QRViewController alloc] init];
//
//[vw CompleteHandle:^(NSString *Value) {
//    NSLog(@"Qrcode viewcontroller%@",Value);
//}];
//[self presentViewController:vw animated:YES completion:^{
//}];
//
//}


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRcodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>



-(void)CompleteHandle:(void (^)(NSString* Value))Handle;


@end