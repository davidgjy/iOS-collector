//
//  LoadingViewController.h
//  FitoutFace
//
//  Created by Yanjie Chen on 6/9/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditingViewController.h"

@interface LoadingViewController : UIViewController {
    __strong EditingViewController *editingViewController_;
}

@property (atomic) EditingViewController *editingViewController;


- (void)loadResources;
- (void)loadDidComplete;
- (void)changeColor:(id)sender;

- (void)loadingAnimation:(float)delta;

@end
