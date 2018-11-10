//
//  EditingViewController.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/9/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "EditingViewController.h"
#import "EditingView.h"
#import "DisplayView.h"
#import "CategoryCell.h"
#import "ContentCell.h"
#import "CategoryViewLayout.h"
#import "ContentViewLayout.h"
#import "WXApi.h"
#import "ShareView.h"
#import "Constant.h"
#import "TutorialView.h"
#import "CustomTextField.h"
#import "AppDelegate.h"
#import "TalkingData.h"
#define CATEGORY_CELL_IDENTIFIER @"categoryCell"
#define CONTENT_CELL_IDENTIFIER @"contentCell"
//#define CATEGORY_COUNT 10
#define MAX_TEXT_LENGTH 10

#define DISPLAY_SCALE_FACTOR 0.8f

#define EDIT_MOVE_PIXELS 30.0f

@interface EditingViewController () {
    DisplayView *displayView_;
    UIImageView *textImageView_;
    CustomTextField *textView_;
    EditingView *editingView_;
    UICollectionView *categoryView_;
    UIView *containerView_;
    ShareView *shareView_;
    
    float baseY_;
    float statusBarHeight_;
    float contentHeight_;
    float contentCenterY_;
    int gender;
    int categoryCount;
    NSDictionary *textAttributes_;
    
    NSUInteger selectedIndex_;
}

- (void)scrollToEditingViewToIndex:(NSUInteger)index;
- (UIImage*)getDisplayImage;

@end

