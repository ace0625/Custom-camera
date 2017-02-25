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

//Cancel Button
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Upload Button
- (IBAction)uploadAction:(id)sender {
    [self saveInLocalDevice:imagePreview.image];
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
        [self uploadImage:imagePreview.image];
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

/*
 Upload Image.
 */
- (void)uploadImage:(UIImage *)image {
    [uploadProgressBar setProgress:0.0 animated:NO];
   
    NSURL *url = [NSURL URLWithString:@"https://framer-16ab8.firebaseio.com/aaa.json"];
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = paths[0];
    NSString *filePath = [docDir stringByAppendingPathComponent:docDir];
    
    NSString *boundary = @"--123456789ABCD";
    
    NSString* str = @"teststring";
    NSData* imageData = [filePath dataUsingEncoding:NSUTF8StringEncoding];
    //    NSData *imageData = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSLog(@"data: %@", imageData);
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSData *httpBody = [self createBodyWithBoundary:boundary
                                              paths:filePath
                                          fieldName:@"MyFolder"];
    uploadTask = [session uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (!error && httpResp.statusCode == 200) {
            NSLog(@"Upload success!");
        } else {
            NSLog(@"Error: %@", httpResp);
        }}];
    [uploadTask resume];
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                             paths:(NSString *)path
                         fieldName:(NSString *)fieldName {
    NSMutableData *httpBody = [NSMutableData data];
    NSString *filename  = [path lastPathComponent];
    NSData   *data      = [NSData dataWithContentsOfFile:path];
    NSString *mimetype  = @"image/png";
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:data];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}


/*
 Track the process of upload and show in the progress bar.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    float progress = (float)totalBytesSent/(float)totalBytesExpectedToSend;
    [uploadProgressBar setProgress:progress animated:YES];
}

@end
