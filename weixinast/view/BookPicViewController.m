//
//  BookPicViewController.m
//  weixinast
//
//  Created by Jackie on 14-8-15.
//  Copyright (c) 2014年 Jackie. All rights reserved.
//

#import "BookPicViewController.h"
#import "AlbumBoardTableViewCell.h"
#import "BookPicEditViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "Api.h"
#import "Function.h"
#import "Comm_Observe.h"
#import "CommAction.h"
#import "Common.h"
#import "QBImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface BookPicViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end



@implementation BookPicViewController{
    NSMutableArray *TableViewData ;
    CommAction *commAction;
    NSMutableArray *multiPhotos;
    int multiPhotosCount ;
    int multiPhotosReadyCount ;
    int multiPhotosCompleteCount ;
    UIAlertView *alertview;
    UIImage *UploadPhoto;
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
    [self.tableview addHeaderWithTarget:self action:@selector(headerReFreshing)];
    //[self.tableview addFooterWithTarget:self action:@selector(footerReFreshing)];
    
    [self headerReFreshing];
    
    commAction = [[CommAction alloc] init];
    [commAction ObserverKey:@"BookPicViewControllerReflush" Callback:^(NSString *Key) {
        if ([[[Comm_Observe sharedManager] BookPicViewControllerReflush] isEqualToString:@"1"]) {
            [self headerReFreshing];
            [[Comm_Observe sharedManager] setBookPicViewControllerReflush:@"0"];
        }
    }];
    
    multiPhotos = [[NSMutableArray alloc] init];
    UploadPhoto = [[UIImage alloc] init];
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


#pragma mark - load data

-(void)loadDataFromServer{
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/piclist/?LToken=%@&beid=%@",[Api LToken],[self.Book objectForKey:@"beid"]];
    
    NSLog(@"%@",url);
    
    [[Function sharedManager] Post:url Params:nil CompletionHandler:^(MKNetworkOperation *completed) {
        
        id json = [completed responseJSON];
        if ([[Function sharedManager] CheckJSONNull:json[@"list"]]) {
            TableViewData = json[@"list"];
            [self.tableview reloadData];
        }
        NSLog(@"--%@",[completed responseString]);
        [self.tableview headerEndRefreshing];
        [Api CheckLoginStatus:self];
        
    } ErrorHander:^(NSError *error) {
        [self.tableview headerEndRefreshing];
    }];
}

#pragma mark - tableview

-(void)headerReFreshing{
    [self loadDataFromServer];
}

-(void)footerReFreshing{
    [self.tableview footerEndRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TableViewData count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"AlbumBoardCell";
    AlbumBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.Desc.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"desc"];
    if([cell.Desc.text isEqualToString:@""]){
        cell.Desc.text = @"暂无描述";
    }
    cell.Keyword.text = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"title"];
    if([cell.Keyword.text isEqualToString:@""]){
        cell.Keyword.text = @"暂无链接";
    }
    
    NSString *url = [[TableViewData objectAtIndex:indexPath.row] objectForKey:@"img"];
    cell.uniqueID = url;
    
    //[cell.Name sizeToFit];
    [cell setImageWithURL:url];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"编辑" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图片编辑",@"图片排序",@"设为封面",@"图片删除", nil];
    
    [as setTag:indexPath.row];
    [as showInView:[UIApplication sharedApplication].keyWindow];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    id buffer = [TableViewData objectAtIndex:sourceIndexPath.row];
    
    NSMutableArray *ss = [TableViewData mutableCopy];
    
    [ss removeObjectAtIndex:sourceIndexPath.row];
    [ss insertObject:buffer atIndex:destinationIndexPath.row];
    
    TableViewData = ss;
    
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


#pragma mark - action sheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" 确定删除图片？" message:@"图片删除将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert setTag:[actionSheet tag]];
        [alert show];
    }else if (buttonIndex == 0){
        
        BookPicEditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookPicEditViewController"];
        vc.PictureInfo = [TableViewData objectAtIndex:actionSheet.tag];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (buttonIndex == 1){
        
        [self.tableview setEditing:YES];
        [self.NavBarRightButton setImage:[UIImage imageNamed:@"ico_done_100.png"] forState:UIControlStateNormal];
        
    }else if (buttonIndex == 2){
        
        NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/SetCover/?LToken=%@",[Api LToken]];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[[TableViewData objectAtIndex:actionSheet.tag] objectForKey:@"biid"] forKey:@"biid"];
        [[Function sharedManager] Post:url Params:params CompletionHandler:^(MKNetworkOperation *completed) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"封面设置成功" description:@"" type:TWMessageBarMessageTypeInfo duration:0.8f];
        }];
        [[Comm_Observe sharedManager] setBookEditViewControllerReflush:@"1"];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 101){
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            //upload photos
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.maximumNumberOfSelection = 6;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
            [self presentViewController:navigationController animated:YES completion:NULL];
            
        }else if(buttonIndex == 2){
            
            NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
        
        
    }else{
        if(buttonIndex == 0){
            //cancel
            
            NSLog(@"cancel");
        }else{
            //delete
            NSLog(@"delete");
            
            NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/DeletePic/?LToken=%@&biid=%@",[Api LToken] , [[TableViewData objectAtIndex:alertView.tag] objectForKey:@"biid"]];
            
            [[Function sharedManager] Post:url Params:nil CompletionHandler:^(MKNetworkOperation *completed) {
                [self loadDataFromServer];
            }];
            
        }

    }
    
    
}


