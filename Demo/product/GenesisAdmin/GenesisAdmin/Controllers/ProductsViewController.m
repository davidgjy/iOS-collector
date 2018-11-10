//
//  ProductsTableViewController.m
//  GenesisAdmin
//
//  Created by GuJinYi on 16/3/12.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import "ProductsViewController.h"
#import "Product.h"
#import "ProductsStore.h"
#import "ProductDetailViewController.h"
#import "ProductCell.h"
#import "ProductImageStore.h"
#import "ProductImageViewController.h"

@interface ProductsViewController () <UIPopoverControllerDelegate>

// not sure if using
@property (nonatomic, strong) IBOutlet UIView *headerView;

@property (nonatomic, strong) UIPopoverController *imagePopover;

@end

@implementation ProductsViewController

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
//        for (int i = 0; i < 5; i++) {
//            [[ProductsStore sharedStore] createItem];
//        }
        
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Genesis";
        
        // Create a new bar button item that will send
        // addNewItem: to ProductsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    
    //NSLog(@"sizeof(NSInteger) = %@", @(sizeof(NSInteger)));
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
    */
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"ProductCell" bundle:nil];
    
    // Register this NIB, which contains the cell
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"ProductCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

/*
// using lazy instantiation to init headerView
- (UIView *)headerView
{
    // If you haven't loaded the headerView yet...
    if (!_headerView) {
        
        // Load HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    
    return _headerView;
}

- (IBAction)toggleEditingMode:(id)sender
{
    // If you are currently in editing mode...
    if (self.isEditing) {
        // Change text of button to inform user of state
        [sender setTitle:@"编 辑" forState:UIControlStateNormal];
        
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    } else {
        // Change tet of button to inform user of state
        [sender setTitle:@"完 成" forState:UIControlStateNormal];
        
        // Enter editing mode
        [self setEditing:YES animated:YES];
    }
}
*/

- (IBAction)addNewItem:(id)sender
{
    // Create a new product and add it to the store(very important!!)
    Product *newItem = [[ProductsStore sharedStore] createItem];
    
    /*
    NSInteger lastRow = [[[ProductsStore sharedStore] allItems] indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
    */
    
    ProductDetailViewController *detailViewController = [[ProductDetailViewController alloc] initForNewProduct:YES];
    detailViewController.item = newItem;
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;

    [self presentViewController:navController animated:YES completion:NULL];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ProductsStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Get a new or recycled cell
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    NSArray *items = [[ProductsStore sharedStore] allItems];
    Product *item = items[indexPath.row];
    
    //cell.textLabel.text = [item briefInfo];
    
    // Configure the cell with the product item
    cell.nameLabel.text = item.name;
    cell.descriptionLabel.text = item.prodDesp;
    cell.valueLabel.text = @"$10";
    cell.thumbnailView.image = item.thumbnail;
    
    __weak ProductCell *weakCell = cell;
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
        
        ProductCell *strongCell = weakCell;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.itemKey;
            // If there is no image, we don't need to display anything
            UIImage *img = [[ProductImageStore sharedStore] imageForKey:itemKey];
            if (!img) {
                return;
            }
            // Make a rectangle for the frame of the thumbnail relative to our table view
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds
                                        fromView:strongCell.thumbnailView];
            // Create a new ProductImageViewController and set its image
            ProductImageViewController *ivc = [[ProductImageViewController alloc] init];
            ivc.image = img;
            // Present a 600x600 popover from the rect
            self.imagePopover = [[UIPopoverController alloc]
                                 initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
        }
    };
    
    return cell;
}

- (void)   tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[ProductsStore sharedStore] allItems];
        Product *item = items[indexPath.row];
        [[ProductsStore sharedStore] removeItem:item];
        
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)   tableView:(UITableView *)tableView
  moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
         toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[ProductsStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ProductDetailViewController *detailViewController = [[ProductDetailViewController alloc] init];
    ProductDetailViewController *detailViewController = [[ProductDetailViewController alloc] initForNewProduct:NO];
    
    NSArray *items = [[ProductsStore sharedStore] allItems];
    Product *selectedItem = items[indexPath.row];
    
    // Give detail view controller a pointer to the item object in row
    detailViewController.item = selectedItem;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

@end
