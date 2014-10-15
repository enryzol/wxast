//
//  BookDataEditViewController.m
//  weixinast
//
//  Created by Jackie on 14-9-3.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "BookDataEditViewController.h"
#import "MJRefresh.h"
#import "Http.h"
#import "Common.h"
#import "AppDelegate.h"
#import "Api.h"
#import "Function.h"
#import "Comm_Observe.h"
#import "CommAction.h"


@interface BookDataEditViewController ()<UIPickerViewDelegate>

@end

@implementation BookDataEditViewController{
    UIDatePicker *dp;
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
    
    self.count.delegate = self;
    dp = [[UIDatePicker alloc] init];
    dp.datePickerMode = UIDatePickerModeDateAndTime ;
    [dp setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"]];
    [dp addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.date.inputView = dp;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadDataFromServer];
}


-(void)loadDataFromServer{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/DataEdit/?LToken=%@&bid=%@",[Api LToken],self.bid ];
    
    [[Function sharedManager] Post:url Params:nil Message:@"正在加载" CompletionHandler:^(MKNetworkOperation *completed) {
        id json = [completed responseJSON];
        
        if([[Function sharedManager]CheckJSONNull:json[@"info"]]){
            self.name.text = json[@"info"][@"name"];
            self.contact.text = json[@"info"][@"contact"];
            self.note.text = json[@"info"][@"note"];
            self.count.text = json[@"info"][@"count"];
            self.date.text = json[@"info"][@"booktime"];
        }
        
        [Api CheckLoginStatus:self];
    } ErrorHander:^(NSError *error) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"加载失败" description:nil type:TWMessageBarMessageTypeInfo duration:1.0f];
        [self.navigationController popViewControllerAnimated:YES];
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

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    self.date.text = strDate;
}


- (IBAction)bgTap:(id)sender {
    [self.count resignFirstResponder];
    [self.date resignFirstResponder];
}


- (IBAction)NavBarLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)NavBarRightButton:(id)sender {
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/DataEditSave/?LToken=%@&bid=%@",[Api LToken],self.bid ];
    
    NSMutableDictionary * param  = [[NSMutableDictionary alloc] init];
    [param setValue:self.count.text forKey:@"beid"];
    [param setValue:self.bid forKey:@"bid"];
    [param setValue:self.count.text forKey:@"count"];
    [param setValue:self.date.text forKeyPath:@"booktime"];
    
    [[Function sharedManager] Post:url Params:param Message:@"正在保存" CompletionHandler:^(MKNetworkOperation *completed) {
        //id json = [completed responseJSON];
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"保存成功" description:@"" type:TWMessageBarMessageTypeInfo duration:1.0f callback:^{
            
        }];
        
        
    } ErrorHander:^(NSError *error) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"加载失败" description:nil type:TWMessageBarMessageTypeInfo duration:1.0f];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}























@end
