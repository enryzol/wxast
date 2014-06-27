//
//  HomeViewController.m
//  weixinast
//
//  Created by Jackie on 14-6-20.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "HomeViewController.h"
#import "ButtonHomeNav.h"
#import "Common.h"
#import "AlbumViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController{
    
    UIScrollView *HomeScrollView ;
    
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
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
    int height = 295;
    if(self.view.frame.size.height < 520){
        height = 225;
        [self adjustNavHeight:self.NavLeft];
        [self adjustNavHeight:self.NavMiddle];
        [self adjustNavHeight:self.NavRight];
    }
     NSLog(@" height = %d" , height);
    HomeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - height, 320, height)];
    HomeScrollView.backgroundColor = [UIColor whiteColor];
    HomeScrollView.pagingEnabled = YES;
    //HomeScrollView.showsHorizontalScrollIndicator = YES;
    HomeScrollView.showsVerticalScrollIndicator = YES;
    [HomeScrollView setContentSize:CGSizeMake(320*3, height)];
    HomeScrollView.delegate = self;
    
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    btn.backgroundColor = [UIColor orangeColor];
    [HomeScrollView addSubview:btn];
    
    [btn addTarget:self action:@selector(LinkAlbum:) forControlEvents:UIControlEventTouchDown];
    
    UIButton *btn_1 = [[UIButton alloc] initWithFrame:CGRectMake(120, 20, 80, 80)];
    btn_1.backgroundColor = [UIColor orangeColor];
    [HomeScrollView addSubview:btn_1];
    
    UIButton *btn_2 = [[UIButton alloc] initWithFrame:CGRectMake(220, 20, 80, 80)];
    btn_2.backgroundColor = [UIColor orangeColor];
    [HomeScrollView addSubview:btn_2];
    
    UIButton *btn_3 = [[UIButton alloc] initWithFrame:CGRectMake(20, 120, 80, 80)];
    btn_3.backgroundColor = [UIColor orangeColor];
    [HomeScrollView addSubview:btn_3];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(320, 0, 100, 50)];
    btn1.backgroundColor = [UIColor blackColor];
    [HomeScrollView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(640, 0, 100, 50)];
    btn2.backgroundColor = [UIColor blueColor];
    [HomeScrollView addSubview:btn2];
    
    
    [self changeNavTo:0];
    //[self.view addSubview:btn];
    [self.view addSubview:HomeScrollView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.NavLeft Title:@"关注者" Count:2210 Notice:0];
    [self.NavMiddle Title:@"消息" Count:27 Notice:0];
    [self.NavRight Title:@"统计" Count:309 Notice:15];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)changeNavTo:(int)i{
    
    if(i==0){
        [self.NavLeft.layer setBackgroundColor:[Common getColorFromRed:250 Green:250 Blue:250 Alpha:1]];
        [self.NavMiddle.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
        [self.NavRight.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
    }else if (i==1){
        [self.NavLeft.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
        [self.NavMiddle.layer setBackgroundColor:[Common getColorFromRed:250 Green:250 Blue:250 Alpha:1]];
        [self.NavRight.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
    }else if (i==2){
        [self.NavLeft.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
        [self.NavMiddle.layer setBackgroundColor:[Common getColorFromRed:233 Green:233 Blue:233 Alpha:1]];
        [self.NavRight.layer setBackgroundColor:[Common getColorFromRed:250 Green:250 Blue:250 Alpha:1]];
    }
    
}

-(void)adjustNavHeight:(ButtonHomeNav*)button{
    CGRect frame = button.frame;
    frame.origin.y = frame.origin.y - 20;
    button.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
   
    int i = 0;
    i = scrollView.contentOffset.x / self.view.frame.size.width;
    [self changeNavTo:i];
    
}


#pragma mark -push 

-(void)LinkAlbum:(id)sender{
    
    AlbumViewController *ac = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumViewController"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController pushViewController:ac animated:YES];
    
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

@end
