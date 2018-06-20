//
//  HYWebBrowserViewController.h
//  Haiyinhui
//
//  Created by Jelly on 7/15/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NavyUIKit.h"
#import "NVJavaScriptObserver.h"
#import "NVAppSchemaObserver.h"
#import "NVWebView.h"
#import <DJMacros/DJMacro.h>

UIKIT_EXTERN  NSString* _Nonnull  const kNotificationWebViewControllerWillClosed;

@class NVWebBrowserViewController;

@protocol NVWebBrowserViewControllerDelegate <NSObject>

- (void)respondUrlSchemeWithWebBrowserViewController:(NVWebBrowserViewController * _Nonnull)webBroserViewController;

@end

@interface NVWebBrowserConfig: NSObject

/**
 导航栏透明；YES 则WebView Y轴起始点为 0.0f； NO 则 Y起始点为64.0f
 */
@property (nonatomic, assign) BOOL navigationBarIsTransparent;
@property (nonatomic, assign) BOOL isStatusBarLight;
@property (nonatomic, assign) BOOL backBtnHidden;
@property (nonatomic, assign) BOOL useCustomNavigationBar;
@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, assign) BOOL navigationBarTitleLabelHidden;
@property (nonatomic, strong) UIColor* _Nullable navigationItemsTintColor;
@property (nonatomic, strong) UIColor* _Nullable navigationItemsTintColorWhenTransparent;
@property (nonatomic, strong) UIColor* _Nullable navigationBarBackgroundColor;
@property (nonatomic, strong) UIColor* _Nullable navigationBarTitleColor;

@end

@interface NVWebBrowserViewController : NVGlassMainViewController

@property (nonatomic, strong) NVWebBrowserConfig* _Nullable config;
@property (nonatomic, strong) NVWebView* _Nullable  nvWebView;
@property (nonatomic, assign) id<NVWebBrowserViewControllerDelegate> _Nullable delegate;

/**
 需要访问的URL路径
 */
@property (nonatomic, strong) NSString* _Nullable   urlPath;

/**
 直接读取HTML文本
 */
@property (nonatomic, strong) NSString* _Nullable   loadHTMLString;     //html字符串
@property (nonatomic, strong) NSURL* _Nullable      baseURL;            //html字符串的基础URL

/**
 返回按钮的颜色, 默认为白色，点下是灰色
 */
@property (nonatomic, strong) UIColor* _Nullable    backBtnColor;
@property (nonatomic, strong) UIColor* _Nullable    backBtnHighlightColor;

/**
 默认标题，有默认标题，将不能使用webview中Html的标题
 */
@property (nonatomic, strong) NSString* _Nullable   defaultTitle;

/**
 隐藏返回按钮
 */
@property (nonatomic, assign) BOOL preventBack;

/**
 隐藏返回按钮
 */
- (void)hideBackItem;

/**
 通过一个URL初始化WebView

 @param urlString 访问的URL地址
 @return 实例
 */
- (instancetype _Nullable)initWithURLString:(NSString *_Nullable) urlString;
- (instancetype _Nullable)initWithURLString:(NSString *_Nullable) urlString
                            title:(NSString *_Nullable) title;

- (void) reload;
- (void) reloadUrl:(NSString* _Nullable)url;
- (void) loadHTMLString:(nullable NSString *)string baseURL:(nullable NSURL *)baseURL;

/**
 返回按钮事件，可重写
 
 @param sender button
 */
- (void) backButtonAction:(id)sender;

#pragma mark - DEPRECATED

/**
 导航栏标题，优先级要比系统title高，可以用这个修改导航栏title
 */
@property (nonatomic, copy)   NSString* _Nullable   naviTitle DEPRECATED("统一使用defaultTitle 来设置默认标题");

/**
 *  每次Request重写后，添加Post参数
 *
 *  @return 实例
 */
- (instancetype _Nullable)initWithRequestParams:(NSDictionary * _Nullable) params DEPRECATED("WKWebView不支持Post添加参数，只有UIWebView支持Post增加参数");
@end
