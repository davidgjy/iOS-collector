//
//  ProductImageViewController.m
//  GenesisAdmin
//
//  Created by GuJinYi on 16/6/3.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import "ProductImageViewController.h"

@interface ProductImageViewController ()

@end

@implementation ProductImageViewController

- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // We must cast the view to UIImageView so the compiler knows it
    // is okay to send it setImage:
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = self.image;
}

@end
