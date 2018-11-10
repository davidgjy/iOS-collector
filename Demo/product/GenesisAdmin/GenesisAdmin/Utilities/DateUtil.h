//
//  DateUtil.h
//  GenesisAdmin
//
//  Created by GuJinYi on 16/3/12.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSString *)convertDateToString:(NSDate *)date withFormat:(NSString *)format;

@end
