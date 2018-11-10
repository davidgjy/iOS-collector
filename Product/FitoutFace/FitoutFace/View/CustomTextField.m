//
//  CustomTextField.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/17/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //允许编辑本控件的文本属性
        self.allowsEditingTextAttributes = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawInRect:(CGRect)rect
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByClipping;
    style.alignment = NSTextAlignmentCenter;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 5.0f;
    shadow.shadowOffset = CGSizeMake( 0, 2.0f );
    shadow.shadowColor = [UIColor grayColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"GJJZhiYi-M12S" size:32.0f], NSFontAttributeName, [UIColor colorWithRed:1.0f green:238.0f / 255.0f blue:194.0f / 255.0f alpha:1.0f], NSForegroundColorAttributeName, [UIColor colorWithRed:114.0f / 255.0f green:51.0f / 255.0f blue:8.0f / 255.0f alpha:1.0f], NSStrokeColorAttributeName, style, NSParagraphStyleAttributeName, shadow,  NSShadowAttributeName, [NSNumber numberWithFloat:3.0f], NSStrokeWidthAttributeName, nil];
    NSString *t = nil;
    if( self.text == nil || [self.text isEqualToString:@""] ) {
        t = self.placeholder;
    }
    else {
        t = self.text;
    }
    [t drawInRect:self.bounds withAttributes:attributes];
}
*/

@end
