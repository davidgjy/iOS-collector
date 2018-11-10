//
//  LoadingViewController.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/9/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "LoadingViewController.h"
#import "TalkingData.h"
#include "AppDelegate.h"
#define BALL_ROTATE_PER_FRAME -0.6f
#define CIRCLE_ROTATE_PER_FRAME 0.5f

@interface LoadingViewController () {
    //float ballAngle_;
    float circleAngle_;
    
    //UIImageView *ballView_;
    UIImageView *circleView_;
    UIImageView *loadingText_;
    NSTimer *rotateTimer_;
}

@end

@implementation LoadingViewController

@synthesize editingViewController = editingViewController_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initBackgroundColor
{
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:1.0f green:222.0f / 255.0f blue:222.0f / 255.0f alpha:1.0f].CGColor, (id)[UIColor colorWithRed:241.0f / 255.0f green:228.0f / 255.0f blue:177.0f / 255.0f alpha:1.0f].CGColor, (id)[UIColor colorWithRed:222.0f / 255.0f green:244.0f / 255.0f blue:201.0f / 255.0f alpha:1.0f].CGColor, (id)[UIColor colorWithRed:199.0f / 255.0f green:245.0f / 255.0f blue:1.0f alpha:1.0f].CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.36f], [NSNumber numberWithFloat:0.72f], [NSNumber numberWithFloat:1.0f], nil];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height );
    layer.startPoint = CGPointMake( 0.5f, 0 );
    layer.endPoint = CGPointMake( 0.5f, 1.0f );
    layer.colors = colors;
    layer.locations = locations;
    layer.opacity = 0.4f;
    [self.view.layer addSublayer:layer];
}

- (void)initAnmationDog
{
    UIImageView* bgImageView= [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading_bg" ofType:@"png"]]];
    [bgImageView setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview: bgImageView];
    circleView_ = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dog_ani1" ofType:@"png"]]];
    [circleView_ setFrame:CGRectMake(0,0, 151/2, 332/2)];
    circleView_.center = CGPointMake( self.view.bounds.size.width / 2, self.view.bounds.size.height / 2 );
    [self.view addSubview:circleView_];
    
    NSMutableArray * arryM=[NSMutableArray array];
    for(int i=1;i<=10;i++)
    {
        NSString* imgName=[NSString stringWithFormat:@"dog_ani%d",i];
        [arryM addObject: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"]]];
    }
    [circleView_ setAnimationImages:arryM];
    [circleView_ setAnimationRepeatCount:20];
    [circleView_ setAnimationDuration:10*0.08f];
    [circleView_ startAnimating];
}

- (void)initAnmationText
{
    loadingText_ = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading_text_01" ofType:@"png"]]];
    [loadingText_  setFrame:CGRectMake(0,0, loadingText_.frame.size.width*0.5f, loadingText_.frame.size.height*0.5f)];
    [loadingText_ setAlpha:0.5f];
    loadingText_.center = CGPointMake( self.view.bounds.size.width /2, self.view.bounds.size.height*0.2f );
    [self.view addSubview:loadingText_];
    
    //  ballAngle_ = 0;
    
    circleAngle_ = 0;
    // rotateTimer_ = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector( loadingAnimation: ) userInfo:nil repeats:YES];
    
    
    
    NSMutableArray * arryT=[NSMutableArray array];
    for(int i=1;i<=4;i++)
    {
        NSString* imgName=[NSString stringWithFormat:@"loading_text_0%d",i];
        [arryT addObject: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"]]];
    }
    [loadingText_ setAnimationImages:arryT];
    [loadingText_ setAnimationRepeatCount:30];
    [loadingText_ setAnimationDuration:4*0.35f];
    [loadingText_ startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self initBackgroundColor];

    [self initAnmationDog];
    
    [self initAnmationText];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"LoadingPage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"LoadingPage"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelectorInBackground:@selector( loadResources ) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadResources {
    editingViewController_ = [[EditingViewController alloc] init];
        [NSThread sleepForTimeInterval:1.5f];
    [self performSelectorOnMainThread:@selector( loadDidComplete ) withObject:nil waitUntilDone:YES];
}

- (void)loadDidComplete {
    if( rotateTimer_ ) {
        [rotateTimer_ invalidate];
    }
    
   
    [self.navigationController pushViewController:editingViewController_ animated:YES];
}

- (void)changeColor:(id)sender {
    static int i = 0;
    if( i == 0 ) {
        self.view.backgroundColor = [UIColor yellowColor];
        i = 1;
    }
    else {
        self.view.backgroundColor = [UIColor whiteColor];
        i = 0;
    }
}

- (void)loadingAnimation:(float)delta {
    //ballAngle_ += BALL_ROTATE_PER_FRAME;
    circleAngle_ += CIRCLE_ROTATE_PER_FRAME;
    
    /*if( ballAngle_ >= M_PI * 2 ) {
        ballAngle_ -= M_PI * 2;
    }
    else if( ballAngle_ < 0 ) {
        ballAngle_ += M_PI * 2;
    }*/
    if( circleAngle_ < 0 ) {
        circleAngle_ += M_PI * 2;
    }
    else if( circleAngle_ >= M_PI * 2 ) {
        circleAngle_ -= M_PI * 2;
    }
    
    //ballView_.transform = CGAffineTransformMakeRotation( ballAngle_ );
    //circleView_.transform = CGAffineTransformMakeRotation( circleAngle_ );
    int aniIndex=(int)circleAngle_;
    
    if(aniIndex>10)
    {
        aniIndex=1;
        circleAngle_=0;
    }
   // NSString* imgName=[NSString stringWithFormat:@"dog_ani%d",aniIndex];
   // UIImage * img=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"]];
   // circleView_.image=img;
}

@end
