//
//  HYWebBrowserViewController.m
//  Haiyinhui
//
//  Created by Jelly on 7/15/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NVWebBrowserViewController.h"
#import "NVUrlHelper.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIImage+Category.h"
#import <WebKit/WebKit.h>
#import "NVStorageManager+Category.h"
#import "NVH5Comunicator.h"
#import "UIColor+Category.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define COLOR_HYH_RED                       [UIColor colorWithRed:227.0f/255.0f green:100.0f/255.0f blue:102.0f/255.0f alpha:1.0f]
#define COLOR_HYH_BLUE                      [UIColor colorWithRed:65.0f/255.0f green:155.0f/255.0f blue:240.0f/255.0f alpha:1.0f]

NSString* const kNotificationWebViewControllerWillClosed = @"kNotificationWebViewControllerWillClosed";

@implementation NVWebBrowserConfig


@end

@interface NVWebBrowserViewController ()
<UIWebViewDelegate,
WKNavigationDelegate,
WKScriptMessageHandler,
WKUIDelegate,
NVWebViewDelegate,
UIScrollViewDelegate
>

/**
 App Schema调整监听。H5调用执行原生的服务。
 */
@property (nonatomic, weak) NVAppSchemaObserver*  _Nullable appSchemaObserver;
@property (nonatomic, weak) NVJavaScriptObserver* _Nullable javaScriptObserver DEPRECATED("也不用了");

/**
 第一次load页面的时候，增加MBProgressHUD来表示正在加载中，优化用户体验
 */
@property (nonatomic, assign) BOOL shouldShowingFirstLoadHtmlHUD;
/**
 请求头嵌入参数
 */
@property (nonatomic, strong) NSDictionary *postParams DEPRECATED("只有UIWebView才支持，webkit不支持");

- (void) onClose:(id)sender;
@end


static NSString* JSHandler;

@implementation NVWebBrowserViewController

#pragma mark - 生命周期

