//
//  Product.m
//  GenesisAdmin
//
//  Created by GuJinYi on 16/3/12.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import "Product.h"
#import "DateUtil.h"

static int count = 0;

@implementation Product

+(int)instanceCount
{
    return count;
}

+ (id)randomItem
{
    int id = count++;
    
    // Create an array of three product prefixes
    NSArray *randomProductList = @[@"游戏", @"视频", @"新闻"];
    
    // Create an array of three channel ids
    NSArray *randomChannelList = @[@1, @2, @3];
    
    int productIndex = rand() % [randomProductList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ - %d",
                            randomProductList[productIndex], id];
    NSString *randomDesp = [NSString stringWithFormat:@"%@ # 描述信息 - %d",
                            randomProductList[productIndex], id];
    
    int randChanId = (int)randomChannelList[productIndex];
    
    Product *newItem = [[self alloc] initWithId:id
                                           name:randomName
                                       prodDesp:randomDesp
                                      channelId: randChanId
                                          cover: @""
                                     attachment: @""
                                       statusId: 1];

    return newItem;
}

- (instancetype)initWithId:(int)id
                name:(NSString *)name
                prodDesp:(NSString *)desp
                channelId: (int)chId
                cover: (NSString *)cv
                attachment: (NSString *)atch
                statusId: (int)sId
{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        self.id = id;
        self.name = name;
        self.prodDesp = desp;
        self.channelId = chId;
        self.cover = cv;
        self.attachment = atch;
        self.statusId = sId;
        self.createTime = [[NSDate alloc] init];
        self.lastUpda = [[NSDate alloc] init];
    }
    
    // Create a NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    _itemKey = key;
    
    // Return the address of the newly initialized object
    return self;
}

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:
     @"Id: %d, Name: %@, Description: %@, Channel Id: %d, Cover: %@, Attachment: %@, Status Id: %d, Create Time: %@, Last Upda: %@",
     self.id,
     self.name,
     self.prodDesp,
     self.channelId,
     self.cover,
     self.attachment,
     self.statusId,
     [DateUtil convertDateToString:self.createTime withFormat:@"yyyy-MM-dd hh:mm"],
     [DateUtil convertDateToString:self.lastUpda withFormat:@"yyyy-MM-dd hh:mm"]];
    
    return descriptionString;
}

- (NSString *)briefInfo
{
    NSString *briefString =
    [[NSString alloc] initWithFormat:
     @"%d, %@, %@",
     self.id,
     self.name,
     [DateUtil convertDateToString:self.lastUpda withFormat:@"yyyy-MM-dd hh:mm"]];
    
    return briefString;
}

#pragma mark - Archive related

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _id = [aDecoder decodeIntForKey:@"id"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _prodDesp = [aDecoder decodeObjectForKey:@"prodDesp"];
        _channelId = [aDecoder decodeIntForKey:@"channelId"];
        _cover = [aDecoder decodeObjectForKey:@"cover"];
        _attachment = [aDecoder decodeObjectForKey:@"attachment"];
        _statusId = [aDecoder decodeIntForKey:@"statusId"];
        _createTime = [aDecoder decodeObjectForKey:@"createTime"];
        _lastUpda = [aDecoder decodeObjectForKey:@"lastUpda"];
        
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.id forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.prodDesp forKey:@"prodDesp"];
    [aCoder encodeInt:self.channelId forKey:@"channelId"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
    [aCoder encodeObject:self.attachment forKey:@"attachment"];
    [aCoder encodeInt:self.statusId forKey:@"statusId"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:self.lastUpda forKey:@"lastUpda"];
    
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    
}

#pragma mark - Thumbnail image related

- (void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    
    // The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    // Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    // Get the image from the image context; keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    // Cleanup image context resources; we're done
    UIGraphicsEndImageContext();
}

@end