@implementation EditingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"EditPage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"EditPage"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    gender= delegate.gender;
    NSString *gLabel=[self getGenderLabel];
    
    if(gender==1)
        categoryCount=10;
    else if(gender==2)
        categoryCount=11;
    else if(gender==3)
        categoryCount =10;
    baseY_ = 0;
    statusBarHeight_ = 20.0f;
    if( [systemVersion hasPrefix:@"7"] ) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        baseY_ = 64.0f;
        statusBarHeight_ = 0;
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    //人物图片显示区
    displayView_ = [[DisplayView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, 231.0f )];
    displayView_.center = CGPointMake( displayView_.center.x, displayView_.center.y + baseY_ );
    [displayView_ setFaceImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_face1@2x",gLabel] ofType:@"png"]]];
    
    if (gender == 1) {
        
        displayView_.bodyImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_body2@2x",gLabel]  ofType:@"png"]];
    }  else if (gender == 2) {
        displayView_.bodyImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_body1@2x",gLabel]  ofType:@"png"]];
    } else {
         displayView_.bodyImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_body1@2x",gLabel]  ofType:@"png"]];
    }
    
    if (gender == 3) {
            displayView_.mouseImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_mouse1@2x",gLabel]  ofType:@"png"]];
    } else {
        
        displayView_.mouseImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_mouse3@2x",gLabel]  ofType:@"png"]];
    }
    
    if (gender == 1) {
        displayView_.browImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_brow3@2x",gLabel]  ofType:@"png"]];
    } else if (gender == 2) {
        displayView_.browImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_brow1@2x",gLabel]  ofType:@"png"]];
    } else {
        displayView_.browImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_brow1@2x",gLabel]  ofType:@"png"]];
    }
    
    if (gender == 3) {
        displayView_.eyeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_eye1@2x",gLabel]  ofType:@"png"]];
    } else {
        
        displayView_.eyeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_eye3@2x",gLabel]  ofType:@"png"]];
    }
    
    if (gender == 1) {
        displayView_.handImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_hand2@2x",gLabel]  ofType:@"png"]];
    } else if (gender == 2) {
        displayView_.handImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_hand1@2x",gLabel]  ofType:@"png"]];
        
    } else {
         displayView_.handImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_hand1@2x",gLabel]  ofType:@"png"]];
    }
    
    if (gender == 1) {
        displayView_.glassesImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_glasses5@2x",gLabel] ofType:@"png"]];
        
        displayView_.backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background17@2x" ofType:@"png"]];
    }  else if (gender == 2) {
        displayView_.backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background11@2x" ofType:@"png"]];
    } else {
        displayView_.backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background3@2x" ofType:@"png"]];
    }

    if(gender!=3)
    {
 
        displayView_.hairImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_hair1@2x",gLabel]  ofType:@"png"]];
//        displayView_.earImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"%@_ear2@2x" ofType:@"png"]];
    }else{
        displayView_.earImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_ear2@2x",gLabel]  ofType:@"png"]];
        displayView_.hairImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tail1@2x",gLabel]  ofType:@"png"]];
    }
  
    [self.view addSubview:displayView_];
    
    
    //文字图片显示
    textImageView_ = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 231.0, 67.0f )];
    textImageView_.center = CGPointMake( 160.0f, 245.0f + baseY_ );
    textImageView_.hidden = YES;
    textImageView_.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:textImageView_];
    
    
    //文字编辑显示
    textView_ = [[CustomTextField alloc] initWithFrame:CGRectMake( 0, 0, 231.0, 50.0f )];
    textView_.center = CGPointMake( 160.0f, 256.0f + baseY_ );
    textView_.textAlignment = NSTextAlignmentCenter;
    textView_.textColor = [UIColor colorWithRed:114.0f / 255.0f green:51.0f / 255.0f blue:8.0f / 255.0f alpha:1.0f];
    textView_.delegate = self;
    textView_.hidden = YES;
    textView_.font = [UIFont fontWithName:@"GJJZhiYi-M12S" size:32.0f];
    textView_.returnKeyType = UIReturnKeyDone;
    textView_.placeholder = @"输入文字";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByClipping;
    style.alignment = NSTextAlignmentCenter;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 5.0f;
    shadow.shadowOffset = CGSizeMake( 0, 2.0f );
    shadow.shadowColor = [UIColor grayColor];
    
    
    textAttributes_ = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"GJJZhiYi-M12S" size:32.0f], NSFontAttributeName, [UIColor colorWithRed:1.0f green:238.0f / 255.0f blue:194.0f / 255.0f alpha:1.0f], NSForegroundColorAttributeName, [UIColor colorWithRed:114.0f / 255.0f green:51.0f / 255.0f blue:8.0f / 255.0f alpha:1.0f], NSStrokeColorAttributeName, style, NSParagraphStyleAttributeName, shadow,  NSShadowAttributeName, [NSNumber numberWithFloat:3.0f], NSStrokeWidthAttributeName, nil];
    if( [systemVersion hasPrefix:@"7"] ) {
        textView_.defaultTextAttributes = textAttributes_;
    }
    /*else if( [systemVersion hasPrefix:@"6"] ) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector( textDidChange: ) name:UITextFieldTextDidChangeNotification object:textView_];
    }*/
    [self.view addSubview:textView_];
    
    
    //类别显示 如:衣服 眉毛。。。。
    categoryView_ = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, 32.0f ) collectionViewLayout:[[CategoryViewLayout alloc] init]];
    [categoryView_ registerClass:[CategoryCell class] forCellWithReuseIdentifier:CATEGORY_CELL_IDENTIFIER];
    categoryView_.center = CGPointMake( 160.0f, 247.0f + baseY_ );
    categoryView_.backgroundColor = [UIColor clearColor];
    categoryView_.bounces = NO;
    [self.view addSubview:categoryView_];
    categoryView_.delegate = self;
    categoryView_.dataSource = self;
    [categoryView_ selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    contentHeight_ = window.frame.size.height - 327.0f; //241
    contentCenterY_ = window.frame.size.height - ( contentHeight_ ) / 2; //447.5
    UIColor *contentBgColor = [[UIColor alloc] initWithRed:0.847f green:0.847f blue:0.847f alpha:1.0f];

    float containerWidth = 320.0f * categoryCount;
    containerView_ = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, containerWidth, contentHeight_ )];
    containerView_.center = CGPointMake( containerWidth / 2, contentCenterY_ - 64.0f + baseY_ );
    [self.view addSubview:containerView_];

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector( handleGesture: )];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [containerView_ addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector( handleGesture: )];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [containerView_ addGestureRecognizer:swipeRight];
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    UICollectionView *bodysView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, contentHeight_ ) collectionViewLayout:[[ContentViewLayout alloc] init]];
    
    bodysView.backgroundColor = contentBgColor;
    [bodysView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
    bodysView.center = CGPointMake( 160.0f, contentHeight_ / 2 );
    [containerView_ addSubview:bodysView];
    bodysView.dataSource = self;
    bodysView.delegate = self;
    bodysView.tag = 1;
    [bodysView selectItemAtIndexPath:firstIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    /*UICollectionView *browsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, contentHeight_ ) collectionViewLayout:[[ContentViewLayout alloc] init]];
    browsView.backgroundColor = contentBgColor;
    [browsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
    browsView.center = CGPointMake( 480.0f, contentHeight_ / 2 );
    [containerView_ addSubview:browsView];
    browsView.dataSource = self;
    browsView.delegate = self;
    browsView.tag = 2;
    [browsView selectItemAtIndexPath:firstIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    UICollectionView *eyesView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, contentHeight_ ) collectionViewLayout:[[ContentViewLayout alloc] init]];
    eyesView.backgroundColor = contentBgColor;
    [eyesView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
    eyesView.center = CGPointMake( 800.0f, contentHeight_ / 2 );
    [containerView_ addSubview:eyesView];
    eyesView.dataSource = self;
    eyesView.delegate = self;
    eyesView.tag = 3;
    [eyesView selectItemAtIndexPath:firstIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    UICollectionView *mousesView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, contentHeight_ ) collectionViewLayout:[[ContentViewLayout alloc] init]];
    mousesView.backgroundColor = contentBgColor;
    [mousesView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
    mousesView.center = CGPointMake( 1120.0f, contentHeight_ / 2 );
    [containerView_ addSubview:mousesView];
    mousesView.dataSource = self;
    mousesView.delegate = self;
    mousesView.tag = 4;
    [mousesView selectItemAtIndexPath:firstIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    UICollectionView *handsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, contentHeight_ ) collectionViewLayout:[[ContentViewLayout alloc] init]];
    handsView.backgroundColor = contentBgColor;
    [handsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
    handsView.center = CGPointMake( 1440.0f, contentHeight_ / 2 );
    [containerView_ addSubview:handsView];
    handsView.dataSource = self;
    handsView.delegate = self;
    handsView.tag = 5;
    [handsView selectItemAtIndexPath:firstIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    UICollectionView *expressionsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, contentHeight_ ) collectionViewLayout:[[ContentViewLayout alloc] init]];
    expressionsView.backgroundColor = contentBgColor;
    [expressionsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
    expressionsView.center = CGPointMake( 1760.0f, contentHeight_ / 2 );
    [containerView_ addSubview:expressionsView];
    expressionsView.dataSource = self;
    expressionsView.delegate = self;
    expressionsView.tag = 6;
    [expressionsView selectItemAtIndexPath:firstIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    UICollectionView *glassedView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, contentHeight_ ) collectionViewLayout:[[ContentViewLayout alloc] init]];
    glassedView.backgroundColor = contentBgColor;
    [glassedView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
    glassedView.center = CGPointMake( 2080.0f, contentHeight_ / 2 );
    [containerView_ addSubview:glassedView];
    glassedView.dataSource = self;
    glassedView.delegate = self;
    glassedView.tag = 7;
    [glassedView selectItemAtIndexPath:firstIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    UICollectionView *itemsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, contentHeight_ ) collectionViewLayout:[[ContentViewLayout alloc] init]];
    itemsView.backgroundColor = contentBgColor;
    [itemsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
    itemsView.center = CGPointMake( 2400.0f, contentHeight_ / 2 );
    [containerView_ addSubview:itemsView];
    itemsView.dataSource = self;
    itemsView.delegate = self;
    itemsView.tag = 8;
    [itemsView selectItemAtIndexPath:firstIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    UICollectionView *backgroundsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, contentHeight_ ) collectionViewLayout:[[ContentViewLayout alloc] init]];
    backgroundsView.backgroundColor = contentBgColor;
    [backgroundsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
    backgroundsView.center = CGPointMake( 2720.0f, contentHeight_ / 2 );
    [containerView_ addSubview:backgroundsView];
    backgroundsView.dataSource = self;
    backgroundsView.delegate = self;
    backgroundsView.tag = 9;
    [backgroundsView selectItemAtIndexPath:firstIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    UICollectionView *textsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, contentHeight_ ) collectionViewLayout:[[ContentViewLayout alloc] init]];
    textsView.backgroundColor = contentBgColor;
    [textsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
    textsView.center = CGPointMake( 3040.0f, contentHeight_ / 2 );
    [containerView_ addSubview:textsView];
    textsView.dataSource = self;
    textsView.delegate = self;
    textsView.tag = 10;
    [textsView selectItemAtIndexPath:firstIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];*/

    selectedIndex_ = 1;
    
    shareView_ = nil;
    
    [displayView_ updateView];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *doc_dir = [directoryPaths objectAtIndex:0];
    NSString *filePath = [doc_dir stringByAppendingString:CONFIG_FILE_NAME];
    NSLog(@"-----%@",filePath);
    BOOL shouldShowTutorial = YES;
    if( [manager fileExistsAtPath:filePath] ) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSNumber *n = [dict objectForKey:@"shouldShowTutorial"];
        if( n ) {
            shouldShowTutorial = [n boolValue];
        }
    }
    if( shouldShowTutorial ) {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        TutorialView *tv = [[TutorialView alloc] initWithFrame:CGRectMake( 0, 0, window.frame.size.width, window.frame.size.height )];
        [window addSubview:tv];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog( @"memory warning!" );
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内存不足,建议关闭部分其他应用。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
    containerView_.hidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)prepareNavigationBar {
    UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector( onGotoMainTouched: )];
    self.navigationItem.leftBarButtonItem = bbiLeft;
    
    UIBarButtonItem *bbiEmpty1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *bbiMiddle = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector( onSaveTouched: )];
    
    UIBarButtonItem *bbiEmpty2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *bbiRight = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector( onShareTouched: )];
    
    NSArray *rightBarItemArr = [NSArray arrayWithObjects:bbiMiddle, bbiEmpty1, bbiRight, bbiEmpty2, nil];
    [self.navigationItem setRightBarButtonItems:rightBarItemArr];
}

- (NSString*) getGenderLabel
{
    if( gender==2) {
        return @"female";
    } else if(gender==1) {
        return @"male";
    }
    return @"dog";
}

- (int) indexToTag:(int) index{
    if(gender==2)
    {
        //if(index==2)
        //    return 11;
        
    }
    return index;
}