+ (void) initialize {
    NSString* path      = [[NSBundle mainBundle] pathForResource:@"NavyResource" ofType:@"bundle"];
    if (path == nil) {
        NSLog(@"WARNING: 找不到Bundle");
        return;
    }
    NSBundle* bundle    = [NSBundle bundleWithPath:path];
    JSHandler = [NSString stringWithContentsOfURL:[bundle URLForResource:@"ajax_handler" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil];
    
}

- (instancetype)initWithRequestParams:(NSDictionary *) params {
    self = [super init];
    if (self) {
        self.postParams = params;
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *) urlString
{
    return [self initWithURLString:urlString title:nil];
}

- (instancetype)initWithURLString:(NSString *) urlString title:(NSString *) title
{
    self = [super init];
    if (self) {
        self.urlPath        = urlString;
        self.defaultTitle   = title;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGFloat delta = 64.0f;
    self.nvWebView      = [[NVWebView alloc] initWithFrame:CGRectMake(0.0f,
                                                                      0,
                                                                      self.view.width,
                                                                      self.view.height-delta)];
    
    if (self.config != nil) {
        if (self.config.useCustomNavigationBar) {
            if (self.config.navigationBarIsTransparent) {
                self.nvWebView.height = self.view.height;
            } else {
                self.nvWebView.top = self.pageNavigationBar.height;
                self.nvWebView.height = self.view.height - self.pageNavigationBar.height;
            }
        } else {
            self.nvWebView.height = self.view.height - delta;
        }
    }

    self.nvWebView.uiWebViewDelegate = self;
    self.nvWebView.wkUIDelegate = self;
    self.nvWebView.wkNavigationDelegate = self;
    self.nvWebView.delegate = self;
//    self.nvWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.nvWebView.wkWebView.scrollView.delegate = self;
    [self.view addSubview:self.nvWebView];

    self.javaScriptObserver = [NVJavaScriptObserver sharedInstance];
    self.appSchemaObserver  = [NVAppSchemaObserver sharedInstance];
    
    if (self.urlPath != nil ) {
        self.urlPath = [self.urlPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self doRequestWithUserAndToken];
    } else if (self.loadHTMLString != nil) {
        [self.nvWebView loadHTMLString:self.loadHTMLString baseURL:self.baseURL];
    }
    
    if (self.defaultTitle.length > 0) {
        self.title = self.defaultTitle;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(webviewNeedExecJavaScriptBussiness:)
                                                 name:@"kNotificationWebViewNeedExecJavaScript"
                                               object:nil];
    
    self.shouldShowingFirstLoadHtmlHUD = YES;
    if (self.shouldShowingFirstLoadHtmlHUD) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.config!=nil && self.config.useCustomNavigationBar) {
        self.pageNavigationBar.leftButton.hidden = YES;
        [self decorateBackButtonNavigationBar:self.navigationController.navigationBar];
        [self scrollViewDidScroll:self.nvWebView.wkWebView.scrollView];
        
        if (self.config.navigationBarHidden) {
            self.pageNavigationBar.hidden = YES;
        }
        
        if (self.config.navigationBarTitleLabelHidden) {
            self.pageNavigationBar.titleLabel.hidden = YES;
        }
    }
    if (self.preventBack) {
        [self hideBackItem];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DLog(@"WebView---viewWillDisappear");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.nvWebView.uiWebViewDelegate = nil;
    self.nvWebView.wkUIDelegate = nil;
    self.nvWebView.wkNavigationDelegate = nil;
    self.nvWebView.delegate = nil;
    self.nvWebView.wkWebView.scrollView.delegate = nil;
    
    DLog(@"NVWebBrowserViewController销毁成功");
}

- (void)webviewNeedExecJavaScriptBussiness:(NSNotification *) notification {
    NSDictionary *userObject = notification.object;
    if (userObject && userObject.count) {
        NSString *webViewBussiness = [userObject nvObjectForKey:@"webview_bussiness"];
        
        if ([webViewBussiness isEqualToString:@"kWebViewBussiness_BankCardScanSuccess"] ||
            [webViewBussiness isEqualToString:@"kWebViewBussiness_IDCardScanSuccess"]) {
            NSString *js_func = [userObject nvObjectForKey:@"js_function"];
            NSString *json_str = [userObject nvObjectForKey:@"result_json"];
            if (js_func.length >0 &&
                json_str.length >0) {
                NSString *js = [NSString stringWithFormat:@"%@(%@)", js_func, json_str];
                [self.nvWebView evaluateJavaScript:js completionHandler:^(id result, NSError *error) {
                    
                }];
            }
        }
    }
}

#pragma mark - NavigationBarColors

- (BOOL)getCustomNavigationBar {
    if (self.config != nil && self.config.useCustomNavigationBar) {
        return YES;
    }
    return [super getCustomNavigationBar];
}

- (UIColor *)getNavigationBarBackgroundColor {
    if (self.config != nil && self.config.navigationBarBackgroundColor != nil) {
        return self.config.navigationBarBackgroundColor;
    }
    return [super getNavigationBarBackgroundColor];
}

- (BOOL)getStatusBarIsLight {
    if (self.config != nil) {
        return self.config.isStatusBarLight;
    }
    return [super getStatusBarIsLight];
}

- (UIColor *)getNavigationTitleColor {
    if (self.config != nil && self.config.navigationBarTitleColor != nil) {
        return self.config.navigationBarTitleColor;
    }
    return [super getNavigationTitleColor];
}

#pragma mark - 私有方法

- (void) closeFirstLoadingHUD {
    if (self.shouldShowingFirstLoadHtmlHUD) {
        self.shouldShowingFirstLoadHtmlHUD = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void) addRefreshButton {
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    refreshButton.frame = CGRectMake(0, 0, 100, 60);
    [refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshButton];
}

- (void) addRefreshItem {
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(refreshWebView)];
    [refreshItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = refreshItem;
}

- (void) refreshWebView {
//    [self cleanAllCache];
    [self.nvWebView reload];
}

- (void) cleanAllCache {
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void) decorateBackButtonNavigationBar:(UINavigationBar *)navigationBar {
    
    if ([self.navigationController.viewControllers count] > 1) {
        UIColor *btnNormalColor = self.backBtnColor ? self.backBtnColor : [UIColor whiteColor];
        UIColor *btnHightlightColor = self.backBtnHighlightColor ? self.backBtnHighlightColor : [UIColor grayColor];
        if (self.config != nil && self.config.navigationItemsTintColor != nil) {
            btnNormalColor = self.config.navigationItemsTintColor;
            btnHightlightColor = [self.config.navigationItemsTintColor convertToHSBwithBrighnessDelta:0.1f];
        }
        
        UIImage *backButtonImage = [UIImage imageNamed:@"icon_back.png"];
        UIImage *btnNormalImage = [backButtonImage imageWithColor:btnNormalColor];
        UIImage *btnHignlightImage = [backButtonImage imageWithColor:btnHightlightColor];
        
        if (![self.nvWebView canGoBack]) {
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.0f, 0.0f, 60.0f, 30.0f);
            btn.tag = 1001;
            
            [btn.titleLabel setFont:nvNormalFontWithSize(18.0f)];
            [btn setTitle:@"  " forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_HYH_RED forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            
            [btn setImage:btnNormalImage forState:UIControlStateNormal];
            [btn setImage:btnHignlightImage forState:UIControlStateHighlighted];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0f, -30.0f, 0.0f, 0.0f)];
            
            [btn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.config!=nil && self.config.useCustomNavigationBar) {
                [[self.pageNavigationBar viewWithTag:1001] removeFromSuperview];
                [[self.pageNavigationBar viewWithTag:1002] removeFromSuperview];
                
                btn.top = STATUS_BAR_DEFAULT_HEIGHT + (self.pageNavigationBar.height - STATUS_BAR_DEFAULT_HEIGHT - btn.height)/2;
                btn.left = NVNavigationBarButtonDistanceToEdge;
                [self.pageNavigationBar addSubview:btn];
                
                if (self.config != nil && self.config.backBtnHidden) {
                    btn.hidden = YES;
                } else {
                    btn.hidden = NO;
                }
            } else {
                UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
                self.navigationItem.leftBarButtonItem = backItem;
            }
        } else {
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
            btn.tag = 1001;
            
            [btn setImage:btnNormalImage forState:UIControlStateNormal];
            [btn setImage:btnHignlightImage forState:UIControlStateHighlighted];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0f, -30.0f, 0.0f, 0.0f)];
            
            [btn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImage *btnCloseImageSRC = [UIImage imageNamed:@"icon_close.png"];
            UIImage *btnCloseImage = [btnCloseImageSRC imageWithColor:btnNormalColor];
            UIImage *btnCloseHighlightImage = [btnCloseImageSRC imageWithColor:btnHightlightColor];
            
            UIButton* btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
            btnClose.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
            btnClose.tag = 1002;
            
            [btnClose setImage:btnCloseImage forState:UIControlStateNormal];
            [btnClose setImage:btnCloseHighlightImage forState:UIControlStateHighlighted];
            [btnClose setImageEdgeInsets:UIEdgeInsetsMake(0.0f, -30.0f, 0.0f, 0.0f)];
            
            [btnClose addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.config!=nil && self.config.useCustomNavigationBar) {
                [[self.pageNavigationBar viewWithTag:1001] removeFromSuperview];
                [[self.pageNavigationBar viewWithTag:1002] removeFromSuperview];
                
                btn.top = STATUS_BAR_DEFAULT_HEIGHT + (self.pageNavigationBar.height - STATUS_BAR_DEFAULT_HEIGHT - btn.height)/2;
                btn.left = NVNavigationBarButtonDistanceToEdge;
                
                btnClose.top = btn.top;
                btnClose.left = btn.right + 5.0f;
                
                [self.pageNavigationBar addSubview:btn];
                [self.pageNavigationBar addSubview:btnClose];
                if (self.config != nil && self.config.backBtnHidden) {
                    btn.hidden = YES;
                    btnClose.hidden = YES;
                } else {
                    btn.hidden = NO;
                    btnClose.hidden = NO;
                }
            } else {
                UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
                UIBarButtonItem* closeItem = [[UIBarButtonItem alloc]initWithCustomView:btnClose];
                self.navigationItem.leftBarButtonItems = @[backItem, closeItem];
            }
        }
    }
}

- (NSString*) getNavigationTitle {
    return self.naviTitle ? self.naviTitle : self.title;
}

//- (UIColor*) getNavigationTitleColor {
//    return COLOR_DEFAULT_WHITE;
//}


- (void)setJSObserver: (UIWebView *) webView {
    // JavaScriptCore框架-JS和原生相互调用
    JSContext* context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    if (self.javaScriptObserver != nil
        && [self.javaScriptObserver.observer count] > 0) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L), ^{
            [self.javaScriptObserver.observer enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString* name              = (NSString*)key;
                NVJsObservedObject* object  = (NVJsObservedObject*)obj;
                
                context[object.jsName] = ^() {
                    NSArray* args = [JSContext currentArguments];
                    if (object.invokeBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            object.invokeBlock(name, args, self);
                        });
                    }
                };
            }];
        });
    }
}


