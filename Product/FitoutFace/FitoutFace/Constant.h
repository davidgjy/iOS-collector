//
//  Constant.h
//  FitoutFace
//
//  Created by Yanjie Chen on 6/13/14.
//  Copyright (c) 2014 binpit. All rights reserved.
//

#ifndef FitoutFace_Constant_h
#define FitoutFace_Constant_h

#define WEIBO_APPKEY @"3334767058"
#define WEIBO_REDIRECT_URI @"http://face.fitout.cn"
//#define WEIBO_REDIRECT_URI @"https://api.weibo.com/oauth2/default.html"

#define WEIXIN_APPKEY @"wxce239d4af02e12e7"

#define CONFIG_FILE_NAME @"/config.plist"

#ifdef DEBUG  
#define BPLog(...) NSLog(__VA_ARGS__)
#else
#define BPLog(...)
#endif

#endif
