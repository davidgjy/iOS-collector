//
//  MainViewController.h
//  FitoutFace
//
//  Created by Yanjie Chen on 6/9/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (strong , nonatomic) UIView *webBox;

- (void)onEnterTouched:(id)sender;

@end