- (void) resetRequestWithUserIDToken:(NSMutableURLRequest *) request {
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if (self.postParams && self.postParams.count > 0) {
        [params addEntriesFromDictionary:self.postParams];
    }
    
    NSMutableString* paramsStr = [NSMutableString string];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [paramsStr appendFormat:@"%@=%@&",key,obj];
        }
    }];
    
    NSData* httpData = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
    
    // 用户已登陆有ID和密码，POST提交H5模拟登陆
    if (paramsStr.length > 0) {
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:httpData];
    }
    
}

- (void)doRequestWithUserAndToken {
    __weak NVWebBrowserViewController *weakSelf = self;
    [[NVStorageManager sharedInstance] getUserInfo:^(NVUserDataModel *dataModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dataModel.userId && dataModel.token) {
                weakSelf.urlPath = [[NVH5Comunicator sharedInstance] appendUserInfoWithURL:self.urlPath
                                                                                    userid:dataModel.userId
                                                                                     token:dataModel.token];
            }
            
            NSURL *url = [NSURL URLWithString:weakSelf.urlPath];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setValue:@"iPhone OS" forHTTPHeaderField:@"device"];
            
            [self.nvWebView loadRequest:request];
        });
    } classNameOfUserModel:@"NVUserDataModel"];
}


