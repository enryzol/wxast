//
//  BookEditViewController.m
//  weixinast
//
//  Created by Jackie on 14-8-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "BookEditViewController.h"
#import "BookWeixinViewController.h"
#import "BookAdvanceViewController.h"
#import "BookPicViewController.h"
#import "DescEditViewController.h"
#import "Function.h"
#import "Api.h"
#import "Comm_Observe.h"
#import "ImageViewFromUrl.h"

@interface BookEditViewController ()<CommonProtocol>

@end

@implementation BookEditViewController{
    NSString *Modified;
    NSString *Description ;
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
    
    //self.title.text = [self.Book objectForKey:@"subject"];
    
    [self.Title setText:[self.Book objectForKey:@"subject"]];
    [self.Desc setText:[self.Book objectForKey:@"content"]];
    
    
    
    [self.ImgCover setImageWithURL:[self.Book objectForKey:@"cover"] Radius:10];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if([[[Comm_Observe sharedManager] BookEditViewControllerReflush] isEqualToString:@"1"]){
        [[Function sharedManager] Post:[NSString stringWithFormat:@"/Device/iPhone/Book/SaveAdvance?LToken=%@&beid=%@",[Api LToken],[self.Book objectForKey:@"beid"]] Params:nil Message:@"加载数据中" CompletionHandler:^(MKNetworkOperation *completed) {
            
            id json = [completed responseJSON];
            if ([[Function sharedManager] CheckJSONNull:json[@"info"]]) {
                self.Book = json[@"info"];
                [self.Title setText:[self.Book objectForKey:@"subject"]];
                [self.Desc setText:[self.Book objectForKey:@"content"]];
                [self.ImgCover setImageWithURL:[self.Book objectForKey:@"cover"] Radius:10];
            }
            [Api CheckLoginStatus:self];
            
        } ErrorHander:^(NSError *error) {
            
        }];
        
        [[Comm_Observe sharedManager] setBookEditViewControllerReflush:@"0"];
    }
    
    
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

-(IBAction)bgTap{
    [self.Title resignFirstResponder];
}

- (IBAction)NavBarLeftButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
};
- (IBAction)NavBarRightButton:(id)sender{

    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/SaveBook/?LToken=%@&beid=%@",[Api LToken] , [self.Book objectForKey:@"beid"]];
    
    //NSLog(@"%@",self.Book);
    //NSString *beid = [self.Book objectForKey:@"beid"];
    //NSMutableDictionary *param = @{@"title": self.Title.text , @"beid": @"1" , @"desc":Description};
    
    
    NSMutableDictionary * param  = [[NSMutableDictionary alloc] init];
    
    [param setValue:Description forKey:@"desc"];
    [param setValue:self.Title.text forKey:@"title"];
    [param setValue:[self.Book objectForKey:@"beid"] forKey:@"beid"];
    
    
    [[Function sharedManager] Post:url Params:param Message:@"正在保存" CompletionHandler:^(MKNetworkOperation *completed) {
        NSLog(@"%@",[completed responseString]);
    } ErrorHander:^(NSError *error) {
        
    }];
    
    [self bgTap];
    
};

- (IBAction)AdvanceButton:(id)sender {
    BookAdvanceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookAdvanceViewController"];
    vc.Book = self.Book;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)WeixinButton:(id)sender {
    BookWeixinViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookWeixinViewController"];
    vc.Book = self.Book;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)PicEdit:(id)sender {
    BookPicViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookPicViewController"];
    vc.Book = self.Book;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)CommonReturn:(NSString *)str Tag:(int)i{
    self.Desc.text = str;
    Description = str;
}

- (IBAction)Desc:(id)sender {
    DescEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DescEditViewController"];
    
    vc.ContentStr = [self.Book objectForKey:@"content"];//[ stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"{enter}"];
    
    vc.SubjectStr = @"预约描述";
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

















@end
