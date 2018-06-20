//
//  NVButton.m
//  NavyUIKit
//
//  Created by Jelly on 6/21/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NVButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Category.h"
#import "Macros.h"


@interface NVButton ()

@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation NVButton


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2.0f;
        self.enabled = YES;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        _layerBackground                = [CALayer layer];
        [self.layer insertSublayer:self.layerBackground atIndex:0];
        self.layerBackground.masksToBounds  = YES;
        self.layerBackground.cornerRadius   = 2.0f;

        self.disableColor                   = COLOR_HM_LIGHT_GRAY;
    }
    
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.layerBackground.frame          = self.bounds;
}

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        borderLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _borderLayer = borderLayer;
        [self.layer addSublayer:_borderLayer];
    }
    
    return _borderLayer;
}

- (void)refreshBorderLayerStyle {
    //    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
    self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    self.borderLayer.lineWidth = self.dashWidth ? self.dashWidth : 2;
    int dashPattern = self.dashSpaceWidth ? self.dashSpaceWidth : 4;
    self.borderLayer.lineDashPattern = @[@(dashPattern), @(dashPattern)];
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    self.borderLayer.fillColor = [UIColor clearColor].CGColor;
    self.borderLayer.strokeColor = self.dashColor.CGColor;
}

- (void) setButtonStyle:(NVButtonStyle)buttonStyle {
    _buttonStyle = buttonStyle;
    
    switch (_buttonStyle) {
        case NVButtonStyleFilled:
            [self.layerBackground setBackgroundColor:self.normalColor.CGColor];
            break;
            
        case NVButtonStyleBorder:
            self.layerBackground.backgroundColor        = [UIColor colorWithWhite:1.0f alpha:0.2f].CGColor;
            self.layerBackground.borderColor            = self.normalColor.CGColor;
            self.layerBackground.borderWidth            = 1.0f;
            self.layerBackground.cornerRadius           = 2.0f;
            self.layerBackground.masksToBounds          = YES;
            break;
        case NVButtonStyleDash:
        {
            [self refreshBorderLayerStyle];
        }
            break;
        default:
            break;
    }

}


- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        
        if (self.buttonStyle == NVButtonStyleFilled) {
            UIColor* color = [UIColor colorRGBonvertToHSB:self.normalColor withBrighnessDelta:-0.1f];
            [self.layerBackground setBackgroundColor:color.CGColor];
            
        } else if (self.buttonStyle == NVButtonStyleBorder) {
            UIColor* color = [UIColor colorRGBonvertToHSB:[UIColor colorWithWhite:1.0f alpha:0.2f] withBrighnessDelta:-0.2f];
            [self.layerBackground setBackgroundColor:color.CGColor];
            
        }
    } else {
        if (self.buttonStyle == NVButtonStyleFilled) {
            [self.layerBackground setBackgroundColor:self.normalColor.CGColor];
            
        } else if (self.buttonStyle == NVButtonStyleBorder) {
            [self.layerBackground setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor];
            
        }
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setTitleHighlightedColor:(UIColor *)titleHighlightedColor {
    _titleHighlightedColor = titleHighlightedColor;
    [self setTitleColor:_titleHighlightedColor forState:UIControlStateHighlighted];
}

- (void) setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (enabled) {
        self.buttonStyle = _buttonStyle;
    } else {
        if (self.buttonStyle == NVButtonStyleFilled) {
            [self.layerBackground setBackgroundColor:self.disableColor.CGColor];
            
        } else {
            [self.layerBackground setBackgroundColor:[UIColor clearColor].CGColor];
            
        }
        
    }
    
}


@end
