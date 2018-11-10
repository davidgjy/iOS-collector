//
//  DisplayView.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/10/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "DisplayView.h"

#define BACKGROUND_SHRINK_POINTS 33.0f

@implementation DisplayView

@synthesize cornerStyle = cornerStyle_;
@synthesize faceImage = faceImage_;
@synthesize browImage = browImage_;
@synthesize eyeImage = eyeImage_;
@synthesize mouseImage = mouseImage_;
@synthesize glassesImage = glassesImage_;
@synthesize expressionImage = expressionImage_;
@synthesize bodyImage = bodyImage_;
@synthesize handImage = handImage_;
@synthesize itemImage = itemImage_;
@synthesize backgroundImage = backgroundImage_;
@synthesize hairImage=hairImage_;
@synthesize earImage=earImage_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        faceImage_ = nil;
        browImage_ = nil;
        eyeImage_ = nil;
        mouseImage_ = nil;
        glassesImage_ = nil;
        expressionImage_ = nil;
        bodyImage_ = nil;
        handImage_ = nil;
        itemImage_ = nil;
        backgroundImage_ = nil;
        hairImage_=nil;
        earImage_=nil;
        cornerStyle_ = kCornerStyleNone;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)updateView {
    float scale = faceImage_.scale; //2
    CGSize size = CGSizeMake( self.bounds.size.width * scale, self.bounds.size.height * scale );//640,462
    UIGraphicsBeginImageContext( size );
    CGRect rect = CGRectMake( 0, 0, size.width, size.height );//640,462
    CGContextRef context = UIGraphicsGetCurrentContext();
    float left = ( rect.size.width - rect.size.height + BACKGROUND_SHRINK_POINTS * scale ) / 2;//640-462+33*2=122
    float top = BACKGROUND_SHRINK_POINTS * scale; //66
    float right = rect.size.width - ( rect.size.width - rect.size.height + BACKGROUND_SHRINK_POINTS * scale ) / 2; //518
    float bottom = rect.size.height;//462
    CGContextSaveGState( context );
    if( cornerStyle_ == kCornerStyleRound ) {
        CGContextMoveToPoint( context, left, rect.size.height / 2 );
        CGContextAddArcToPoint( context, left, top, rect.size.width / 2, top, 20.0f );
        CGContextAddArcToPoint( context, right, top, right, rect.size.height / 2, 20.0f );
        CGContextAddArcToPoint( context, right, bottom, rect.size.width / 2, bottom, 20.0f );
        CGContextAddArcToPoint( context, left, bottom, left, rect.size.height / 2, 20.0f );
        CGContextClip( context );
    }
    CGContextTranslateCTM( context, 0, size.height );
    CGContextScaleCTM( context, 1.0f, -1.0f );
    if( backgroundImage_ ) {
        CGContextDrawImage( context, rect, backgroundImage_.CGImage );
    }
    else {
        CGContextSetFillColorWithColor( context, [UIColor colorWithRed:0.969f green:0.714f blue:0.408f alpha:1.0f].CGColor );
        CGContextFillRect( context, rect );
    }
    CGContextRestoreGState( context );
    CGContextSaveGState( context );
    CGContextTranslateCTM( context, 0, size.height );
    CGContextScaleCTM( context, 1.0f, -1.0f );
    

    if(earImage_)
    {
        CGContextDrawImage( context, rect, earImage_.CGImage );
    }
    if( bodyImage_ ) {
        CGContextDrawImage( context, rect, bodyImage_.CGImage );
    }
    if( faceImage_ ) {
        CGContextDrawImage( context, rect, faceImage_.CGImage );
    }
    if( expressionImage_ ) {
        CGContextDrawImage( context, rect, expressionImage_.CGImage );
    }
    if( mouseImage_ ) {
        CGContextDrawImage( context, rect, mouseImage_.CGImage );
    }
    if( browImage_ ) {
        CGContextDrawImage( context, rect, browImage_.CGImage );
    }
    if( eyeImage_ ) {
        CGContextDrawImage( context, rect, eyeImage_.CGImage );
    }
    if(hairImage_){
        CGContextDrawImage(context, rect, hairImage_.CGImage);
    }
    if( glassesImage_ ) {
        CGContextDrawImage( context, rect, glassesImage_.CGImage );
    }
    if( itemImage_ ) {
        CGContextDrawImage( context, rect, itemImage_.CGImage );
    }

    if( handImage_ ) {
        CGContextDrawImage( context, rect, handImage_.CGImage );
    }
    
    CGContextRestoreGState( context );
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:faceImage_.scale orientation:faceImage_.imageOrientation];
    self.image = nil;
    self.image = image;
    UIGraphicsEndImageContext();
    
}

@end
