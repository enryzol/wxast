//
//  ButtonHomeNav.m
//  weixinast
//
//  Created by Jackie on 14-6-20.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "ButtonHomeNav.h"
#import "Common.h"
#define PI 3.14159265358979323846

@implementation ButtonHomeNav{
    
    NSString *title ;
    int count ;
    int notice ;
    
    UILabel *LabelTitle ;
    UILabel *LabelCount ;
    UILabel *LabelNotice ;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)Title:(NSString*)_title Count:(int)_count Notice:(int)_notice
{

        // Initialization code
    count = _count;
    title = _title;
    notice = _notice;

    LabelTitle.text = _title;
    LabelCount.text = [NSString stringWithFormat:@"%d" , _count];
    LabelNotice.text = [NSString stringWithFormat:@"%d" , _notice];
    
    if(_notice > 0){

        LabelNotice.alpha = 1.0;
    }else{
        LabelNotice.alpha = 0.0;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

- (void)drawRect:(CGRect)rect
{
    // Drawing code
   
    LabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 106, 30)];
    LabelTitle.text = @"";
    LabelTitle.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:LabelTitle];
    
    LabelCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 106, 20)];
    LabelCount.text = @"0";
    LabelCount.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:LabelCount];
    
    
    LabelNotice = [[UILabel alloc] initWithFrame:CGRectMake(77, 7, 16, 16)];
    LabelNotice.text = @"0";
    LabelNotice.textAlignment = NSTextAlignmentCenter;
    LabelNotice.font = [UIFont fontWithName:@"Helvetica" size:10];
    LabelNotice.textColor = [UIColor redColor];
    LabelNotice.alpha = 0.0;
    
    [self addSubview:LabelNotice];
    
//    绘制圆形
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);
//    CGContextSetLineWidth(context, 0);//线的宽度CGContextSetFillColorWithColor(context, aColor.CGColor);
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextAddArc(context, 85, 15, 8, 0, 2*PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径

    
    
    
    [self.layer setBackgroundColor:[Common getColorFromRed:250 Green:250 Blue:250 Alpha:1]];
    
}

-(void)test{
    NSLog(@"ttttttttttest");
}



@end
