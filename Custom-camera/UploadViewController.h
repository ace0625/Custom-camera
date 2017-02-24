//
//  UploadViewController.h
//  Custom-camera
//
//  Created by Dan Hyunchan Kim on 2/24/17.
//  Copyright © 2017 hyunchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgressBar;
- (IBAction)cancelAction:(id)sender;
- (IBAction)uploadAction:(id)sender;

- (void)saveInLocalDevice:(UIImage *) image;
- (NSString *)generateUniquePath;
@end
