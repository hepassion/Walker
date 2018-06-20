//
//  NVIconSheetTableViewCell.h
//  xiaochunlaile
//
//  Created by Steven.Lin on 27/11/15.
//  Copyright © 2015 Steven.Lin. All rights reserved.
//

#import "NavyUIKit.h"
#import "NVSheetTableViewCell.h"



@interface NVIconSheetDataModel : NVSheetDataModel
@property (nonatomic, strong) NSString* imageNamed;

@property (nonatomic, strong) UIColor * imageTintColor;         //将image变成某种颜色
@property (nonatomic, strong) NSNumber* iconLeft;               //icon距离左边距离
@property (nonatomic, strong) NSNumber* iconTop;                //icon距离顶部距离
@property (nonatomic, strong) NSValue*  iconSize;               //icon大小
@property (nonatomic, assign) BOOL      iconVerticalAlignCenter;//icon垂直居中
@property (nonatomic, strong) NSNumber* iconValueDistance;      //icon和value的距离指定为固定的距离

@end


@interface NVIconSheetTableViewCell : NVIntroSheetTableViewCell

@end

