//
//  Product.h
//  GenesisAdmin
//
//  Created by GuJinYi on 16/3/12.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Product : NSObject <NSCoding>

+ (instancetype)randomItem;

+ (int)instanceCount;

- (instancetype)initWithId:(int)id
                  name:(NSString *)name
                  prodDesp:(NSString *)desp
                  channelId: (int)chId
                  cover: (NSString *)cv
                  attachment: (NSString *)atch
                  statusId: (int)sId;
- (NSString *)briefInfo;

@property (nonatomic) int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *prodDesp;
@property (nonatomic) int channelId;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *attachment;
@property (nonatomic) int statusId;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *lastUpda;

@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic, strong) UIImage *thumbnail;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
