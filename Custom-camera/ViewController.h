//
//  ViewController.h
//  Custom-camera
//
//  Created by Dan Hyunchan Kim on 2/24/17.
//  Copyright © 2017 hyunchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *dataList;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *mainNavBar;
@property (weak, nonatomic) IBOutlet UIToolbar *mainToolBar;

- (IBAction)libraryAction:(id)sender;
- (IBAction)cameraAction:(id)sender;

@end

