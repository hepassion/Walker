//
//  NVGlassMainViewController.m
//  NavyUIKit
//
//  Created by Jelly on 6/17/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NVGlassMainViewController.h"
#import "NavyUIKit.h"
#import "UIImage+Category.h"
#import "UIColor+Category.h"

#define COLOR_HYH_RED                       [UIColor colorWithRed:227.0f/255.0f green:100.0f/255.0f blue:102.0f/255.0f alpha:1.0f]
#define COLOR_HYH_BLUE                      [UIColor colorWithRed:65.0f/255.0f green:155.0f/255.0f blue:240.0f/255.0f alpha:1.0f]

@implementation NVPageNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        STATUS_BAR_DEFAULT_HEIGHT,
                                                                        self.width*0.7,
                                                                        44.0f)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.centerX = self.width/2.0f;
        titleLabel.font = navigationTitleFont();
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        self.titleLabel.centerX = self.width/2.0f;
    }
    return self;
}

- (void)setLeftButton:(UIButton *)leftButton {
    if (_leftButton != leftButton) {
        [_leftButton removeFromSuperview];
        
        _leftButton = leftButton;
        [self addSubview:_leftButton];
        
        //动态设置宽度
        CGFloat textWidth = [_leftButton.titleLabel.text jk_widthWithFont:_leftButton.titleLabel.font constrainedToHeight:_leftButton.height];
        CGFloat width = 0.0f;
        if (_leftButton.currentImage != nil) {
            UIImage *image = _leftButton.currentImage;
            CGFloat heightInPoints = image.size.height;
            CGFloat heightInPixels = heightInPoints * image.scale;
            CGFloat widthInPoints = image.size.width;
            CGFloat widthInPixels = widthInPoints * image.scale;
            
            CGFloat imageWidth = widthInPoints;
            width += imageWidth;
        }
        
        if (leftButton.titleLabel.text.length > 0) {
            width += textWidth;
        }
        
        if (leftButton.titleLabel.text.length > 0 && _leftButton.currentImage != nil) {
            width += NVNavigationBarButtonImageTextSpace;
        }
        
        _leftButton.width = width;
        
        _leftButton.centerY = (self.height-STATUS_BAR_DEFAULT_HEIGHT)/2+STATUS_BAR_DEFAULT_HEIGHT;
        _leftButton.left = NVNavigationBarButtonDistanceToEdge;
        
    }
}

- (void)setRightButton:(UIButton *)rightButton {
    if (_rightButton != rightButton) {
        [_rightButton removeFromSuperview];
        
        _rightButton = rightButton;
        [self addSubview:_rightButton];
        
        //动态设置宽度
        CGFloat textWidth = [_rightButton.titleLabel.text jk_widthWithFont:_rightButton.titleLabel.font constrainedToHeight:_rightButton.height];
        CGFloat width = 0.0f;
        if (_rightButton.currentImage != nil) {
            UIImage *image = _rightButton.currentImage;
            CGFloat heightInPoints = image.size.height;
            CGFloat heightInPixels = heightInPoints * image.scale;
            CGFloat widthInPoints = image.size.width;
            CGFloat widthInPixels = widthInPoints * image.scale;
            
            CGFloat imageWidth = widthInPoints;
            width += imageWidth;
        }
        
        if (rightButton.titleLabel.text.length > 0) {
            width += textWidth;
        }
        
        if (rightButton.titleLabel.text.length > 0 && _rightButton.currentImage != nil) {
            width += NVNavigationBarButtonImageTextSpace;
        }
        
        _rightButton.width = width;
        
        _rightButton.centerY = (self.height-STATUS_BAR_DEFAULT_HEIGHT)/2+STATUS_BAR_DEFAULT_HEIGHT;
        _rightButton.right = self.width - NVNavigationBarButtonDistanceToEdge;
    }
}

@end

@interface NVGlassMainViewController ()
<UIGestureRecognizerDelegate>

@end

@implementation NVGlassMainViewController

