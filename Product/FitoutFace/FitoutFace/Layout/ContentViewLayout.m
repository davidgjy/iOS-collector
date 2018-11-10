//
//  ContentViewLayout.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/10/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "ContentViewLayout.h"

@implementation ContentViewLayout

- (id)init {
    if( ( self = [super init] ) ) {
        self.itemSize = CGSizeMake( 106.0f, 66.0f );
        self.sectionInset = UIEdgeInsetsMake( 1.0f, 0, 0, 0 );
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 1.0f;
    }
    return self;
}

@end
