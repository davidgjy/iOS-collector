//
//  Channel2ViewController.m
//  GenesisOrigin
//
//  Created by GuJinYi on 16/3/2.
//  Copyright © 2016年 Genesis. All rights reserved.
//

#import "Channel2ViewController.h"

@interface Channel2ViewController ()

@end

@implementation Channel2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Set the tab bar item's title
        self.tabBarItem.title = @"试听体验";
        
        // Create a UIImage from a file
        UIImage *image = [UIImage imageNamed:@"Channel2"];
        
        // Put that image on the tab bar item
        self.tabBarItem.image = image;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
