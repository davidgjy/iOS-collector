//
//  ShareView.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/11/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "ShareView.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "TalkingData.h"

@interface ShareView () {
    UIView *bgView_;
}

@end

@implementation ShareView

@synthesize delegate = delegate_;
@synthesize image = image_;

- (id)initWithFrame:(CGRect)frame contentSize:(CGSize)size;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        bgView_ = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, size.width, size.height )];
        bgView_.backgroundColor = [UIColor whiteColor];
        bgView_.center = CGPointMake( frame.size.width / 2, frame.size.height - size.height / 2 );
        [self addSubview:bgView_];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, size.width, 2.0f )];
        line1.backgroundColor = [UIColor colorWithRed:235.0f / 255.0f green:235.0f / 255.0f blue:241.0f / 255.0f alpha:1.0f];
        line1.center = CGPointMake( size.width / 2, 0 );
        [bgView_ addSubview:line1];
        
        UILabel *lbShare = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 100.0f, 50.0f )];
        lbShare.text = @"分享到";
        lbShare.textAlignment = NSTextAlignmentCenter;
        lbShare.textColor = [UIColor blackColor];
        lbShare.center = CGPointMake( frame.size.width / 2, 25.0f );
        [bgView_ addSubview:lbShare];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, size.width, 2.0f )];
        line2.backgroundColor = [UIColor colorWithRed:235.0f / 255.0f green:235.0f / 255.0f blue:241.0f / 255.0f alpha:1.0f];
        line2.center = CGPointMake( size.width / 2,  51.0f );
        [bgView_ addSubview:line2];
        
        UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 40.0f, 40.0f )];
        [btnClose setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"close@2x" ofType:@"png"]] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector( onCloseTouched: ) forControlEvents:UIControlEventTouchUpInside];
        btnClose.center = CGPointMake( size.width - 30.0f, 25.0f );
        [bgView_ addSubview:btnClose];
        
        UIButton *btnWeibo = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 57.0f, 57.0f )];
        [btnWeibo setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"weibo@2x" ofType:@"png"]] forState:UIControlStateNormal];
        [btnWeibo setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"weibo_selected@2x" ofType:@"png"]] forState:UIControlStateSelected];
        [btnWeibo addTarget:self action:@selector( onWeiboTouched: ) forControlEvents:UIControlEventTouchUpInside];
        btnWeibo.center = CGPointMake( size.width * 3 / 4, size.height / 2 );
        [bgView_ addSubview:btnWeibo];
        
        UILabel *lbWeibo = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 80.0f, 40.0f )];
        lbWeibo.text = @"新浪微博";
        lbWeibo.textAlignment = NSTextAlignmentCenter;
        lbWeibo.textColor = [UIColor blackColor];
        lbWeibo.center = CGPointMake( size.width * 3 / 4, size.height / 2 + 50.0f );
        [bgView_ addSubview:lbWeibo];
        
        UIButton *btnWechat = [[UIButton alloc] initWithFrame: CGRectMake( 0, 0, 57.0f, 57.0f )];
        [btnWechat setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wechat@2x" ofType:@"png"]] forState:UIControlStateNormal];
        [btnWechat setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wechat_selected@2x" ofType:@"png"]] forState:UIControlStateSelected];
        [btnWechat addTarget:self action:@selector( onWechatTouched: ) forControlEvents:UIControlEventTouchUpInside];
        btnWechat.center = CGPointMake( size.width / 4, size.height / 2 );
        [bgView_ addSubview:btnWechat];
        
        UILabel *lbWechat = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 80.0f, 40.0f )];
        lbWechat.text = @"微信";
        lbWechat.textAlignment = NSTextAlignmentCenter;
        lbWechat.textColor = [UIColor blackColor];
        lbWechat.center = CGPointMake( size.width / 4, size.height / 2 + 50.0f );
        [bgView_ addSubview:lbWechat];
        
        UIButton *btnMoment = [[UIButton alloc] initWithFrame: CGRectMake( 0, 0, 57.0f, 57.0f )];
        [btnMoment setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"moment@2x" ofType:@"png"]] forState:UIControlStateNormal];
        [btnMoment setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"moment_selected@2x" ofType:@"png"]] forState:UIControlStateSelected];
        [btnMoment addTarget:self action:@selector( onMomentTouched: ) forControlEvents:UIControlEventTouchUpInside];
        btnMoment.center = CGPointMake( size.width / 2, size.height / 2 );
        [bgView_ addSubview:btnMoment];
        
        UILabel *lbMoment = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 80.0f, 40.0f )];
        lbMoment.text = @"朋友圈";
        lbMoment.textAlignment = NSTextAlignmentCenter;
        lbMoment.textColor = [UIColor blackColor];
        lbMoment.center = CGPointMake( size.width / 2, size.height / 2 + 50.0f );
        [bgView_ addSubview:lbMoment];
        
        delegate_ = nil;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector( handleGesture: )];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)onCloseTouched:(id)sender {
    self.hidden = YES;
}

- (void)onWeiboTouched:(id)sender {
    if( delegate_ ) {
        [delegate_ onWeiboTouched];
    }
    [self removeFromSuperview];
    self.hidden = YES;
    AppDelegate *d = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if( d.weiboToken == nil || d.weiboExpireDate == nil || [d.weiboExpireDate compare:[NSDate date]] == NSOrderedAscending ) {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = WEIBO_REDIRECT_URI;
        request.scope = @"all";
        [WeiboSDK sendRequest:request];
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"即将开放" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//    [alert show];
    
    [TalkingData trackEvent:@"微博"];
}

- (void)onMomentTouched:(id)sender {
    if( image_ ) {
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:image_];
        UIImage *thumbImage = nil;
        CGSize size = CGSizeMake( 150.0f, 150.0f / image_.size.width * image_.size.height );
        
        UIGraphicsBeginImageContext( size );
        [image_ drawInRect:CGRectMake( 0, 0, size.width, size.height )];
        thumbImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [message setThumbImage:thumbImage];
        
        WXImageObject *imgobj = [WXImageObject object];
        imgobj.imageData = UIImagePNGRepresentation( image_ );
        message.mediaObject = imgobj;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        
        if( ![WXApi sendReq:req] ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未安装或者还未启动微信哦!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
        }
        else {
            self.hidden = YES;
        }
    }
    [TalkingData trackEvent:@"朋友圈"];
}

- (void)onWechatTouched:(id)sender {
    if( image_ ) {
        UIImage *thumbImage = nil;
        WXMediaMessage *message = [WXMediaMessage message];
        CGSize size = CGSizeMake( 150.0f, 150.0f / image_.size.width * image_.size.height );
        
        UIGraphicsBeginImageContext( size );
        [image_ drawInRect:CGRectMake( 0, 0, size.width, size.height )];
        thumbImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [message setThumbImage:thumbImage];
        
        WXImageObject *imgobj = [WXImageObject object];
        imgobj.imageData = UIImagePNGRepresentation( image_ );
        message.mediaObject = imgobj;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        
        if( ![WXApi sendReq:req] ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未安装或者还未启动微信哦!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
        }
        else {
            self.hidden = YES;
        }
    }
    [TalkingData trackEvent:@"微信"];
}

- (void)handleGesture:(UIGestureRecognizer*)gesture {
    if( !CGRectContainsPoint( bgView_.frame, [gesture locationInView:self] ) ) {
        self.hidden = YES;
    }
}

@end