- (IBAction)NavBarLeftButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
};
- (IBAction)NavBarRightButton:(id)sender{
    
    if(self.tableview.editing){
        [self.NavBarRightButton setImage:[UIImage imageNamed:@"ico_add_100w.png"] forState:UIControlStateNormal];
        [self.tableview setEditing:NO];
        
        NSString *OrderBy = @"";
        
        for (int i = 0; i < [TableViewData count]; i++){
            //NSLog(@"%@",[TableViewData objectAtIndex:i]);
            OrderBy = [OrderBy stringByAppendingFormat:@"||%@#%d", [[TableViewData objectAtIndex:i] objectForKey:@"biid"], i+1];
        }
        
        NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/SaveOrderBy/?LToken=%@",[Api LToken]];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:OrderBy forKey:@"orderby"];
        [[Function sharedManager] Post:url Params:params];
    }else{
        
        if([TableViewData count]>9){
            
            UIAlertView *as = [[UIAlertView alloc] initWithTitle:@"错误" message:@"您的图片数据超过9张" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [as show];
            return ;
        }
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请选择上传的方式" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"从相册选择",@"拍照", nil];
        
        av.tag = 101;
        [av show];
        
    }
    
};

#pragma mark - imagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [[Function sharedManager] AlertViewShow:@"正在准备上传"];
        
        
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        
        if (!originalImage)
            return;
        
        // Optionally set a placeholder image here while resizing happens in background
        
        CGFloat width =  600.0f;
        CGFloat height = originalImage.size.height * width / originalImage.size.width;  // or whatever you need
        
        UIImage *image = [Common imageWithImage:originalImage scaledToSize:CGSizeMake(width, height)];
        
        originalImage = nil;
        
        [self UploadPhoto:image];
        
    }];
    
}

#pragma mark - QBImagePickerControllerDelegate

- (void)dismissImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"* qb_imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);
    
    [self dismissImagePickerController];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"** qb_imagePickerController:didSelectAssets:");
    NSLog(@"%@", assets);
    
    //NSData * data = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:[[assets objectAtIndex:0] ]], 1.0f);
    
    [multiPhotos removeAllObjects];
    
    ALAsset * _asset ;
    multiPhotosCount = [assets count];
    multiPhotosReadyCount = 0;
    multiPhotosCompleteCount = 0;
    
    for (int i=0; i<[assets count]; i++) {
        
        _asset = [assets objectAtIndex:i];
        
        NSURL *url= (NSURL*) [[_asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[_asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]];
        
        [self findLargeImage:url];
        
    }
    
    [self dismissImagePickerController];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** qb_imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
}