- (void)hideBackItem {
    UIView *nullView = [[UIView alloc] initWithFrame:CGRectZero];
    UIBarButtonItem *nullItem = [[UIBarButtonItem alloc] initWithCustomView:nullView];
    self.navigationItem.leftBarButtonItem = nullItem;
}

#pragma mark - 公开方法

- (void)reload {
    [self.nvWebView reload];
}

- (void) reloadUrl:(NSString*)url {
    if (url != nil) {
        self.urlPath = url;
        [self doRequestWithUserAndToken];
    }
}

- (void)loadHTMLString:(nullable NSString *)string baseURL:(nullable NSURL *)baseURL {
    [self.nvWebView loadHTMLString:string baseURL:baseURL];
}

- (void) backButtonAction:(id)sender {
    BOOL canGoBack = [self.nvWebView canGoBack];
    if (canGoBack) {
        [self.nvWebView goBack];
        [self decorateBackButtonNavigationBar:self.navigationController.navigationBar];
        [self scrollViewDidScroll:self.nvWebView.wkWebView.scrollView];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWebViewControllerWillClosed
                                                        object:nil];
    [super backButtonAction:sender];
    
}

- (void) onClose:(id)sender {
    [super backButtonAction:nil];
}

#pragma mark - <iOS8 UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.title = self.naviTitle ? self.naviTitle : @"加载中...";
    [webView stringByEvaluatingJavaScriptFromString:JSHandler];
    [self setJSObserver:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"UserAgent = %@", userAgent);
    
    [webView stringByEvaluatingJavaScriptFromString:JSHandler];
    
    NSString* title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([title length] > 0) {
        self.title = title;
    } else if(self.defaultTitle.length > 0){
        self.title = self.defaultTitle;
    } else {
        self.title = @"";
    }
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self setJSObserver:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
#define AJAXSCHEMA      @"navyhandler"
    
    NSURL* url = request.URL;
    
    NSString* scheme        = url.scheme;
//    NSString* host          = url.host;
//    NSString* service       = url.path;
//    NSString* paramStr      = url.query;
    
    if ([[scheme lowercaseString] isEqualToString:AJAXSCHEMA]) {
        //NSString *requestedURLString = [[[request URL] absoluteString] substringFromIndex:[AJAXSCHEMA length] + 3];
        
        NSString* title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if ([title length] > 0) {
            self.title = title;
        }
        return NO;
    }
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked
        || navigationType == UIWebViewNavigationTypeOther) {
        
        if ([self.appSchemaObserver hasAppSchema:scheme]) {
            [[NVAppSchemaObserver sharedInstance] openURL:url];
        
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.config != nil &&
        self.config.useCustomNavigationBar &&
        self.config.navigationBarIsTransparent) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat alptha = offsetY/150.0f;
        self.pageNavigationBar.backgroundColor = [self.config.navigationBarBackgroundColor convertToHSBwithAlpha:alptha];
        
        if (alptha < 0.5 && self.config.navigationItemsTintColorWhenTransparent) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
            self.pageNavigationBar.titleLabel.textColor = self.config.navigationItemsTintColorWhenTransparent;
            [self.pageNavigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    UIButton *btn = obj;
                    [btn setImage:[btn.currentImage imageWithColor:self.config.navigationItemsTintColorWhenTransparent] forState:UIControlStateNormal];
                    [btn setImage:[btn.currentImage imageWithColor:[self.config.navigationItemsTintColorWhenTransparent convertToHSBwithAlphaDelta:-0.1f]] forState:UIControlStateHighlighted];
                }
            }];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
            self.pageNavigationBar.titleLabel.textColor = self.config.navigationBarTitleColor;
            [self.pageNavigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    UIButton *btn = obj;
                    [btn setImage:[btn.currentImage imageWithColor:self.config.navigationItemsTintColor] forState:UIControlStateNormal];
                    [btn setImage:[btn.currentImage imageWithColor:[self.config.navigationItemsTintColor convertToHSBwithAlphaDelta:-0.1f]] forState:UIControlStateHighlighted];
                }
            }];
        }
    }
}

