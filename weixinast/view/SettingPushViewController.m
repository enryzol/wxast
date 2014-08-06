//
//  SettingPushViewController.m
//  weixinast
//
//  Created by Jackie on 14-7-31.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "SettingPushViewController.h"
#import "Function.h"
#import "Api.h"
#import "AppDelegate.h"
#import "Func_PickerView.h"

@interface SettingPushViewController ()

@end

@implementation SettingPushViewController{
    Func_PickerView *BeginPickerView;
    Func_PickerView *EndPickerView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self SaveDataToServer];
    
    NSMutableArray *Data = [[NSMutableArray alloc] init];
    for (int i=0; i<25; i++) {
        [Data addObject:[NSString stringWithFormat:@"%.2d:00",i]];
    }
    
    UIBarButtonItem *doneB = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_done_100.png"] style:UIBarButtonItemStylePlain target:self action:@selector(bgTap:)];
    
    UIBarButtonItem *doneE = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_done_100.png"] style:UIBarButtonItemStylePlain target:self action:@selector(bgTap:)];
    
    BeginPickerView = [[Func_PickerView alloc] init];
    EndPickerView = [[Func_PickerView alloc] init];
    
    [BeginPickerView Init:self.BeginTime Data:Data Done:doneB];
    [EndPickerView Init:self.EndTime Data:Data Done:doneE];
    
    
    NSUserDefaults *udefault =  [NSUserDefaults standardUserDefaults];
    
    [self.UserPushSwitch setOn:[[udefault objectForKey:@"UserPush"] isEqualToString:@"1"]?YES:NO];
    [self.MessagePushSwitch setOn:[[udefault objectForKey:@"MessagePush"] isEqualToString:@"1"]?YES:NO];
    [self.BookPushSwitch setOn:[[udefault objectForKey:@"BookPush"] isEqualToString:@"1"]?YES:NO];
    [self.SoundSwitch setOn:[[udefault objectForKey:@"Sound"] isEqualToString:@"1"]?YES:NO];
    [self.VibrateSwitch setOn:[[udefault objectForKey:@"Vibrate"] isEqualToString:@"1"]?YES:NO];

    self.BeginTime.text = [udefault objectForKey:@"BeginTime"];
    self.EndTime.text = [udefault objectForKey:@"EndTime"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SaveDataToServer{
    
    NSLog(@"SaveDataToServer");
    NSMutableDictionary * param  = [[NSMutableDictionary alloc] init];
    
    [NSString stringWithFormat:@"%hhd",self.SoundSwitch.isOn];
    [param setValue:(self.UserPushSwitch.isOn)?@"1":@"0" forKey:@"UserPush"];
    [param setValue:(self.MessagePushSwitch.isOn)?@"1":@"0" forKey:@"MessagePush"];
    [param setValue:(self.BookPushSwitch.isOn)?@"1":@"0" forKey:@"BookPush"];
    [param setValue:(self.SoundSwitch.isOn)?@"1":@"0" forKey:@"Sound"];
    [param setValue:(self.VibrateSwitch.isOn)?@"1":@"0" forKey:@"Vibrate"];
    [param setValue:self.BeginTime.text forKey:@"BeginTime"];
    [param setValue:self.EndTime.text forKey:@"EndTime"];
    
    [[Function sharedManager] Post:[NSString stringWithFormat:@"/Device/iPhone/Setting/SavePush?LToken=%@&DeviceToken=%@",[Api LToken],ApplicationDelegate._deviceToken] Params:param CompletionHandler:^(MKNetworkOperation *completed) {
        
        NSUserDefaults *udefault =  [NSUserDefaults standardUserDefaults];
        
        [udefault setValue:(self.UserPushSwitch.isOn)?@"1":@"0" forKey:@"UserPush"];
        [udefault setValue:(self.MessagePushSwitch.isOn)?@"1":@"0" forKey:@"MessagePush"];
        [udefault setValue:(self.BookPushSwitch.isOn)?@"1":@"0" forKey:@"BookPush"];
        [udefault setValue:(self.SoundSwitch.isOn)?@"1":@"0" forKey:@"Sound"];
        [udefault setValue:(self.VibrateSwitch.isOn)?@"1":@"0" forKey:@"Vibrate"];
        [udefault setValue:self.BeginTime.text forKey:@"BeginTime"];
        [udefault setValue:self.EndTime.text forKey:@"EndTime"];
        
        [udefault synchronize];
        
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Back:(id)sender {
    [self SaveDataToServer];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)bgTap:(id)sender {
    [self.BeginTime resignFirstResponder];
    [self.EndTime resignFirstResponder];
}














@end
