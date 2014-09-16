//
//  BookAdvanceViewController.m
//  weixinast
//
//  Created by Jackie on 14-8-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "BookAdvanceViewController.h"
#import "Function.h"
#import "Api.h"
#import "AppDelegate.h"
#import "Comm_Observe.h"


@interface BookAdvanceViewController ()

@end

@implementation BookAdvanceViewController{
    UIDatePicker *datePicker;
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
    
    datePicker = [[UIDatePicker alloc] init];
    NSLocale *chineseLocale = [NSLocale localeWithLocaleIdentifier:@"zh_cn"];
    [datePicker setLocale:chineseLocale];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker addTarget:self action:@selector(datePicker:) forControlEvents:UIControlEventValueChanged];
    
    [self.Count setText:[self.Book objectForKey:@"count"]];
    [self.CountPerTime setText:[self.Book objectForKey:@"countpretime"]];
    [self.BookContact setText:[self.Book objectForKey:@"contact"]];
    [self.Endtime setText:[self.Book objectForKey:@"etime"]];
    self.Endtime.inputView = datePicker;
    
    [self.UserBookTime setOn:[[self.Book objectForKey:@"userbooktime"] isEqualToString:@"1"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



-(void)datePicker:(UIDatePicker*)sender{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.Endtime setText:[df stringFromDate:sender.date]];
}


- (IBAction)bgTap:(id)sender {
    [self.Endtime resignFirstResponder];
    [self.Count resignFirstResponder];
    [self.CountPerTime resignFirstResponder];
    [self.BookContact resignFirstResponder];
}

- (IBAction)NavBarLeftButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
};
- (IBAction)NavBarRightButton:(id)sender{
    
    NSMutableDictionary * param  = [[NSMutableDictionary alloc] init];
    
    [param setValue:(self.UserBookTime.isOn)?@"1":@"0" forKey:@"UserBookTime"];
    [param setValue:self.Count.text forKey:@"Count"];
    [param setValue:self.BookContact.text forKey:@"BookContact"];
    
    [param setValue:self.CountPerTime.text forKey:@"CountPerTime"];
    [param setValue:self.Endtime.text forKey:@"EndTime"];
    [param setValue:[self.Book objectForKey:@"beid"] forKey:@"beid"];
    
    [[Function sharedManager] Post:[NSString stringWithFormat:@"/Device/iPhone/Book/SaveAdvance?LToken=%@",[Api LToken]] Params:param Message:@"正在保存" CompletionHandler:^(MKNetworkOperation *completed) {
        [[Comm_Observe sharedManager] setBookEditViewControllerReflush:@"1"];
        [Api CheckLoginStatus:self];
    } ErrorHander:^(NSError *error) {
        
    }];
    
};
























@end
