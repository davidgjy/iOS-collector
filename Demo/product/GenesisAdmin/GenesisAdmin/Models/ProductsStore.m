//
//  ProductsStore.m
//  GenesisAdmin
//
//  Created by GuJinYi on 16/3/12.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import "ProductsStore.h"
#import "Product.h"
#import "ProductImageStore.h"

@interface ProductsStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation ProductsStore

+ (instancetype)sharedStore
{
    static ProductsStore *sharedStore;
    
    /*
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    */
    
    // Ensure to create only one instance in muli-cpu devices
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

// If a programmer calls [[ProductsStore alloc] init], let him
// know the error of his ways
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[ProductsStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        //_privateItems = [[NSMutableArray alloc] init];
        
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (Product *)createItem
{
    Product *item = [Product randomItem];
    //Product *item = [[Product alloc] init];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(Product *)item
{
    NSString *key = item.itemKey;
    if (key) {
        [[ProductImageStore sharedStore] deleteImageForKey:key];
    }
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    
    // Get pointer to object being moved so you can re-insert it
    Product *item = self.privateItems[fromIndex];
    
    // Remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    // Insert item in array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
}

#pragma mark - Archive related

- (NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

@end

