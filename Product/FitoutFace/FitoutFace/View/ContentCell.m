//
//  ContentCell.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/10/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "ContentCell.h"

@interface ContentCell () {
    UIImageView *contentImageView_;
    UIImageView *outlineView_;
}

@end

@implementation ContentCell

@synthesize image = image_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        outlineView_ = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height )];
        UIImage *imgOutline = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"outline@2x" ofType:@"png"]];
        outlineView_.image = imgOutline;
        [self.contentView addSubview:outlineView_];
        outlineView_.hidden = YES;
        contentImageView_ = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0 , frame.size.width, frame.size.height)];
        contentImageView_.contentMode = UIViewContentModeScaleAspectFit;

        [self.contentView addSubview:contentImageView_];
        UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"edit_selected@2x" ofType:@"png"]]];
        self.selectedBackgroundView = selectedImageView;
        
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    if( image_ ) {
        image_ = nil;
    }
    image_ = image;
    if( image ) {
        [contentImageView_ setImage:image];
    }
}

- (void)setImage:(UIImage *)image resize:(BOOL)b {
    image_ = image;
    if( image ) {
        if( !b ) {
            [contentImageView_ setImage:image];
        }
        else {
            float scale = image.scale;
            CGImageRef imgRef = CGImageCreateWithImageInRect( image.CGImage, CGRectMake( 60.0 * scale, 120.0f * scale, image.size.width * scale - 120.0f * scale, image.size.height * scale - 120.0f * scale ) );
            UIImage *contentImage = [UIImage imageWithCGImage:imgRef scale:image.scale orientation:image.imageOrientation];
            CGImageRelease( imgRef );
            [contentImageView_ setImage:contentImage];
        }
    }
}

- (void)hideOutline:(BOOL)b {
    outlineView_.hidden = b;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
