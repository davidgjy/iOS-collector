//
//  ProductDetailViewController.h
//  GenesisAdmin
//
//  Created by GuJinYi on 16/3/22.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface ProductDetailViewController : UIViewController

@property (nonatomic, strong) Product *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (instancetype)initForNewProduct:(BOOL)isNew;

@end
