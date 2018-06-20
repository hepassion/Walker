//
//  NVLabel.h
//  NavyUIKit
//
//  Created by Jelly on 6/23/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NVLabelVerticalAlignmentTop = 0, //default
    NVLabelVerticalAlignmentMiddle,
    NVLabelVerticalAlignmentBottom,
    
} NVLabelVerticalAlignment;

@interface NVLabel : UILabel {
    NVLabelVerticalAlignment _verticalAlignment;
}
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign, readonly) CGFloat width;

@property (nonatomic, assign) NVLabelVerticalAlignment verticalAlignment;
@end


/*!
 @class
 @abstract      画虚线的Label
 */
@interface NVDashLabel : NVLabel
@property (nonatomic, strong) UIColor* dashColor;

@end


@interface NVShadowLabel : NVLabel

@end

