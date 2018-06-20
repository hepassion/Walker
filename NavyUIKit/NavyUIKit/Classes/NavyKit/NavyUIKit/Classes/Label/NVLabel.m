//
//  NVLabel.m
//  NavyUIKit
//
//  Created by Jelly on 6/23/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NVLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation NVLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:14.0f]];
        self.verticalAlignment = NVLabelVerticalAlignmentMiddle;
    }
    return self;
}

- (CGFloat) height {
    return self.bounds.size.height;
}

- (CGFloat) width {
    return self.bounds.size.width;
}

- (void)setVerticalAlignment:(NVLabelVerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    [self setNeedsLayout];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    //垂直对齐
    switch (self.verticalAlignment) {
        case NVLabelVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case NVLabelVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case NVLabelVerticalAlignmentMiddle:
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    
    //水平对齐
    switch (self.textAlignment) {
        case NSTextAlignmentCenter:
            textRect.origin.x = bounds.origin.x + (bounds.size.width - textRect.size.width)/2.0f;
            break;
        case NSTextAlignmentRight:
            textRect.origin.x = bounds.origin.x + bounds.size.width - textRect.size.width;
            break;
            
        case NSTextAlignmentLeft:
        case NSTextAlignmentJustified:
        case NSTextAlignmentNatural:
        default:
            textRect.origin.x = bounds.origin.x;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end

@interface NVDashLabel()

@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation NVDashLabel

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
    self.borderLayer.lineWidth = 1;
    int dashPattern = 4;
    self.borderLayer.lineDashPattern = @[@(dashPattern), @(dashPattern)];
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    self.borderLayer.fillColor = [UIColor clearColor].CGColor;
    self.borderLayer.strokeColor = self.dashColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self refreshBorderLayerStyle];
}

@end


@implementation NVShadowLabel

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOpacity = 0.5f;
}

@end



