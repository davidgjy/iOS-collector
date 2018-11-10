//
//  AppDelegate.h
//  FitoutFace
//
//  Created by Yanjie Chen on 6/9/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate, WXApiDelegate> {
    __strong NSString *weiboToken_;
    __strong NSString *weiboUserId_;
    __strong NSDate *weiboExpireDate_;
    int gender;
}

@property (nonatomic, readonly) NSString *weiboToken;
@property (nonatomic, readonly) NSString *weiboUserId;
@property (nonatomic, readonly) NSDate *weiboExpireDate;
@property (strong, nonatomic) UIWindow *window;
@property int gender;
@end
