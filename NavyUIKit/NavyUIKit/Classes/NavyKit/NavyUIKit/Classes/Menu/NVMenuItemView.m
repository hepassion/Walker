//
//  NVMenuItemView.m
//  Navy
//
//  Created by Jelly on 6/29/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NVMenuItemView.h"

@implementation NVMenuItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}


- (CGFloat) width {
    return 0.0f;
}

- (UIEdgeInsets) textEdgeInsets {
    return UIEdgeInsetsZero;
}

@end
