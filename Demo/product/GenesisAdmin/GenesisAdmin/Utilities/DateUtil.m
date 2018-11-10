//
//  DateUtil.m
//  GenesisAdmin
//
//  Created by GuJinYi on 16/3/12.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

#pragma convert date to string

+ (NSString *)convertDateToString:(NSDate *)date withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

@end
