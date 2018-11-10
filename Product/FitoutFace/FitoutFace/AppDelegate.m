//
//  AppDelegate.m
//  FitoutFace
//
//  Created by Yanjie Chen on 6/9/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#import "AppDelegate.h"
#import "MainNavigationController.h"
#import "MainViewController.h"
#import "Constant.h"
#import "TalkingData.h"
#import "WeiboSDK.h"

@implementation AppDelegate

@synthesize weiboToken = weiboToken_;
@synthesize weiboUserId = weiboUserId_;
@synthesize weiboExpireDate = weiboExpireDate_;
@synthesize gender=gender;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TalkingData setExceptionReportEnabled:YES];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[WeiboSDK registerApp:WEIBO_APPKEY];
    [WXApi registerApp:WEIXIN_APPKEY];
    weiboToken_ = nil;
    weiboUserId_ = nil;
    weiboExpireDate_ = nil;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MainViewController *rootViewController = [[MainViewController alloc] init];
    MainNavigationController *navController = [[MainNavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WEIBO_APPKEY];
    
    [TalkingData sessionStarted:@"8C02457F98FBB8D209931463B8DA5E60" withChannelId:@"iphone"];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog( @"%@", sourceApplication );
    if( [sourceApplication isEqualToString:@"com.sina.weibo"] ) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    if( [sourceApplication isEqualToString:@"com.tencent.xin"] ) {
        NSLog( @"wechat" );
        return [WXApi handleOpenURL:url delegate:self];
    }
    else {
        return NO;
    }
}

- (void)onReq:(BaseReq *)req {
    NSLog( @"%@", req );
}

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        NSString *strMsg = @"";
        if( resp.errCode == WXSuccess ) {
            strMsg = @"成功";
        }
        else {
            strMsg = @"失败";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if( [response isKindOfClass:[WBAuthorizeResponse class]] ) {
        WBAuthorizeResponse *resp = (WBAuthorizeResponse*)response;
        if( resp.statusCode == WeiboSDKResponseStatusCodeSuccess ) {
            weiboToken_ = [resp accessToken];
            weiboUserId_ = resp.userID;
            weiboExpireDate_ = resp.expirationDate;
        }
        else {
            weiboToken_ = nil;
            weiboUserId_ = nil;
            weiboExpireDate_ = nil;
        }
    }
    else if( [response isKindOfClass:[WBSendMessageToWeiboResponse class]] ) {
        WBSendMessageToWeiboResponse *stwr =(WBSendMessageToWeiboResponse *)response;
        if (stwr.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            
        }
    }
}

@end
