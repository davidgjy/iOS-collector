//
//  TutorialView.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/17/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "TutorialView.h"
#import "Constant.h"

@implementation TutorialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
        
        UIImage *imgKnown = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"known@2x" ofType:@"png"]];
        UIImage *imgKnownSelected = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"known_selected@2x" ofType:@"png"]];
        UIButton *btnKnown = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, imgKnown.size.width, imgKnown.size.height )];
        [btnKnown setImage:imgKnown forState:UIControlStateNormal];
        [btnKnown setImage:imgKnownSelected forState:UIControlStateSelected];
        btnKnown.center = CGPointMake( frame.size.width * 5 / 6, frame.size.height - btnKnown.frame.size.height );
        [btnKnown addTarget:self action:@selector( onDoneTouched: ) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnKnown];
    
        UIImageView *imgvShare = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share@2x" ofType:@"png"]]];
        imgvShare.center = CGPointMake( frame.size.width / 2, 20.0f + btnKnown.frame.size.height / 2 + 50.0f );
        [self addSubview:imgvShare];
        
        UIImageView *imgvLR = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"leftright@2x" ofType:@"png"]]];
        imgvLR.center = CGPointMake( frame.size.width / 6, 368.0f );
        [self addSubview:imgvLR];
        
        UIImageView *imgvUD = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"updown@2x" ofType:@"png"]]];
        imgvUD.center = CGPointMake( frame.size.width * 5 / 6, 368.0f );
        [self addSubview:imgvUD];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)onDoneTouched:(id)sender {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *doc_dir = [directoryPaths objectAtIndex:0];
    NSString *filePath = [doc_dir stringByAppendingString:CONFIG_FILE_NAME];
    if( ![manager fileExistsAtPath:filePath] ) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"shouldShowTutorial", nil];
        BOOL ret = [dict writeToFile:filePath atomically:YES];
        if( ret ) {
            NSLog( @"success" );
        }
        else {
            NSLog( @"fail:%@", filePath );
        }
    }
    else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"shouldShowTutorial"];
        BOOL ret = [dict writeToFile:filePath atomically:YES];
        if( ret ) {
            NSLog( @"success" );
        }
        else {
            NSLog( @"fail" );
        }
    }
    [self removeFromSuperview];
}

@end
