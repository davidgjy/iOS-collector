//
//  ProductCell.h
//  GenesisAdmin
//
//  Created by GuJinYi on 16/6/2.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

// To view the large image
@property (copy, nonatomic) void (^actionBlock)(void);

@end