#pragma mark - LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //边缘手势
    if ([self getNavigationBarEdgePanBack]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //保证给个控制器导航有固定的样式
    if (![self getCustomNavigationBar]) {
        [self decorateNavigationBar:self.navigationController.navigationBar];
    } else {
        [self decorateCustomNavigationBar:self.pageNavigationBar];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - NavigationBar
- (void) decorateNavigationBar:(UINavigationBar *)navigationBar {
    [self.navigationController setNavigationBarHidden:NO];
    
    if ([self getStatusBarIsLight]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    //preventing weird inset
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    
    //设置左右按钮
    [self decorateBackButtonNavigationBar:navigationBar];
    [self decorateRightButtonNavigationBar:navigationBar];
    
    //设置标题属性
    navigationBar.titleTextAttributes = [self getNavigationTitleTextAttributes];
    
    //设置背景色
    UIColor* colorBackground = [self getNavigationBarBackgroundColor];
    [navigationBar setBackgroundImage:[UIImage imageWithColor:colorBackground] forBarMetrics:UIBarMetricsDefault];
    
    //去除发丝线
    UIImage* image = [[UIImage alloc] init];
    navigationBar.shadowImage = image;
    
    
    self.navigationItem.titleView = nil;
    self.title = [self getNavigationTitle];
}

- (void) decorateBackButtonNavigationBar:(UINavigationBar *)navigationBar {
    
    if ([self getNavigationBarBackButtonDefaultStyle] == NO &&
        [self.navigationController.viewControllers count] > 1) {
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithCustomView:[self newBackButton]];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void) decorateRightButtonNavigationBar:(UINavigationBar *)navigationBar {
    
}

- (void) customedNavigationBar:(UINavigationBar *)navigationBar {
    
}

#pragma mark - CustomNavigationBar
- (NVPageNavigationBar *)pageNavigationBar {
    if (_pageNavigationBar == nil) {
        CGFloat height = NAVIGATION_BAR_DEFAULT_HEIGHT+STATUS_BAR_DEFAULT_HEIGHT;
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        _pageNavigationBar = [[NVPageNavigationBar alloc] initWithFrame:frame];
        [self.view addSubview:_pageNavigationBar];
    }
    
    return _pageNavigationBar;
}

- (void) decorateCustomNavigationBar:(NVPageNavigationBar *) navigationBar {
    [self.navigationController setNavigationBarHidden:YES];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    
    if ([self getStatusBarIsLight]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    navigationBar.backgroundColor = [self getNavigationBarBackgroundColor];
    navigationBar.titleLabel.text = [self getNavigationTitle];
    navigationBar.titleLabel.textColor = [self getNavigationTitleColor];
    
    //左边按钮
    BOOL flag = NO;
    if ([self getCustomNavigationBarLeftButtonImage]!=nil ||
        [self getCustomNavigationBarLeftButtonTitle].length > 0) {
        flag = YES;
        navigationBar.leftButton = [self newLeftButton];
    }
    
    //返回按钮
    if (!flag) {
        if ([self.navigationController.viewControllers count] > 1) {
            UIButton* backBtn = [self newBackButton];
            navigationBar.leftButton = backBtn;
        }
    }
    
    //右边按钮
    if ([self getCustomNavigationBarRightButtonImage] != nil
        || [self getCustomNavigationBarRightButtonTitle].length > 0) {
        UIButton* backBtn = [self newRightButton];
        navigationBar.rightButton = backBtn;
    }
}

#pragma mark - NavigationTitle
- (BOOL) getCustomNavigationBar {
    return NO;
}

- (BOOL) getStatusBarIsLight {
    return NO;
}

- (NSString*) getNavigationTitle {
    return self.title;
}

- (UIColor*) getNavigationTitleColor {
    return [UIColor blackColor];
}

- (NSDictionary*) getNavigationTitleTextAttributes {
    //    NSShadow *shadow = [[NSShadow alloc] init];
    //    [shadow setShadowOffset:CGSizeMake(1, 1)];
    //    [shadow setShadowColor:[UIColor lightGrayColor]];
    //    [shadow setShadowBlurRadius:1];
    
    UIFont* font = navigationTitleFont();
    
    return @{NSForegroundColorAttributeName:[self getNavigationTitleColor], /*NSShadowAttributeName:shadow,*/ NSFontAttributeName:font};
}

- (BOOL) getNavigationBarBackButtonDefaultStyle {
    return NO;
}

- (BOOL) getNavigationBarEdgePanBack {
    return NO;
}

- (UIColor*) getNavigationBarBackButtonColor {
    return COLOR_HYH_BLUE;
}

- (UIColor*) getNavigationBarBackgroundColor {
    
    return COLOR_DEFAULT_WHITE;
}

- (NSString *) getCustomNavigationBarRightButtonTitle {
    return @"";
}

- (UIImage *) getCustomNavigationBarRightButtonImage {
    return nil;
}

- (UIColor *) getCustomNavigationBarRightButtonTintColor {
    return NVNavigationBarButtonDefaultTintColor;
}

- (UIFont *) getCustomNavigationBarRightButtonFont {
    return NVNavigationBarButtonFont;
}

- (NSString *) getCustomNavigationBarLeftButtonTitle {
    return @"";
}

- (UIImage *) getCustomNavigationBarLeftButtonImage {
    return nil;
}

- (UIColor *) getCustomNavigationBarLeftButtonTintColor {
    return NVNavigationBarButtonDefaultTintColor;
}

- (UIFont *) getCustomNavigationBarLeftButtonFont {
    return NVNavigationBarButtonFont;
}

#pragma mark - Private

- (UIButton *) newBackButton {
    UIImage *btnImage = [[UIImage imageNamed:@"icon_back"] imageWithColor:[self getNavigationBarBackButtonColor]];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.0f, 0.0f, 30.0f, 40.0f);
    
    [btn.titleLabel setFont:[self getCustomNavigationBarLeftButtonFont]];
    [btn setTitle:@"    " forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_HYH_RED forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    
    [btn setImage:btnImage forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    
    [btn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton *) newRightButton {
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.0f, 0.0f, 100.0f, 40.0f);
    
    [btn.titleLabel setFont:[self getCustomNavigationBarRightButtonFont]];
    [btn setTitleColor:[self getCustomNavigationBarRightButtonTintColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorRGBonvertToHSB:[self getCustomNavigationBarRightButtonTintColor] withAlphaDelta:NVNavigationBarTintColorDelta] forState:UIControlStateHighlighted];
    [btn setTitle:[self getCustomNavigationBarRightButtonTitle] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    
    UIImage *image = [self getCustomNavigationBarRightButtonImage];
    if (image != nil) {
        if ([self getCustomNavigationBarRightButtonTitle].length > 0) {
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, NVNavigationBarButtonImageTextSpace);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, NVNavigationBarButtonImageTextSpace, 0, 0);
        }
        
        UIImage *btnImage = [image imageWithColor:[self getCustomNavigationBarRightButtonTintColor]];
        UIImage *btnSelectedImage = [image imageWithColor:[UIColor colorRGBonvertToHSB:[self getCustomNavigationBarRightButtonTintColor] withAlphaDelta:NVNavigationBarTintColorDelta]];
        [btn setImage:btnImage forState:UIControlStateNormal];
        [btn setImage:btnSelectedImage forState:UIControlStateHighlighted];
    }
    
    [btn addTarget:self action:@selector(customNavigationBarRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton *) newLeftButton {
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.0f, 0.0f, 100.0f, 40.0f);
    
    [btn.titleLabel setFont:[self getCustomNavigationBarLeftButtonFont]];
    [btn setTitleColor:[self getCustomNavigationBarLeftButtonTintColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorRGBonvertToHSB:[self getCustomNavigationBarLeftButtonTintColor] withAlphaDelta:NVNavigationBarTintColorDelta] forState:UIControlStateHighlighted];
    [btn setTitle:[self getCustomNavigationBarLeftButtonTitle] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    
    UIImage *image = [self getCustomNavigationBarLeftButtonImage];
    if (image != nil) {
        if ([self getCustomNavigationBarLeftButtonTitle].length > 0) {
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, NVNavigationBarButtonImageTextSpace);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, NVNavigationBarButtonImageTextSpace, 0, 0);
        }
        
        UIImage *btnImage = [image imageWithColor:[self getCustomNavigationBarLeftButtonTintColor]];
        UIImage *btnSelectedImage = [image imageWithColor:[UIColor colorRGBonvertToHSB:[self getCustomNavigationBarLeftButtonTintColor] withAlphaDelta:NVNavigationBarTintColorDelta]];
        [btn setImage:btnImage forState:UIControlStateNormal];
        [btn setImage:btnSelectedImage forState:UIControlStateHighlighted];
    }
    
    [btn addTarget:self action:@selector(customNavigationBarLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - Events
- (void) backButtonAction:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) customNavigationBarRightButtonAction:(id)sender {
    
}

- (void) customNavigationBarLeftButtonAction:(id)sender {
    
}

@end