#pragma mark - >=iOS8 标题改变

- (void)webView:(NVWebView *)webView titleChanged:(NSString *)newTitle {
    
    if(self.defaultTitle.length > 0){
        self.title = self.defaultTitle;
    } else if ([newTitle length] > 0) {
        self.title = newTitle;
    } else {
        self.title = @"";
    }
    
    if (self.config != nil && self.config.useCustomNavigationBar) {
        self.pageNavigationBar.titleLabel.text = self.title;
        
    }
    
    //检测标题是否为协议
    NSURL *url = [NSURL URLWithString:self.title];
    NSString* scheme        = url.scheme;
    if ([self.appSchemaObserver hasAppSchema:scheme]) {
        [[NVAppSchemaObserver sharedInstance] openURL:url controller:self];
    }
}

#pragma mark - >=iOS8 WKUIDelegate 定制Alert、Prompt、Confirm

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController* alertC = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    prompt = [prompt stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSURL* url = [NSURL URLWithString:prompt];
    NSString* scheme        = url.scheme;
//    NSString* host          = url.host;
//    NSString* service       = url.path;
//    NSString* paramStr      = url.query;
    if (url && [self.appSchemaObserver hasAppSchema:scheme]) {
        id value = [[NVAppSchemaObserver sharedInstance] syncOpenURL:url];
        completionHandler(value);
    }else {
        UIAlertController* alertC = [UIAlertController alertControllerWithTitle:prompt
                                                                        message:@""
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.textColor = [UIColor redColor];
        }];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler([alertC.textFields.lastObject text]);
        }]];
        alertC.textFields.lastObject.text = defaultText;
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController* alertC = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - >=iOS8 WKNavigationDelegate 页面加载过程跟踪
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self closeFirstLoadingHUD];
    // WKWebView 无法获取到 JSContext
    //    JSContext* context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //    NSLog(@"获取到JS上下文，注入JS");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
}

#pragma mark - >=iOS8 WKNavigationDelegate 决定页面是否跳转
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *request = navigationAction.request;
    NSURL* url = request.URL;
    DLog(@"\nWKWebView Go to URL:%@", url);
    
    NSString* scheme        = url.scheme;
//    NSString* host          = url.host;
//    NSString* service       = url.path;
//    NSString* paramStr      = url.query;
    if ([self.appSchemaObserver hasAppSchema:scheme]) {
        [[NVAppSchemaObserver sharedInstance] openURL:url controller:self];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    //小叉检查下是否要展示
    [self decorateBackButtonNavigationBar:self.navigationController.navigationBar];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// https证书验证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLCredential * credential = [[NSURLCredential alloc] initWithTrust:[challenge protectionSpace].serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

#pragma mark - >=iOS8 JS回调OC
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"jsoc1"]) {
        id body = message.body;
        NSLog(@"js调oc:%@", body);
    }
    else if ([message.name isEqualToString:@"jsoc2"]) {
        id body = message.body;
        NSLog(@"js调oc:%@", body);
    }
    else if ([message.name isEqualToString:@"jsoc3"]) {
        id body = message.body;
        NSLog(@"js调oc:%@", body);
    }
}

#pragma mark - >=iOS8 新打开窗口
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    // <a href="http://www.baidu.com/" target="_blank"> a链接新开窗口问题。
    [self.nvWebView loadRequest:navigationAction.request];
  //  return  [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    return nil;
}

@end



