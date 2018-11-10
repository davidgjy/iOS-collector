//
//  MainNavigationController.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/9/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "MainNavigationController.h"
#import "EditingViewController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationBarHidden = YES;
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSString *strClass = NSStringFromClass( viewController.class );
    if( [strClass isEqualToString:@"MainViewController"] ) {
        navigationController.navigationBarHidden = YES;
    }
    else if( [strClass isEqualToString:@"LoadingViewController"] ) {
        navigationController.navigationBarHidden = YES;
    }
    else if( [strClass isEqualToString:@"EditingViewController"] ) {
        navigationController.navigationBarHidden = NO;
        [(EditingViewController*)viewController prepareNavigationBar];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

@end
