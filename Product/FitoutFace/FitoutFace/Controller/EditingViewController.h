//
//  EditingViewController.h
//  FitoutFace
//
//  Created by Yanjie Chen on 6/9/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

- (void)prepareNavigationBar;
- (void)onGotoMainTouched:(id)sender;
- (void)onSaveTouched:(id)sender;
- (void)onSaveComplete:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
- (void)onShareTouched:(id)sender;
- (NSString*)getGenderLabel;
- (void)handleGesture:(UISwipeGestureRecognizer*)gesture;
- (int) indexToTag:(int) index;
@end
