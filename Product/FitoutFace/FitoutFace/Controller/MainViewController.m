//
//  MainViewController.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/9/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "MainViewController.h"
#import "LoadingViewController.h"
#import "../AppDelegate.h"
#import "Animations.h"
#import "TalkingData.h"

@interface MainViewController () {
    UIButton *btnEnter_;
    UIButton *btnMaleEnter_;
    UIButton *btnFemaleEnter_;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"MainPage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //渐变
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
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"title@2x" ofType:@"png"]]];
    titleView.center = CGPointMake( self.view.frame.size.width / 2, self.view.frame.size.height*0.20f );
    [self.view addSubview:titleView];
    
    float yOffset=(self.view.frame.size.height-180)/2;      //self.view.frame.size.height*0.15f +titleView.frame.size.height+20.0f;
    
    UIImage *dogImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start-d@2x" ofType:@"png"]];
    UIImage *dogSelectedImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start-d-click@2x" ofType:@"png"]];
    
    
    UIImage *maleImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start-m@2x" ofType:@"png"]];
    UIImage *maleSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start-m-click@2x" ofType:@"png"]];
    
    
    UIImage *femaleImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start-f@2x" ofType:@"png"]];
    UIImage *femaleSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start-f-click@2x" ofType:@"png"]];
    
    btnEnter_ = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, dogImage.size.width, dogImage.size.height )];
    [btnEnter_ setImage:dogImage forState:UIControlStateNormal];
    [btnEnter_ setImage:dogSelectedImage forState:UIControlStateHighlighted];
    btnEnter_.center = CGPointMake( 160.0f, yOffset);
    btnEnter_.tag=3;
    [btnEnter_ addTarget:self action:@selector( onEnterTouched: ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEnter_];
    
    yOffset=yOffset+btnEnter_.frame.size.height+10.0f;
    
    btnMaleEnter_ = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, maleImage.size.width, maleImage.size.height )];
    [btnMaleEnter_ setImage:maleImage forState:UIControlStateNormal];
    [btnMaleEnter_ setImage:maleSelectedImage forState:UIControlStateHighlighted];
    btnMaleEnter_.center= CGPointMake( btnEnter_.frame.origin.x+maleImage.size.width/2, yOffset );
    btnMaleEnter_.tag=1;
    [btnMaleEnter_ addTarget:self action:@selector( onEnterTouched: ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnMaleEnter_];
    
    btnFemaleEnter_ = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, femaleImage.size.width, femaleImage.size.height )];
    [btnFemaleEnter_ setImage:femaleImage forState:UIControlStateNormal];
    [btnFemaleEnter_ setImage:femaleSelectedImage forState:UIControlStateHighlighted];
    btnFemaleEnter_.center = CGPointMake( btnEnter_.frame.origin.x+dogImage.size.width- femaleImage.size.width/2, yOffset );
    [btnFemaleEnter_ addTarget:self action:@selector( onEnterTouched: ) forControlEvents:UIControlEventTouchUpInside];
    btnFemaleEnter_.tag=2;
    [self.view addSubview:btnFemaleEnter_];
    
    
//    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo@2x" ofType:@"png"]]];
//    logoView.center = CGPointMake( 160.0f, self.view.bounds.size.height - logoView.bounds.size.height - 50.0f );
//    [self.view addSubview:logoView];

    _webBox =[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-180,self.view.frame.size.width,180)];
    _webBox.hidden = YES;
    
    
        UIImageView *webBgView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cover_ad_bg" ofType:@"png"]]];
      [webBgView setFrame:CGRectMake(0, 0,_webBox.frame.size.width,_webBox.frame.size.height)];
       webBgView.center = CGPointMake( _webBox.frame.size.width/2, _webBox.frame.size.height/2 );
       [_webBox addSubview:webBgView];

    
  //  UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-180,self.view.frame.size.width,180)];
    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(20, 0,_webBox.frame.size.width-40,165)];
    
    webView.delegate = self;

    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate= self;
    singleTap.cancelsTouchesInView = NO;
    
    //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    [webView addGestureRecognizer:singleTap];
    // [webView setBackgroundColor:[UIColor colorWithRed:199.0f / 255.0f green:245.0f / 255.0f blue:1.0f alpha:1.0f]];

    NSString *path=@"http://www.fitout.cn/face/notice.aspx?type=iphone";
    NSURL *fileUrl=[[NSURL alloc] initWithString:path];
    webView.backgroundColor=[UIColor clearColor];

    for(UIView *subView in [webView subviews])
     {
         if([subView isKindOfClass:[UIScrollView class]]){
//             ((UIScrollView*) subView).bounces=NO;
//             ((UIScrollView *) subView).alwaysBounceVertical = NO;
             ((UIScrollView *) subView).scrollEnabled = NO;
             for(UIView* scrollView in subView.subviews)
             {
                if([scrollView isKindOfClass:[UIImageView class] ])
                    scrollView.hidden=YES;
             }
         }
     }
    
    [webView loadRequest:[NSURLRequest requestWithURL:fileUrl]];

    [_webBox addSubview:webView];
    [self.view addSubview:_webBox];
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _webBox.hidden = NO;
    [Animations fadeIn:self.webBox andAnimationDuration:2.0 andWait:YES];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
//    CGPoint point = [sender locationInView:self.view];
//    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
    NSString *path = [NSString stringWithFormat:@"weixin://http://testmpsdk.fitout.cn/RedirectUri.aspx?returnUrl=http://testmpsdk.fitout.cn/mpwebgame/clickfat/index.aspx"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [btnEnter_ setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start-d@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    [TalkingData trackPageBegin:@"MainPage"];
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

- (void)onEnterTouched:(id)sender {
    
     int tag_=(int)[(UIButton*)sender tag];
     //NSLog(@"tag:%d",tag);
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.gender=tag_;
    [self.navigationController pushViewController:[[LoadingViewController alloc] init] animated:YES];
    [btnEnter_ setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start-d-click@2x" ofType:@"png"]] forState:UIControlStateNormal];
}

@end
