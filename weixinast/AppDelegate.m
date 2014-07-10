//
//  AppDelegate.m
//  weixinast
//
//  Created by Jackie on 14-6-18.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

@implementation AppDelegate{

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    self.CacheEngin = [[MKNetworkEngine alloc] initWithHostName:@"img.host1.o-tap.cn"];
    [self.CacheEngin useCache];
    
    self.Engin = [[MKNetworkEngine alloc] initWithHostName:@"i.o-tap.cn"];
    
    NSString *sb ;
    if(IS_4inch){
        sb = @"Main";
    }else{
        sb = @"Main3.5";
    }
    
    NSLog(@"This is Share Branch.");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sb bundle:nil];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
    self.HostName = @"http://i.o-tap.cn/";
    self.Package = @"Ts139986226324746";
    self.PostUrl = @"/mobile/post/i/Ts139986226324746/";
    
    //添加推送注册
    //判断是否由远程消息通知触发应用程序启动
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil) {
        //获取应用程序消息通知标记数（即小红圈中的数字）
        int badge = (int)[UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge>0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge--;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
    }
    //消息推送注册
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge];
    
    [ShareSDK registerApp:@"241320e5a09f"];
    
    [ShareSDK connectWeChatWithAppId:@"wx556e88d078c07290" wechatCls:[WXApi class]];
    [ShareSDK connectSMS];
    [ShareSDK connectMail];
    [ShareSDK connectCopy];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    //NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
    
    NSString *token = [[NSString stringWithFormat:@"%@",deviceToken] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self._deviceToken = token;
    NSLog(@"My token is:%@", token);
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *ss = [userinfo valueForKey:@"isReceiveNotification"];
    int i = 1;
    if([ss isEqualToString:@"NO"]){
        i = 0;
    }
    NSLog(@"%@",self._deviceToken);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError - %@" , error);
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
