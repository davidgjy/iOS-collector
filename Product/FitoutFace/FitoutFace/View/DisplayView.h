//
//  DisplayView.h
//  FitoutFace
//
//  Created by Yanjie Chen on 6/10/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kCornerStyleNone,
    kCornerStyleRound
}eCornerStyle;

@interface DisplayView : UIImageView {
    __strong UIImage *faceImage_;
    __strong UIImage *browImage_;
    __strong  UIImage *earImage_;
    __strong UIImage *eyeImage_;
    __strong UIImage *mouseImage_;
    __strong UIImage *glassesImage_;
    __strong UIImage *expressionImage_;
    __strong UIImage *bodyImage_;
    __strong UIImage *handImage_;
    __strong UIImage *itemImage_;
    __strong UIImage *backgroundImage_;
    __strong  UIImage *hairImage_;
    eCornerStyle cornerStyle_;
}

@property (nonatomic) UIImage *faceImage;
@property (nonatomic) UIImage *browImage;
@property (nonatomic) UIImage *earImage;
@property (nonatomic) UIImage *eyeImage;
@property (nonatomic) UIImage *mouseImage;
@property (nonatomic) UIImage *glassesImage;
@property (nonatomic) UIImage *expressionImage;
@property (nonatomic) UIImage *bodyImage;
@property (nonatomic) UIImage *handImage;
@property (nonatomic) UIImage *itemImage;
@property (nonatomic) UIImage *backgroundImage;
@property (nonatomic) UIImage * hairImage;
@property (nonatomic) eCornerStyle cornerStyle;

- (void)updateView;


@end