- (void)scrollToEditingViewToIndex:(NSUInteger)index {
    //移除所有动画
    [containerView_.layer removeAllAnimations];
    
    if( selectedIndex_ != index ) {
        float viewHeight = ( textView_.hidden == NO || textImageView_.hidden == NO ) ? contentHeight_ - 48.0f : contentHeight_;
        UIColor *contentBgColor = [[UIColor alloc] initWithRed:0.847f green:0.847f blue:0.847f alpha:1.0f];
        if(gender==1)
        {
            switch( index ) {
                case 1:
                {
                    UICollectionView *bodysView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    bodysView.backgroundColor = contentBgColor;
                    [bodysView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    bodysView.center = CGPointMake( 160.0f, viewHeight / 2 );
                    [containerView_ addSubview:bodysView];
                    bodysView.dataSource = self;
                    bodysView.delegate = self;
                    bodysView.tag = [self indexToTag:index];
                    break;
                }
                case 2:
                {
                    UICollectionView *browsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    browsView.backgroundColor = contentBgColor;
                    [browsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    browsView.center = CGPointMake( 480.0f, viewHeight / 2 );
                    [containerView_ addSubview:browsView];
                    browsView.dataSource = self;
                    browsView.delegate = self;
                    browsView.tag = [self indexToTag:index];;
                    break;
                }
                case 3:
                {
                    UICollectionView *eyesView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    eyesView.backgroundColor = contentBgColor;
                    [eyesView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    eyesView.center = CGPointMake( 800.0f, viewHeight / 2 );
                    [containerView_ addSubview:eyesView];
                    eyesView.dataSource = self;
                    eyesView.delegate = self;
                    eyesView.tag = [self indexToTag:index];;
                    break;
                }
                case 4:
                {
                    UICollectionView *mousesView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    mousesView.backgroundColor = contentBgColor;
                    [mousesView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    mousesView.center = CGPointMake( 1120.0f, viewHeight / 2 );
                    [containerView_ addSubview:mousesView];
                    mousesView.dataSource = self;
                    mousesView.delegate = self;
                    mousesView.tag = [self indexToTag:index];;
                    break;
                }
                case 5:
                {
                    UICollectionView *handsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    handsView.backgroundColor = contentBgColor;
                    [handsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    handsView.center = CGPointMake( 1440.0f, viewHeight / 2 );
                    [containerView_ addSubview:handsView];
                    handsView.dataSource = self;
                    handsView.delegate = self;
                    handsView.tag = [self indexToTag:index];;
                    break;
                }
                case 6:
                {
                    UICollectionView *expressionsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    expressionsView.backgroundColor = contentBgColor;
                    [expressionsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    expressionsView.center = CGPointMake( 1760.0f, viewHeight / 2 );
                    [containerView_ addSubview:expressionsView];
                    expressionsView.dataSource = self;
                    expressionsView.delegate = self;
                    expressionsView.tag = [self indexToTag:index];;
                    break;
                }
                case 7:
                {
                    UICollectionView *glassedView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    glassedView.backgroundColor = contentBgColor;
                    [glassedView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    glassedView.center = CGPointMake( 2080.0f, viewHeight / 2 );
                    [containerView_ addSubview:glassedView];
                    glassedView.dataSource = self;
                    glassedView.delegate = self;
                    glassedView.tag = [self indexToTag:index];;
                    break;
                }
                case 8:
                {
                    UICollectionView *itemsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    itemsView.backgroundColor = contentBgColor;
                    [itemsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    itemsView.center = CGPointMake( 2400.0f, viewHeight / 2 );
                    [containerView_ addSubview:itemsView];
                    itemsView.dataSource = self;
                    itemsView.delegate = self;
                    itemsView.tag = [self indexToTag:index];
                    break;
                }
                case 9:
                {
                    UICollectionView *backgroundsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    backgroundsView.backgroundColor = contentBgColor;
                    [backgroundsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    backgroundsView.center = CGPointMake( 2720.0f, viewHeight / 2 );
                    [containerView_ addSubview:backgroundsView];
                    backgroundsView.dataSource = self;
                    backgroundsView.delegate = self;
                    backgroundsView.tag = [self indexToTag:index];
                    break;
                }
                case 10:
                {
                    UICollectionView *textsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    textsView.backgroundColor = contentBgColor;
                    [textsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    textsView.center = CGPointMake( 3040.0f, viewHeight / 2 );
                    [containerView_ addSubview:textsView];
                    textsView.dataSource = self;
                    textsView.delegate = self;
                    textsView.tag = [self indexToTag:index];
                    break;
                }
                case 11:
                {
                    UICollectionView *hairsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    hairsView.backgroundColor = contentBgColor;
                    [hairsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    hairsView.center = CGPointMake( 3360.0f, viewHeight / 2 );
                    [containerView_ addSubview:hairsView];
                    hairsView.dataSource = self;
                    hairsView.delegate = self;
                    hairsView.tag = [self indexToTag:index];
                    break;
                }
                default:
                    break;
            }
        }else if(gender==2){
            switch( index ) {
                case 1:
                {
                    UICollectionView *bodysView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    bodysView.backgroundColor = contentBgColor;
                    [bodysView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    bodysView.center = CGPointMake( 160.0f, viewHeight / 2 );
                    [containerView_ addSubview:bodysView];
                    bodysView.dataSource = self;
                    bodysView.delegate = self;
                    bodysView.tag = [self indexToTag:index];
                    break;
                }
                case 2:
                {
                    UICollectionView *browsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    browsView.backgroundColor = contentBgColor;
                    [browsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    browsView.center = CGPointMake( 480.0f, viewHeight / 2 );
                    [containerView_ addSubview:browsView];
                    browsView.dataSource = self;
                    browsView.delegate = self;
                    browsView.tag = [self indexToTag:index];;
                    break;
                }
                case 3:
                {
                    UICollectionView *eyesView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    eyesView.backgroundColor = contentBgColor;
                    [eyesView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    eyesView.center = CGPointMake( 800.0f, viewHeight / 2 );
                    [containerView_ addSubview:eyesView];
                    eyesView.dataSource = self;
                    eyesView.delegate = self;
                    eyesView.tag = [self indexToTag:index];;
                    break;
                }
                case 4:
                {
                    UICollectionView *mousesView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    mousesView.backgroundColor = contentBgColor;
                    [mousesView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    mousesView.center = CGPointMake( 1120.0f, viewHeight / 2 );
                    [containerView_ addSubview:mousesView];
                    mousesView.dataSource = self;
                    mousesView.delegate = self;
                    mousesView.tag = [self indexToTag:index];;
                    break;
                }
                case 5:
                {
                    UICollectionView *handsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    handsView.backgroundColor = contentBgColor;
                    [handsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    handsView.center = CGPointMake( 1440.0f, viewHeight / 2 );
                    [containerView_ addSubview:handsView];
                    handsView.dataSource = self;
                    handsView.delegate = self;
                    handsView.tag = [self indexToTag:index];;
                    break;
                }
                case 6:
                {
                    UICollectionView *expressionsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    expressionsView.backgroundColor = contentBgColor;
                    [expressionsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    expressionsView.center = CGPointMake( 1760.0f, viewHeight / 2 );
                    [containerView_ addSubview:expressionsView];
                    expressionsView.dataSource = self;
                    expressionsView.delegate = self;
                    expressionsView.tag = [self indexToTag:index];;
                    break;
                }
                case 7:
                {
                    UICollectionView *glassedView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    glassedView.backgroundColor = contentBgColor;
                    [glassedView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    glassedView.center = CGPointMake( 2080.0f, viewHeight / 2 );
                    [containerView_ addSubview:glassedView];
                    glassedView.dataSource = self;
                    glassedView.delegate = self;
                    glassedView.tag = [self indexToTag:index];;
                    break;
                }
                case 8:
                {
                    UICollectionView *itemsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    itemsView.backgroundColor = contentBgColor;
                    [itemsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    itemsView.center = CGPointMake( 2400.0f, viewHeight / 2 );
                    [containerView_ addSubview:itemsView];
                    itemsView.dataSource = self;
                    itemsView.delegate = self;
                    itemsView.tag = [self indexToTag:index];
                    break;
                }
                case 9:
                {
                    UICollectionView *backgroundsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    backgroundsView.backgroundColor = contentBgColor;
                    [backgroundsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    backgroundsView.center = CGPointMake( 2720.0f, viewHeight / 2 );
                    [containerView_ addSubview:backgroundsView];
                    backgroundsView.dataSource = self;
                    backgroundsView.delegate = self;
                    backgroundsView.tag = [self indexToTag:index];
                    break;
                }
                case 10:
                {
                    UICollectionView *hairsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    hairsView.backgroundColor = contentBgColor;
                    [hairsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    hairsView.center = CGPointMake( 3040.0f, viewHeight / 2 );
                    [containerView_ addSubview:hairsView];
                    hairsView.dataSource = self;
                    hairsView.delegate = self;
                    hairsView.tag = [self indexToTag:index];
                    break;
                    
                }
                case 11:
                {
                    UICollectionView *textsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    textsView.backgroundColor = contentBgColor;
                    [textsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    textsView.center = CGPointMake( 3360.0f, viewHeight / 2 );
                    [containerView_ addSubview:textsView];
                    textsView.dataSource = self;
                    textsView.delegate = self;
                    textsView.tag = [self indexToTag:index];
                    break;
                }
                default:
                    break;
            }
        }else if(gender==3)
        {
            switch( index ) {
                case 1:
                {
                    UICollectionView *bodysView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    bodysView.backgroundColor = contentBgColor;
                    [bodysView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    bodysView.center = CGPointMake( 160.0f, viewHeight / 2 );
                    [containerView_ addSubview:bodysView];
                    bodysView.dataSource = self;
                    bodysView.delegate = self;
                    bodysView.tag = [self indexToTag:index];
                    break;
                }
                case 2:
                {
                    UICollectionView *earsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    earsView.backgroundColor = contentBgColor;
                    [earsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    earsView.center = CGPointMake( 480.0f, viewHeight / 2 );
                    [containerView_ addSubview:earsView];
                    earsView.dataSource = self;
                    earsView.delegate = self;
                    earsView.tag = [self indexToTag:index];
                    break;
                     
                }
                case 3:
                {
                    UICollectionView *browsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    browsView.backgroundColor = contentBgColor;
                    [browsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    browsView.center = CGPointMake( 800.0f, viewHeight / 2 );
                    [containerView_ addSubview:browsView];
                    browsView.dataSource = self;
                    browsView.delegate = self;
                    browsView.tag = [self indexToTag:index];;
                    break;
                    
                }
                case 4:
                {
                    UICollectionView *eyesView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    eyesView.backgroundColor = contentBgColor;
                    [eyesView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    eyesView.center = CGPointMake( 1120.0f, viewHeight / 2 );
                    [containerView_ addSubview:eyesView];
                    eyesView.dataSource = self;
                    eyesView.delegate = self;
                    eyesView.tag = [self indexToTag:index];;
                    break;
                }
                case 5:
                {
                    UICollectionView *mousesView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    mousesView.backgroundColor = contentBgColor;
                    [mousesView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    mousesView.center = CGPointMake( 1440.0f, viewHeight / 2 );
                    [containerView_ addSubview:mousesView];
                    mousesView.dataSource = self;
                    mousesView.delegate = self;
                    mousesView.tag = [self indexToTag:index];;
                    break;
                }
                case 6:
                {
                    UICollectionView *handsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    handsView.backgroundColor = contentBgColor;
                    [handsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    handsView.center = CGPointMake( 1760.0f, viewHeight / 2 );
                    [containerView_ addSubview:handsView];
                    handsView.dataSource = self;
                    handsView.delegate = self;
                    handsView.tag = [self indexToTag:index];;
                    break;
                }
                    //               case 6:
                    //               {
                    //                   UICollectionView *expressionsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    //                   expressionsView.backgroundColor = contentBgColor;
                    //                   [expressionsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    //                   expressionsView.center = CGPointMake( 1760.0f, viewHeight / 2 );
                    //                   [containerView_ addSubview:expressionsView];
                    //                   expressionsView.dataSource = self;
                    //                   expressionsView.delegate = self;
                    //                   expressionsView.tag = [self indexToTag:index];;
                    //                   break;
                    //               }
                case 7:
                {
                    UICollectionView *glassedView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    glassedView.backgroundColor = contentBgColor;
                    [glassedView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    glassedView.center = CGPointMake( 2080.0f, viewHeight / 2 );
                    [containerView_ addSubview:glassedView];
                    glassedView.dataSource = self;
                    glassedView.delegate = self;
                    glassedView.tag = [self indexToTag:index];;
                    break;
                }
                case 8:
                {
                    UICollectionView *itemsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    itemsView.backgroundColor = contentBgColor;
                    [itemsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    itemsView.center = CGPointMake( 2400.0f, viewHeight / 2 );
                    [containerView_ addSubview:itemsView];
                    itemsView.dataSource = self;
                    itemsView.delegate = self;
                    itemsView.tag = [self indexToTag:index];
                    break;
                }
                case 9:
                {
                    UICollectionView *backgroundsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    backgroundsView.backgroundColor = contentBgColor;
                    [backgroundsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    backgroundsView.center = CGPointMake( 2720.0f, viewHeight / 2 );
                    [containerView_ addSubview:backgroundsView];
                    backgroundsView.dataSource = self;
                    backgroundsView.delegate = self;
                    backgroundsView.tag = [self indexToTag:index];
                    break;
                }
                case 10:
                {
                    UICollectionView *textsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    textsView.backgroundColor = contentBgColor;
                    [textsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    textsView.center = CGPointMake( 3040.0f, viewHeight / 2 );
                    [containerView_ addSubview:textsView];
                    textsView.dataSource = self;
                    textsView.delegate = self;
                    textsView.tag = [self indexToTag:index];
                    break;
                }
                case 11:
                {
                    UICollectionView *hairsView = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, 320.0f, viewHeight ) collectionViewLayout:[[ContentViewLayout alloc] init]];
                    hairsView.backgroundColor = contentBgColor;
                    [hairsView registerClass:[ContentCell class] forCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER];
                    hairsView.center = CGPointMake( 1440.0f, viewHeight / 2 );
                    [containerView_ addSubview:hairsView];
                    hairsView.dataSource = self;
                    hairsView.delegate = self;
                    hairsView.tag = [self indexToTag:index];
                    break;
                }
                default:
                    break;
            }
            
        }
        if(gender!=2){
            if( index == 10 ) {
                [textView_ setEnabled:YES];
            }
            else {
                [textView_ setEnabled:NO];
            }
        }else
        {
            if( index == 11 ) {
                [textView_ setEnabled:YES];
            }
            else {
                [textView_ setEnabled:NO];
            }
        }
        [UIView animateWithDuration:0.3f animations:^{
            containerView_.center = CGPointMake( 160.0f * categoryCount - ( index - 1 ) * 320.0f, containerView_.center.y);
        } completion:^(BOOL finished) {
            if( containerView_.subviews.count > 0 ) {
                for( UICollectionView *v in containerView_.subviews ) {
                    if( v.tag == selectedIndex_ ) {
                        [v removeFromSuperview];
                    }
                }
            }
            selectedIndex_ = index;
        }];
    }
}

- (void)handleGesture:(UISwipeGestureRecognizer*)gesture {
    if( gesture.direction == UISwipeGestureRecognizerDirectionLeft ) {
        NSUInteger nextIndex = selectedIndex_ + 1;
        if( nextIndex <= categoryCount ) {
            [categoryView_ selectItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex-1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            [self scrollToEditingViewToIndex:nextIndex];
        }
    }
    else if( gesture.direction == UISwipeGestureRecognizerDirectionRight ) {
        NSUInteger nextIndex = selectedIndex_ - 1;
        if( nextIndex >= 1 ) {
            [categoryView_ selectItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex-1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            [self scrollToEditingViewToIndex:nextIndex];
        }
    }
}


//获得当前图片
- (UIImage*)getDisplayImage {
    UIImage *retImage = nil;
    UIImage *originImage = displayView_.image;
    float scale = originImage.scale; //2
    CGSize size = CGSizeMake( originImage.size.width * scale, originImage.size.height * scale );//640,462
    float left = ( size.width - size.height ) / 2; //89
    CGRect rect = CGRectMake( left, 0, size.height, size.height );//(89,0,462,462)
    CGImageRef imgRef = CGImageCreateWithImageInRect( originImage.CGImage, rect );
    originImage = [UIImage imageWithCGImage:imgRef scale:originImage.scale orientation:originImage.imageOrientation];
    CGImageRelease( imgRef );
    if( textView_.hidden == YES && textImageView_.hidden == YES ) {
        retImage = originImage;
    }
    else if( textView_.hidden == NO ) {
        size = CGSizeMake( size.height, size.height + 35.0f * scale );
        UIGraphicsBeginImageContext( size );
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor( context, [UIColor whiteColor].CGColor );
        CGContextFillRect( context, CGRectMake( 0, 0, size.width, size.height ) );
        CGContextSaveGState( context );
        CGContextTranslateCTM( context, 0, size.height );
        CGContextScaleCTM( context, 1.0f, -1.0f );
        CGContextDrawImage( context, CGRectMake( 0, 35.0f * scale, size.width, size.width ), originImage.CGImage );
        CGContextRestoreGState( context );
        CGContextSaveGState( context );
        CGContextSetRGBFillColor( context, 1.0f, 238.0f / 255.0f, 194.0f / 255.0f, 1.0f );
        CGContextSetRGBStrokeColor( context, 114.0f / 255.0f, 51.0f / 255.0f, 8.0f / 255.0f, 1.0f );
        //CGContextSetRGBFillColor( context, 114.0f / 255.0f, 51.0f / 255.0f, 8.0f / 255.0f, 1.0f );
        //CGContextSetRGBStrokeColor( context, 1.0f, 238.0f / 255.0f, 194.0f / 255.0f, 1.0f );
        CGContextSetTextDrawingMode( context, kCGTextFillStroke );
        CGContextSetLineWidth( context, 1.0f * scale );
        CGContextSetShadowWithColor( context, CGSizeMake( 0, 3.0f * scale ), 5.0f, [UIColor grayColor].CGColor );
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByClipping;
        style.alignment = NSTextAlignmentCenter;
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowBlurRadius = 5.0f;
        shadow.shadowOffset = CGSizeMake( 0, 2.0f );
        shadow.shadowColor = [UIColor grayColor];

        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"GJJZhiYi-M12S" size:32.0f*scale], NSFontAttributeName, [UIColor colorWithRed:1.0f green:238.0f / 255.0f blue:194.0f / 255.0f alpha:1.0f], NSForegroundColorAttributeName, [UIColor colorWithRed:114.0f / 255.0f green:51.0f / 255.0f blue:8.0f / 255.0f alpha:1.0f], NSStrokeColorAttributeName, style, NSParagraphStyleAttributeName, shadow,  NSShadowAttributeName, [NSNumber numberWithFloat:3.0f], NSStrokeWidthAttributeName, nil];
        if( [[UIDevice currentDevice].systemVersion hasPrefix:@"7"] ) {
            [textView_.text drawInRect:CGRectMake( 0, size.height - 35.0f * scale, size.width, 35.0f * scale ) withAttributes:attributes];
        }
        else if( [[UIDevice currentDevice].systemVersion hasPrefix:@"6"] ) {
            //[textView_.attributedText drawInRect:CGRectMake( 0, size.height - 35.0f * scale, size.width, 35.0f * scale )];
            [textView_.text drawInRect:CGRectMake( 0, size.height - 35.0f * scale, size.width, 35.0f * scale ) withFont:[UIFont fontWithName:@"GJJZhiYi-M12S" size:32.0f*scale] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        }
        //[textView_.text drawInRect: withFont: lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        CGContextRestoreGState( context );
        retImage = UIGraphicsGetImageFromCurrentImageContext();
        retImage = [UIImage imageWithCGImage:retImage.CGImage scale:scale orientation:retImage.imageOrientation];
        UIGraphicsEndImageContext();
    }
    else if( textImageView_.hidden == NO ) {
        size = CGSizeMake( size.height, size.height + 48.0f * scale );//462,558
        UIGraphicsBeginImageContext( size );
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor( context, [UIColor whiteColor].CGColor );
        CGContextFillRect( context, CGRectMake( 0, 0, size.width, size.height ) );
        CGContextSaveGState( context );
        CGContextTranslateCTM( context, 0, size.height );
        CGContextScaleCTM( context, 1.0f, -1.0f );
        CGContextDrawImage( context, CGRectMake( 0, 48.0f * scale, size.width, size.width ), originImage.CGImage );
        CGContextDrawImage( context, CGRectMake( 0, 0, textImageView_.image.size.width * scale, 67.0f * scale ), textImageView_.image.CGImage );
        CGContextRestoreGState( context );
        retImage = UIGraphicsGetImageFromCurrentImageContext();
        retImage = [UIImage imageWithCGImage:retImage.CGImage scale:scale orientation:retImage.imageOrientation];
        UIGraphicsEndImageContext();
    }
    return retImage;
}


#pragma mark -- UIBarButtonItem Actions

//首页按钮点击事件
- (void)onGotoMainTouched:(id)sender {
    containerView_.hidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//保存按钮点击事件
- (void)onSaveTouched:(id)sender {
    NSLog( @"save!" );
    [textView_ resignFirstResponder];
    UIImage *imageToSave = [self getDisplayImage];
    if( imageToSave ) {
        UIImageWriteToSavedPhotosAlbum( imageToSave, self, @selector( onSaveComplete:didFinishSavingWithError:contextInfo: ), nil );
    }
}

//分享按钮点击事件
- (void)onShareTouched:(id)sender {
    NSLog( @"share" );
    [textView_ resignFirstResponder];
    if( shareView_ == nil ) {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        shareView_ = [[ShareView alloc] initWithFrame:CGRectMake( 0, 0, window.frame.size.width, window.frame.size.height ) contentSize:CGSizeMake( self.view.frame.size.width, containerView_.frame.size.height + categoryView_.frame.size.height )];
        [window addSubview:shareView_];
    }
    else {
        shareView_.hidden = NO;
    }
    shareView_.image = [self getDisplayImage];
}

//保存相册回调
- (void)onSaveComplete:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if( error.code == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"图片已保存到相册中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"图片保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}


#pragma mark -- UICollectionViewCell DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if( [collectionView isEqual:categoryView_] ) {
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [collectionView setUserInteractionEnabled:NO];
        
        [collectionView performSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5f];
        
        [self scrollToEditingViewToIndex:indexPath.row + 1];
        [textView_ resignFirstResponder];
    }
    else {
        ContentCell *cell = (ContentCell*)[collectionView cellForItemAtIndexPath:indexPath];
        NSLog(@"--tag:%d",collectionView.tag);
        if(gender==1){
        switch( collectionView.tag ) {
            case 1:
                displayView_.bodyImage = cell.image;
                break;
            case 2:
                displayView_.browImage = cell.image;
                break;
            case 3:
                displayView_.eyeImage = cell.image;
                break;
            case 4:
                displayView_.mouseImage = cell.image;
                break;
            case 5:
                displayView_.handImage = cell.image;
                break;
            case 6:
                if( indexPath.row == 0 ) {
                    displayView_.expressionImage = nil;
                }
                else {
                    displayView_.expressionImage = cell.image;
                }
                break;
            case 7:
                if( indexPath.row == 0 ) {
                    displayView_.glassesImage = nil;
                }
                else {
                    displayView_.glassesImage = cell.image;
                }
                break;
            case 8:
                if( indexPath.row == 0 ) {
                    displayView_.itemImage = nil;
                }
                else {
                    displayView_.itemImage = cell.image;
                }
                break;
            case 9:
                if( indexPath.row == 0 ) {
                    displayView_.backgroundImage = nil;
                }
                else {
                    displayView_.backgroundImage = cell.image;
                }
                break;
            case 10:
                if( indexPath.row == 0 ) {
                    displayView_.transform = CGAffineTransformMakeScale( 1.0f, 1.0f );
                    displayView_.cornerStyle = kCornerStyleNone;
                    textImageView_.hidden = YES;
                    textView_.hidden = YES;
                    containerView_.transform = CGAffineTransformIdentity;
                    categoryView_.transform = CGAffineTransformIdentity;
                    displayView_.transform = CGAffineTransformIdentity;
                    textView_.transform = CGAffineTransformIdentity;
                    textImageView_.transform = CGAffineTransformIdentity;
                    for( UICollectionView *v in containerView_.subviews ) {
                        v.frame = CGRectMake( v.frame.origin.x, v.frame.origin.y, v.frame.size.width, containerView_.bounds.size.height );
                    }
                }
                else if( indexPath.row == 1 ) {
                    displayView_.cornerStyle = kCornerStyleRound;
                    textImageView_.hidden = YES;
                    textView_.hidden = NO;
                    containerView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                    categoryView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                    for( UICollectionView *v in containerView_.subviews ) {
                        v.frame = CGRectMake( v.frame.origin.x, v.frame.origin.y, v.frame.size.width, containerView_.bounds.size.height - 48.0f );
                    }
                    [textView_ becomeFirstResponder];
                }
                else {
                    displayView_.cornerStyle = kCornerStyleRound;
                    textImageView_.hidden = NO;
                    textImageView_.image = cell.image;
                    textView_.hidden = YES;
                    containerView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                    categoryView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                    for( UICollectionView *v in containerView_.subviews ) {
                        v.frame = CGRectMake( v.frame.origin.x, v.frame.origin.y, v.frame.size.width, containerView_.bounds.size.height - 48.0f );
                    }
                }
                break;
            case 11:
                if( indexPath.row == 0 ) {
                    displayView_.hairImage = nil;
                }
                else {
                    displayView_.hairImage = cell.image;
                }
                break;
            default:
                break;
        }
        }else if(gender==2)
        {
            
            switch( collectionView.tag ) {
                case 1:
                    displayView_.bodyImage = cell.image;
                    break;
                case 2:
                    displayView_.hairImage=cell.image;
                    break;
                case 3:
                    displayView_.browImage = cell.image;
                    break;
                case 4:
                    displayView_.eyeImage = cell.image;
                    break;
                case 5:
                    displayView_.mouseImage = cell.image;
                    break;
                case 6:
                    displayView_.handImage = cell.image;
                    break;
                case 7:
                    if( indexPath.row == 0 ) {
                        displayView_.expressionImage = nil;
                    }
                    else {
                        displayView_.expressionImage = cell.image;
                    }
                    break;
                case 8:
                    if( indexPath.row == 0 ) {
                        displayView_.glassesImage = nil;
                    }
                    else {
                        displayView_.glassesImage = cell.image;
                    }
                    break;
                case 9:
                    if( indexPath.row == 0 ) {
                        displayView_.itemImage = nil;
                    }
                    else {
                        displayView_.itemImage = cell.image;
                    }
                    break;
                case 10:
                    if( indexPath.row == 0 ) {
                        displayView_.backgroundImage = nil;
                    }
                    else {
                        displayView_.backgroundImage = cell.image;
                    }
                    break;
                case 11:
                    if( indexPath.row == 0 ) {
                        displayView_.transform = CGAffineTransformMakeScale( 1.0f, 1.0f );
                        displayView_.cornerStyle = kCornerStyleNone;
                        textImageView_.hidden = YES;
                        textView_.hidden = YES;
                        containerView_.transform = CGAffineTransformIdentity;
                        categoryView_.transform = CGAffineTransformIdentity;
                        displayView_.transform = CGAffineTransformIdentity;
                        textView_.transform = CGAffineTransformIdentity;
                        textImageView_.transform = CGAffineTransformIdentity;
                        for( UICollectionView *v in containerView_.subviews ) {
                            v.frame = CGRectMake( v.frame.origin.x, v.frame.origin.y, v.frame.size.width, containerView_.bounds.size.height );
                        }
                    }
                    else if( indexPath.row == 1 ) {
                        displayView_.cornerStyle = kCornerStyleRound;
                        textImageView_.hidden = YES;
                        textView_.hidden = NO;
                        containerView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                        categoryView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                        for( UICollectionView *v in containerView_.subviews ) {
                            v.frame = CGRectMake( v.frame.origin.x, v.frame.origin.y, v.frame.size.width, containerView_.bounds.size.height - 48.0f );
                        }
                        [textView_ becomeFirstResponder];
                    }
                    else {
                        displayView_.cornerStyle = kCornerStyleRound;
                        textImageView_.hidden = NO;
                        textImageView_.image = cell.image;
                        textView_.hidden = YES;
                        containerView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                        categoryView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                        for( UICollectionView *v in containerView_.subviews ) {
                            v.frame = CGRectMake( v.frame.origin.x, v.frame.origin.y, v.frame.size.width, containerView_.bounds.size.height - 48.0f );
                        }
                    }
                    break;
                    
                default:
                    break;
            }
            
        }
        else if(gender==3)
        {
            switch( collectionView.tag ) {
                case 1:
                    displayView_.bodyImage = cell.image;
                    break;
                case 2:
                    displayView_.earImage=cell.image;
                    break;
                case 3:
                    displayView_.browImage = cell.image;
                    break;
                case 4:
                    displayView_.eyeImage = cell.image;
                    break;
                case 5:
                    displayView_.mouseImage = cell.image;
                    break;
                case 6:
                    displayView_.handImage = cell.image;
                    break;
//                case 6:
//                    if( indexPath.row == 0 ) {
//                        displayView_.expressionImage = nil;
//                    }
//                    else {
//                        displayView_.expressionImage = cell.image;
//                    }
//                    break;
                case 7:
                    if( indexPath.row == 0 ) {
                        displayView_.glassesImage = nil;
                    }
                    else {
                        displayView_.glassesImage = cell.image;
                    }
                    break;
                case 8:
                    if( indexPath.row == 0 ) {
                        displayView_.itemImage = nil;
                    }
                    else {
                        displayView_.itemImage = cell.image;
                    }
                    break;
                case 9:
                    if( indexPath.row == 0 ) {
                        displayView_.backgroundImage = nil;
                    }
                    else {
                        displayView_.backgroundImage = cell.image;
                    }
                    break;
                case 10:
                    if( indexPath.row == 0 ) {
                        displayView_.transform = CGAffineTransformMakeScale( 1.0f, 1.0f );
                        displayView_.cornerStyle = kCornerStyleNone;
                        textImageView_.hidden = YES;
                        textView_.hidden = YES;
                        containerView_.transform = CGAffineTransformIdentity;
                        categoryView_.transform = CGAffineTransformIdentity;
                        displayView_.transform = CGAffineTransformIdentity;
                        textView_.transform = CGAffineTransformIdentity;
                        textImageView_.transform = CGAffineTransformIdentity;
                        for( UICollectionView *v in containerView_.subviews ) {
                            v.frame = CGRectMake( v.frame.origin.x, v.frame.origin.y, v.frame.size.width, containerView_.bounds.size.height );
                        }
                    }
                    else if( indexPath.row == 1 ) {
                        displayView_.cornerStyle = kCornerStyleRound;
                        textImageView_.hidden = YES;
                        textView_.hidden = NO;
                        containerView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                        categoryView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                        for( UICollectionView *v in containerView_.subviews ) {
                            v.frame = CGRectMake( v.frame.origin.x, v.frame.origin.y, v.frame.size.width, containerView_.bounds.size.height - 48.0f );
                        }
                        [textView_ becomeFirstResponder];
                    }
                    else {
                        displayView_.cornerStyle = kCornerStyleRound;
                        textImageView_.hidden = NO;
                        textImageView_.image = cell.image;
                        textView_.hidden = YES;
                        containerView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                        categoryView_.transform = CGAffineTransformMakeTranslation( 0, 48.0f );
                        for( UICollectionView *v in containerView_.subviews ) {
                            v.frame = CGRectMake( v.frame.origin.x, v.frame.origin.y, v.frame.size.width, containerView_.bounds.size.height - 48.0f );
                        }
                    }
                    break;
                case 11:
                    if( indexPath.row == 0 ) {
                        displayView_.hairImage = nil;
                    }
                    else {
                        displayView_.hairImage = cell.image;
                    }
                    break;
                default:
                    break;
            }

        }
        [displayView_ updateView];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if( [collectionView isEqual:categoryView_] ) {
        return categoryCount;
    }
    else {
        if (gender==2) {// 女的
            switch( collectionView.tag ) {
                case 1://body
                    return 11;
                case 2: //hair
                    return 22;
                case 3:// brow
                    return 10;
                case 4:// eye
                    return 23;
                case 5:// mouse
                    return 28;
                case 6://hand
                    return 31;
                case 7:// expression
                    return 6 + 1;
                case 8:// glasses
                    return 8 + 1;
                case 9://item
                    return 8 + 1;
                case 10://background
                    return 32 + 1;
                case 11://text
                    return 86 + 2;
                default:
                    break;
            }
 
        }else if(gender==1){ //男的
        switch( collectionView.tag ) {
            case 1://body
                return 30;
            case 2:// brow
                return 11;
            case 3:// eye
                return 31;
            case 4:// mouse
                return 31;
            case 5://hand
                return 38;
            case 6:// expression
                return 10 + 1;
            case 7:// glasses
                return 8 + 1;
            case 8://item
                return 17 + 1;
            case 9://background
                return 32 + 1;
            case 10://text
                return 86 + 2;
            default:
                break;
        }
        }else if (gender==3)
        {
            switch( collectionView.tag ) {
                case 1://body
                    return 31;
                case 3:// brow
                    return 9;
                case 4:// eye
                    return 27;
                case 5:// mouse
                     return 38;
                case 6://hand
                   return 24;
             //   case 6:// expression
             //       return 24+ 1;
                case 7:// glasses
                    return 11 + 1;
                case 8://item
                    return 16 + 1;
                case 9://background
                    return 32 + 1;
                case 10://text
                    return 86 + 2;
                case 2: //ear
                    return 10;
                default:
                    break;
            }
        }
        return 0;
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString* gLabel=[self getGenderLabel ];
    //NSLog(@"___%@" ,gLabel);
    if([collectionView isEqual:categoryView_])
    {


    }else{
        NSLog(@"___%@ __%d__%d" ,gLabel,collectionView.tag,indexPath.row);
    }
    if( [collectionView isEqual:categoryView_] ) {

        
        CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CATEGORY_CELL_IDENTIFIER forIndexPath:indexPath];
//        NSLog(@"%d",indexPath.row);
        cell.tag = indexPath.row+1 ;//[self indexToTag: indexPath.row + 1];
        
        if(gender==1){
            NSArray *maleData = @[@"衣服",@"眉毛",@"眼睛",@"嘴巴",@"动作",@"脸色",@"眼镜",@"道具",@"背景",@"文字"];
            
            cell.titleLabel.text = maleData[indexPath.row];

        /*switch( indexPath.row ) {
            case 0:
                cell.titleLabel.text = @"衣服";
                break;
            case 1:
                cell.titleLabel.text = @"眉毛";
                break;
            case 2:
                cell.titleLabel.text = @"眼睛";
                break;
            case 3:
                cell.titleLabel.text = @"嘴巴";
                break;
            case 4:
                cell.titleLabel.text = @"动作";
                break;
            case 5:
                cell.titleLabel.text = @"脸色";
                break;
            case 6:
                cell.titleLabel.text = @"眼镜";
                break;
            case 7:
                cell.titleLabel.text = @"道具";
                break;
            case 8:
                cell.titleLabel.text = @"背景";
                break;
            case 9:
                cell.titleLabel.text = @"文字";
                break;
            default:
                cell.titleLabel.text = @"其他";
                break;
        }*/
        }else if(gender==2)
        {
            NSArray *femaleData = @[@"衣服",@"发型",@"眉毛",@"眼睛",@"嘴巴",@"动作",@"脸色",@"眼镜",@"道具",@"背景",@"文字"];
            
            cell.titleLabel.text = femaleData[indexPath.row];
            
            /*switch( indexPath.row ) {
                case 0:
                    cell.titleLabel.text = @"衣服";
                    break;
                case 1:
                    cell.titleLabel.text = @"发型";
                    break;
                case 2:
                    cell.titleLabel.text = @"眉毛";
                    break;
                case 3:
                    cell.titleLabel.text = @"眼睛";
                    break;
                case 4:
                    cell.titleLabel.text = @"嘴巴";
                    break;
                case 5:
                    cell.titleLabel.text = @"动作";
                    break;
                case 6:
                    cell.titleLabel.text = @"脸色";
                    break;
                case 7:
                    cell.titleLabel.text = @"眼镜";
                    break;
                case 8:
                    cell.titleLabel.text = @"道具";
                    break;
                case 9:
                    cell.titleLabel.text = @"背景";
                    break;
                case 10:
                    cell.titleLabel.text = @"文字";
                    break;
                default:
                    cell.titleLabel.text = @"其他";
                    cell.tag=11;
                    break;
            }*/
        }else if(gender==3)
        {
            NSArray *dogData = @[@"衣服",@"耳朵",@"眉毛",@"眼睛",@"嘴巴",@"动作",@"眼镜",@"道具",@"背景",@"文字"];
            
            cell.titleLabel.text = dogData[indexPath.row];
            
            /*switch( indexPath.row ) {
                case 0:
                    cell.titleLabel.text = @"衣服";
                    break;
                case 1:
                    cell.titleLabel.text = @"耳朵";
                    break;
                case 2:
                    cell.titleLabel.text = @"眉毛";
                    break;
                case 3:
                    cell.titleLabel.text = @"眼睛";
                    break;
                case 4:
                    cell.titleLabel.text = @"嘴巴";
                    break;
                case 5:
                    cell.titleLabel.text = @"动作";
                    break;
                case 6:
                    cell.titleLabel.text = @"眼镜";
                    break;
                case 7:
                    cell.titleLabel.text = @"道具";
                    break;
                case 8:
                    cell.titleLabel.text = @"背景";
                    break;
                case 9:
                    cell.titleLabel.text = @"文字";
                    break;
                default:
                    cell.titleLabel.text = @"其他";
                    break;
            }*/
        }
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"category_bg@2x" ofType:@"png"]]];
        UIImage *selectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"category%d@2x", (int)indexPath.row+1] ofType:@"png"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedImage];
        return cell;
    }
    else if(collectionView.tag>=1 && collectionView.tag<=12)
    {
        NSString* resName=nil;
        int _tag=[collectionView tag]; //collectionView.tag;
        
        if(gender==1)
        {
            switch (_tag) {
                case 1:
                    resName=[NSString stringWithFormat:@"%@_body%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 2:
                    resName =[NSString stringWithFormat:@"%@_brow%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 3:
                    resName =[NSString stringWithFormat:@"%@_eye%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 4:
                    resName =[NSString stringWithFormat:@"%@_mouse%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 5:
                    resName =[NSString stringWithFormat:@"%@_hand%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 6:
                    resName =[NSString stringWithFormat:@"%@_expression%d@2x",gLabel ,(int)indexPath.row];
                    break;
                case 7:
                    resName =[NSString stringWithFormat:@"%@_glasses%d@2x",gLabel ,(int)indexPath.row];
                    break;
                case 8:
                    resName =[NSString stringWithFormat:@"%@_item%d@2x",gLabel ,(int)indexPath.row];
                    break;
                case 9:
                    resName =[NSString stringWithFormat:@"background%d@2x",(int)indexPath.row];
                    break;
                case 10:
                    resName =[NSString stringWithFormat:@"text%d@2x",(int)indexPath.row - 1];
                    break;
                default:
                    break;
            }
            ContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER forIndexPath:indexPath];
            if(_tag==6||_tag==7||_tag==8||_tag==9||_tag==10)
            {
                if( indexPath.row == 0 ) {
                    cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"none@2x" ofType:@"png"]];
                }else if(indexPath.row==1 && _tag==10)
                {
                    cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pen@2x" ofType:@"png"]];
                }else{
                    [cell setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resName ofType:@"png"]] ];
                }
            }else{
                if(_tag==1)
                    [cell setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resName ofType:@"png" ]] resize:YES];
                else
                    [cell setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resName ofType:@"png"]] ];
        
            }
            cell.backgroundColor = [UIColor whiteColor];
            
//            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//            
//            [categoryView_ selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            return cell;
        }else if(gender==2)
        {
            switch (_tag) {
                case 1:
                    resName=[NSString stringWithFormat:@"%@_body%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 2:
                    resName =[NSString stringWithFormat:@"%@_hair%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 3:
                    resName =[NSString stringWithFormat:@"%@_brow%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 4:
                    resName =[NSString stringWithFormat:@"%@_eye%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 5:
                    resName =[NSString stringWithFormat:@"%@_mouse%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                    
                case 6:
                    resName =[NSString stringWithFormat:@"%@_hand%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 7:
                    resName=[NSString stringWithFormat:@"%@_expression%d@2x",gLabel ,(int)indexPath.row];
                    break;
                case 8:
                    resName =[NSString stringWithFormat:@"%@_glasses%d@2x",gLabel ,(int)indexPath.row];
                    break;
                case 9:
                    resName =[NSString stringWithFormat:@"%@_item%d@2x",gLabel ,(int)indexPath.row];
                    break;
                case 10:
                    resName =[NSString stringWithFormat:@"background%d@2x",(int)indexPath.row];
                    break;
                case 11:
                    resName =[NSString stringWithFormat:@"text%d@2x",(int)indexPath.row-1];
                    break;
                default:
                    break;
            }
            NSLog(@"__ttttag:%d resName:%@" ,_tag,resName);
            ContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER forIndexPath:indexPath];
            if(_tag==7||_tag==11||_tag==8||_tag==9||_tag==10)
            {
                if( indexPath.row == 0 ) {
                    cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"none@2x" ofType:@"png"]];
                }else if(indexPath.row==1 && _tag==11)
                {
                    cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pen@2x" ofType:@"png"]];
                }else{
                    [cell setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resName ofType:@"png"]] ];
                }
            }else{
//                if(_tag==1 ||  _tag==6)
                if(_tag == 1)
                    [cell setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resName ofType:@"png"]] resize:YES];
                else
                    [cell setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resName ofType:@"png"]]];
            }
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
       
        else if(gender==3)
        {
            switch (_tag) {
                case 1:
                    resName=[NSString stringWithFormat:@"%@_body%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 2:
                    resName =[NSString stringWithFormat:@"%@_ear%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 3:
                    resName =[NSString stringWithFormat:@"%@_brow%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 4:
                    resName =[NSString stringWithFormat:@"%@_eye%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 5:
                    resName =[NSString stringWithFormat:@"%@_mouse%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
        
                case 6:
                    resName =[NSString stringWithFormat:@"%@_hand%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
               
                case 7:
                    resName =[NSString stringWithFormat:@"%@_glasses%d@2x",gLabel ,(int)indexPath.row+1];
                    break;
                case 8:
                    resName =[NSString stringWithFormat:@"%@_item%d@2x",gLabel ,(int)indexPath.row];
                    break;
                case 9:
                    resName =[NSString stringWithFormat:@"background%d@2x",(int)indexPath.row];
                    break;
                case 10:
                    resName =[NSString stringWithFormat:@"text%d@2x",(int)indexPath.row-1];
                    break;
                default:
                    break;
            }
             NSLog(@"__ttttag:%d resName:%@" ,_tag,resName);
            ContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CONTENT_CELL_IDENTIFIER forIndexPath:indexPath];


            if(_tag==7||_tag==8||_tag==9||_tag==10)
            {
                if( indexPath.row == 0 ) {
                    cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"none@2x" ofType:@"png"]];
                }else if(indexPath.row==1 && _tag==10)
                {
                    cell.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pen@2x" ofType:@"png"]];
                }else{
                    [cell setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resName ofType:@"png"]]];
                }
            }else{
//                if(_tag==1 ||  _tag==6)
                if(_tag==1)
                    [cell setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resName ofType:@"png"]] resize:YES];
                else
                    [cell setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resName ofType:@"png"]]];
            }
            cell.backgroundColor = [UIColor whiteColor];
            
            return cell;
            
        }
        
        return nil;

    }
    else {
        return nil;
    }
}

#pragma mark -- textField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.textColor = [UIColor colorWithRed:114.0f / 255.0f green:51.0f / 255.0f blue:8.0f / 255.0f alpha:1.0f];
    [UIView animateWithDuration:0.5f animations:^{
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        self.view.transform = CGAffineTransformMakeTranslation( 0, -EDIT_MOVE_PIXELS - 568.0f + window.frame.size.height );
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if( [[UIDevice currentDevice].systemVersion hasPrefix:@"6"] ) {
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:textField.text attributes:textAttributes_];
        textField.attributedText = attrStr;
    }
    [UIView animateWithDuration:0.5f animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
