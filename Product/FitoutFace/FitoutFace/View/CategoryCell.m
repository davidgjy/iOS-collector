//
//  CategoryCell.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/10/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

@synthesize titleLabel = titleLabel_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        titleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height )];
        titleLabel_.textAlignment = NSTextAlignmentCenter;
        titleLabel_.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLabel_];
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

@end
