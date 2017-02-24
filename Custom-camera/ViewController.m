//
//  ViewController.m
//  Custom-camera
//
//  Created by Dan Hyunchan Kim on 2/24/17.
//  Copyright © 2017 hyunchan. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewCell.h"
#import "UploadViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize mainNavBar, mainToolBar;

- (void)viewDidLoad {
    [super viewDidLoad];

    dataList = [[NSMutableArray alloc]init];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [path objectAtIndex:0];
    NSString *customPath = @"MyFolder/";
    NSError *error;
    NSString *imgFolderPath = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",customPath]];
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imgFolderPath error:&error];
    for (NSURL *url in paths) {
        NSString *imgPath = [imgFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", url]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
        [dataList addObject:image];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    cell.imageView.image = [dataList objectAtIndex:indexPath.row];

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 Implement camera
 */
- (IBAction)cameraAction:(id)sender {
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

/*
 Implement library photo
 */
- (IBAction)libraryAction:(id)sender {
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UploadViewController *uploadViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"uploadView"];
        [self presentViewController:uploadViewController animated:YES completion:^{
            selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
            uploadViewController.imagePreview.image = selectedImage;
        }];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
