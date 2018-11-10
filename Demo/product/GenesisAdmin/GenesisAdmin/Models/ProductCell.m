//
//  ProductCell.m
//  GenesisAdmin
//
//  Created by GuJinYi on 16/6/2.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

- (IBAction)showImage:(id)sender
{
    // Check a block object exists before calling it
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end

