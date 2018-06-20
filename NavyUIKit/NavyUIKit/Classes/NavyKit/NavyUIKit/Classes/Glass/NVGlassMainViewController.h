//
//  NVGlassMainViewController.h
//  NavyUIKit
//
//  Created by Jelly on 6/17/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVViewController.h"

#define NVNavigationBarButtonImageTextSpace         3.0f
#define NVNavigationBarTintColorDelta               -0.2f
#define NVNavigationBarButtonDistanceToEdge         12.0f
#define NVNavigationBarButtonDefaultTintColor       [UIColor lightGrayColor]
#define NVNavigationBarButtonFont                   nvNormalFontWithSize(17.0f)

@interface NVPageNavigationBar : UIView

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* leftButton;
@property (nonatomic, strong) UIButton* rightButton;

@end

/**
 设置导航栏样式抽象类
 */
@interface NVGlassMainViewController : NVViewController

/**
 自定义导航视图，若使用系统默认的NavigationBar，customNavigationBar则为nil
 */
@property (nonatomic, strong) NVPageNavigationBar* pageNavigationBar;

/**
 是否使用默认导航栏
 默认：NO 使用系统导航
 
 @return NO 使用系统导航；YES 使用自定义导航
 */
- (BOOL) getCustomNavigationBar;

/**
 设置状态栏样式
 
 @return 默认NO：黑色
 */
- (BOOL) getStatusBarIsLight;

/**
 子类设置NavigationBar标题
 
 @return 标题
 */
- (NSString*) getNavigationTitle;

/**
 子类设置NavigationBar标题颜色
 
 @return 颜色
 */
- (UIColor*) getNavigationTitleColor;

/**
 子类设置NavigationBar背景色
 
 @return 背景色
 */
- (UIColor*) getNavigationBarBackgroundColor;

/**
 子类设置NavigationBar标题属性
 
 @return 属性字典
 */
- (NSDictionary*) getNavigationTitleTextAttributes;

/**
 返回按钮采用系统默认，还是自定义图片的返回按钮
 默认：NO 采用自定义图片
 
 @return BOOL
 */
- (BOOL) getNavigationBarBackButtonDefaultStyle;

/**
 边缘返回手势
 默认: NO 关闭
 
 @return YES开启 NO关闭
 */
- (BOOL) getNavigationBarEdgePanBack;

/**
 自定义返回按钮颜色
 
 @return 颜色
 */
- (UIColor*) getNavigationBarBackButtonColor;

/**
 重构NavigationBar。
 1. 装饰NavigationBar Title
 2. 装饰NavigationBar 返回按钮
 3. 装饰NavigationBar 右侧按钮
 
 @param navigationBar 配置导航栏
 */
- (void) decorateNavigationBar:(UINavigationBar*)navigationBar;
- (void) decorateBackButtonNavigationBar:(UINavigationBar*)navigationBar;
- (void) decorateRightButtonNavigationBar:(UINavigationBar*)navigationBar;
- (void) customedNavigationBar:(UINavigationBar *)navigationBar;

/**
 使用自定义NavigationBar，子类可重写
 
 @param navigationBar 自定义NavigationBar
 */
- (void) decorateCustomNavigationBar:(NVPageNavigationBar *) navigationBar;

- (NSString *) getCustomNavigationBarRightButtonTitle;
- (UIImage *) getCustomNavigationBarRightButtonImage;
- (UIColor *) getCustomNavigationBarRightButtonTintColor;
- (UIFont *) getCustomNavigationBarRightButtonFont;

- (NSString *) getCustomNavigationBarLeftButtonTitle;
- (UIImage *) getCustomNavigationBarLeftButtonImage;
- (UIColor *) getCustomNavigationBarLeftButtonTintColor;
- (UIFont *) getCustomNavigationBarLeftButtonFont;

- (void) customNavigationBarRightButtonAction:(id)sender;
- (void) customNavigationBarLeftButtonAction:(id)sender;

/**
 拦截返回按钮点击事件，用于自定义事件操作处理
 
 @param sender UIBarItem
 */
- (void) backButtonAction:(id)sender;

@end
