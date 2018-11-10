//
//  ProductDetailViewController.m
//  GenesisAdmin
//
//  Created by GuJinYi on 16/3/22.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "Product.h"
#import "ProductImageStore.h"
#import "ProductsStore.h"

@interface ProductDetailViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,
    UITextFieldDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *imagePickerPopover;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@end

@implementation ProductDetailViewController

- (instancetype)initForNewProduct:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneProduct = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneProduct;
            
            UIBarButtonItem *cancelProduct = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelProduct;
        }
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewProduct:"
                                 userInfo:nil];
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _descriptionField.layer.borderColor = UIColor.grayColor.CGColor;
    _descriptionField.layer.borderWidth = 1;
    _descriptionField.layer.cornerRadius = 6;
    _descriptionField.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    Product *item = self.item;
    
    self.nameField.text = item.name;
    self.descriptionField.text = item.prodDesp;
    
    // You need a NSDateFormatter that will turn a date into a simple date string
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    // Use filtered NSDate object to set dateLabel contents
    self.lastUpdaLabel.text = [dateFormatter stringFromDate:item.lastUpda];
    
    NSString *itemKey = self.item.itemKey;
    if (itemKey) {
        // Get image for image key from the image store
        UIImage *imageToDisplay = [[ProductImageStore sharedStore] imageForKey:itemKey];
        
        // Use that image to put on the screen in imageView
        self.imageView.image = imageToDisplay;
    } else {
        // Clear the imageView
        self.imageView.image = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    Product *item = self.item;
    item.name = self.nameField.text;
    item.prodDesp = self.descriptionField.text;
    item.lastUpda = [[NSDate alloc] init];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    // Is it an iPad? No preparation necessary
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // Is it landscape?
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)save:(id)sender
{
    NSLog(@"Save product...");
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    NSLog(@"Cancel saving product...");
    
    // If the user cancelled, then remoce the Product from the store
    [[ProductsStore sharedStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)setItem:(Product *)item
{
    _item = item;
    self.navigationItem.title = _item.name;
}

# pragma mark - camera related

- (IBAction)takePicture:(UIBarButtonItem *)sender
{
    // In case press camera button twice crash
    if ([self.imagePickerPopover isPopoverVisible]) {
        // If the popover is already up, get rid of it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device ahs a camera, take a picture, otherwise,
    // just pick from the photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    //[self presentViewController:imagePicker animated:YES completion:nil];
    
    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        // Create a new popover controller that will display the imagePicker
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        self.imagePickerPopover.delegate = self;
        
        // Display the popover controller; sender is the camera bar button item
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Create thumbnail image from full image
    [self.item setThumbnailFromImage:image];

    // Store the image in the ProductImageStore for this key
    [[ProductImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    // Put that image onto the screen in our image view
    self.imageView.image = image;
    
    // Take image picker off the screen, you must call this dismiss method
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    // Do I have a popover?
    if (self.imagePickerPopover) {
        
        // Dismiss it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        NSLog(@"Dismisss product detail view from image picker...");
        
        // Dismiss the modal image picker
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

# pragma mark - textfield related

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

/*
# pragma mark - debug constraints

// for debug constraints only
- (void)viewDidLayoutSubviews {
    for (UIView *subView in self.view.subviews) {
        if ([subView hasAmbiguousLayout])
            NSLog(@"AMBIGUOUS: %@", subView);
    }
}
*/

@end
