//
//  UIColor+Category.h
//  NavyUIKit
//
//  Created by Jelly on 6/21/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)
+ (UIColor*) colorRGBonvertToHSB:(UIColor*)color withBrighnessDelta:(CGFloat)delta;
+ (UIColor*) colorRGBonvertToHSB:(UIColor*)color withAlphaDelta:(CGFloat)delta;
+ (UIColor*) colorRGBonvertToHSB:(UIColor*)color withAlpha:(CGFloat)alphaVal;
- (UIColor *) convertToHSBwithBrighnessDelta:(CGFloat)delta;
- (UIColor *) convertToHSBwithAlphaDelta:(CGFloat)delta;
- (UIColor *) convertToHSBwithAlpha:(CGFloat)alphaVal;
@end
