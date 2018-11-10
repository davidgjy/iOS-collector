//
//  CategoryViewLayout.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/10/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "CategoryViewLayout.h"

@implementation CategoryViewLayout

- (id)init {
    if( ( self = [super init] ) ) {
        self.itemSize = CGSizeMake( 70.0f, 33.0f );
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake( 0, 0, 0, 0 );
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
    }
    return self;
}

@end
