//
//  UploadViewController.m
//  Custom-camera
//
//  Created by Dan Hyunchan Kim on 2/24/17.
//  Copyright © 2017 hyunchan. All rights reserved.
//

#import "UploadViewController.h"
#import "ViewController.h"
#define POST_BODY_BOURDARY  @"---------123456boundary"

@interface UploadViewController ()

@end

@implementation UploadViewController
@synthesize imagePreview, uploadProgressBar;

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
    [self saveInLocalDevice:imagePreview.image];
    [self uploadAction:imagePreview.image];
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    [self presentViewController:viewController animated:YES completion:nil];
}

/*
 Save in the local device.
 */
- (void)saveInLocalDevice:(UIImage *) image {
    NSData *imgData = UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    NSString *customPath = @"MyFolder/";
    
    NSString *imagePath = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png",customPath, [self generateUniquePath]]];
    
    NSError *error;
    NSString *dataPath = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", customPath]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    if (![imgData writeToFile:imagePath atomically:NO]) {
        NSLog(@"Failed to cache");
    } else {
        NSLog(@"Success, path: %@", imagePath);
    }
}

/*
 Generate unique path.
 */
- (NSNumber *)generateUniquePath {
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    return timeStampObj;
}

- (void)uploadImage:(UIImage *)image {
    [uploadProgressBar setProgress:0.0 animated:NO];
    NSURLSessionUploadTask *uploadTask;
    NSURL *url = [NSURL URLWithString:@"https://framer-16ab8.firebaseio.com/aaa.json"];
    if (uploadTask) {
        NSLog(@"Wait for this process finish!");
        return;
    }
    
    NSString *imagepath = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:image];
    NSURL *outputFileURL = [NSURL fileURLWithPath:imagepath];
    
    // Create the Request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Configure the NSURL Session
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.sometihng.upload"];
    
    NSURLSession *upLoadSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    // Define the Upload task
    uploadTask = [upLoadSession uploadTaskWithRequest:request fromFile:outputFileURL];
    
    // Run it!
    [uploadTask resume];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    float progress = (float)totalBytesSent/(float)totalBytesExpectedToSend;
    [uploadProgressBar setProgress:progress animated:YES];
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
