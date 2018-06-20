//
//  NVJQRCodeView.h
//  NVJQRCode
//
//  Created by myhg on 16/3/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//
/*
 用法：
 UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
 [JQRCodeView creatQRCodeWithURLString:@"http://www.baidu.com" superView:v logoImage:[UIImage imageNamed:@"icon_checkbox_selected"] logoImageSize:CGSizeMake(40, 40) logoImageWithCornerRadius:8];
 [self.view addSubview:v];
 
 [v jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
 [v removeFromSuperview];
 }];
 */

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface NVJQRCodeView : UIView


/**
 *  生成带logo的二维码
 *  二维码和logo都是正方形的
 *  @param urlString     二维码中的链接
 *  @param QRCodeCGRect  二维码的CGRect
 *  @param logoImage     二维码中的logo
 *  @param logoImageSize logo的大小
 *  @param cornerRadius  logo的圆角值大小
 *
 *  @return 生成的二维码
 */
+ (NVJQRCodeView *)creatQRCodeWithURLString:(NSString *)urlString superView:(UIView *)superView logoImage:(UIImage *)logoImage logoImageSize:(CGSize)logoImageSize logoImageWithCornerRadius:(CGFloat)cornerRadius;

/**
 *  读取图片中的二维码
 *
 *  @param image 图片
 *
 *  @return 图片中的二维码数据集合 CIQRCodeFeature对象
 */
+ (NSArray *)readQRCodeFromImage:(UIImage *)image;

/**
 *  截图
 *
 *  @param view 需要截取的视图
 *
 *  @return 截图 图片
 */
+ (UIImage *)screenShotFormView:(UIView *)view;

@end