-(void)findLargeImage:(NSURL*)mediaurl{
    
    //
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            multiPhotosReadyCount ++;
            [multiPhotos addObject:[UIImage imageWithCGImage:iref]];
            
            NSLog(@"Ready 》%d ",multiPhotosReadyCount);
            if(multiPhotosReadyCount == multiPhotosCount && multiPhotosCount != 0){
                [self MultiUploadPhoto];
            }
            
        }
    };
    
    //
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };
    
    if(mediaurl)
    {
        NSURL *asseturl = mediaurl;
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:asseturl
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
}

-(void)MultiUploadPhoto{
    alertview = [[UIAlertView alloc] initWithTitle:@"请稍后" message:[NSString stringWithFormat:@"正在上传 0/%d",multiPhotosCount] delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [alertview show];
    [self Upload];
}

-(void)Upload{
    
    NSLog(@"[self Upload] - multiPhotosCompleteCount -》 %d",multiPhotosCompleteCount);
    
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/SavePicture/?LToken=%@",[Api LToken]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"" forKey:@"title"];
    [params setValue:@"" forKey:@"desc"];
    [params setValue:[self.Book objectForKey:@"beid"] forKey:@"beid"];
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:params httpMethod:@"POST" ssl:YES];
    
    UIImage *img = [multiPhotos objectAtIndex:multiPhotosCompleteCount];
    if(img.size.width > 800){
        CGFloat width =  500.0f;
        CGFloat height = img.size.height * width / img.size.width;  // or whatever you need
        
        UIImage *image = [Common imageWithImage:img scaledToSize:CGSizeMake(width, height)];
        [op addData:UIImageJPEGRepresentation(image, 1.0f) forKey:@"img"];
    }else{
        [op addData:UIImageJPEGRepresentation(img, 1.0f) forKey:@"img"];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        multiPhotosCompleteCount++;
        [alertview setMessage:[NSString stringWithFormat:@"正在上传 %d / %d",multiPhotosCompleteCount,multiPhotosCount]];
        
        NSLog(@"[self Upload OK]");
        
        if(multiPhotosCompleteCount == multiPhotosCount){
            [self loadDataFromServer];
            [alertview dismissWithClickedButtonIndex:0 animated:YES];
        }else{
            [self Upload];
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        NSLog(@"[self Upload ERROR] - %@" , error);
        
        multiPhotosCompleteCount++;
        [alertview setMessage:[NSString stringWithFormat:@"正在上传 %d / %d",multiPhotosCompleteCount,multiPhotosCount]];
        if(multiPhotosCompleteCount == multiPhotosCount){
            [self loadDataFromServer];
            [alertview dismissWithClickedButtonIndex:0 animated:YES];
        }else{
            [self Upload];
        }
        
    }];
    
    [ApplicationDelegate.Engin enqueueOperation:op];
    
}


-(void)UploadPhoto:(UIImage*)image{
    NSLog(@"[self UploadPhoto]");
    
    NSString *url = [NSString stringWithFormat:@"/Device/iPhone/Book/SavePicture/?LToken=%@",[Api LToken]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"" forKey:@"title"];
    [params setValue:@"" forKey:@"desc"];
    [params setValue:[self.Book objectForKey:@"beid"] forKey:@"beid"];
    
    MKNetworkOperation *op = [ApplicationDelegate.Engin operationWithPath:url params:params httpMethod:@"POST" ssl:YES];
    
    [op addData:UIImageJPEGRepresentation(image, 1.0f) forKey:@"img"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [[Function sharedManager] AlertViewHide];
        [self loadDataFromServer];
        NSLog(@"%@",[completedOperation responseString]);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [[Function sharedManager] AlertViewHide];
        NSLog(@"%@",[completedOperation responseString]);
        
    }];
    
    [[Function sharedManager] AlertViewShow:@"正在上传图片"];
    [ApplicationDelegate.Engin enqueueOperation:op];
}




























@end
