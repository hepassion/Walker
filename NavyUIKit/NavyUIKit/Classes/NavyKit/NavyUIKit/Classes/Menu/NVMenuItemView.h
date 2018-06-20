//
//  NVMenuItemView.h
//  Navy
//
//  Created by Jelly on 6/29/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NVMenuItemView : UIButton
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) UIEdgeInsets textEdgeInsets;
@property (nonatomic, strong) UIColor* normalColor;             //文字颜色
@property (nonatomic, strong) UIColor* selectedColor;           //文字选中颜色
@property (nonatomic, strong) UIColor* disableColor;            //文字置灰颜色
@property (nonatomic, strong) UIColor* normalBackgroundColor;   //背景色
@property (nonatomic, strong) UIColor* selectedBackgroundColor; //选中背景色

@end
