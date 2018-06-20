//
//  NVTableViewLineCell.h
//  NavyUIKit
//
//  Created by Jelly on 6/21/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//


#import "NVTableViewCell.h"
#import "NVNoAnimationLayer.h"

@interface NVLineDataModel : NVDataModel

@property (nonatomic, assign) BOOL upperLineHidden;
@property (nonatomic, assign) BOOL lowerLineHidden;

//可选
@property (nonatomic, assign) UIEdgeInsets lineUpperMargin;   //默认{0,0,0,0}
@property (nonatomic, assign) UIEdgeInsets lineLowerMargin;   //默认{0,0,0,0}
@property (nonatomic, strong) UIColor* lineColor;             //默认nil
@property (nonatomic, assign) double lineHeight;              //默认0.5

@end

/*!
 @class
 @abstract      画顶部和底部线的TableViewCell。继承PATableViewCell
 */
@interface NVTableViewLineCell : NVTableViewCell
@property (nonatomic, strong) NVNoAnimationLayer* lineUpper;
@property (nonatomic, strong) NVNoAnimationLayer* lineLower;

@end



#define CLS_TABLE_VIEW_INDENT_LINE_CELL         @"PATableViewIndentLineCell"

/*!
 @class
 @abstract      画顶部和底部缩进线的TableViewCell。继承PATableViewCell
 */
@interface NVTableViewIndentLineCell : NVTableViewLineCell

@end


