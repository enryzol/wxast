//
//  AlbumViewController.h
//  weixinast
//
//  Created by Jackie on 14-6-23.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *abTableView;

@end
