//
//  ContentCell.h
//  FitoutFace
//
//  Created by Yanjie Chen on 6/10/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCell : UICollectionViewCell {
    __strong UIImage *image_;
}

@property (nonatomic, setter = setImage:) UIImage *image;

- (void)setImage:(UIImage *)image;
- (void)setImage:(UIImage *)image resize:(BOOL)b;
- (void)hideOutline:(BOOL)b;

@end
