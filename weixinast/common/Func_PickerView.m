//
//  Func_PickerView.m
//  weixinast
//
//  Created by Jackie on 14-7-31.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "Func_PickerView.h"

@implementation Func_PickerView{
    
    UIPickerView *pickerView;
    NSMutableArray *pickerViewData;
    UITextField *_textField;
    UIToolbar *accessoryView;
}


-(void)Init:(UITextField*)textField Data:(NSMutableArray*)data Done:(UIBarButtonItem*)done{
    
    _textField = textField;
    pickerViewData = data;
    
    pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView setBackgroundColor:[UIColor whiteColor]];
    
    textField.inputView = pickerView ;
    
    
    accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    accessoryView.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:textField action:@selector(doneTapped:)];
    
    accessoryView.items = [NSArray arrayWithObjects:space,done, nil];
    
    textField.inputAccessoryView = accessoryView;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerViewData objectAtIndex:row];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerViewData count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1.0f;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _textField.text = [pickerViewData objectAtIndex:row];
}

@end
