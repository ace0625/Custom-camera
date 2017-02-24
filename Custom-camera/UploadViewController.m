//
//  UploadViewController.m
//  Custom-camera
//
//  Created by Dan Hyunchan Kim on 2/24/17.
//  Copyright © 2017 hyunchan. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadAction:(id)sender {
    [self saveInLocalDevice:_imagePreview.image];
}

/*
 Save in the local device
 */
- (void)saveInLocalDevice:(UIImage *) image {
    NSData *imgData = UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    NSString *imagePath = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", @"cached"]];
    if (![imgData writeToFile:imagePath atomically:NO]) {
        NSLog(@"Failed to cache");
    } else {
        NSLog(@"Success, path: %@", imagePath);
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
