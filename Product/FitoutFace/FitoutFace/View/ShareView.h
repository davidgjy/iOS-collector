//
//  ShareView.h
//  FitoutFace
//
//  Created by Yanjie Chen on 6/11/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate <NSObject>

- (void)onWeiboTouched;
- (void)onMomentTouched;
- (void)onWechatTouched;

@end

@interface ShareView : UIView {
    id<ShareViewDelegate> delegate_;
    __strong UIImage *image_;
    UITextView *textView_;
}

@property (nonatomic) id<ShareViewDelegate> delegate;
@property (nonatomic) UIImage *image;

- (id)initWithFrame:(CGRect)frame contentSize:(CGSize)size;

- (void)onCloseTouched:(id)sender;
- (void)onWeiboTouched:(id)sender;
- (void)onMomentTouched:(id)sender;
- (void)onWechatTouched:(id)sender;
- (void)handleGesture:(UIGestureRecognizer*)gesture;

@end
