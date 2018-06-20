//
//  NVSwitchTableViewCell.h
//  App
//
//  Created by Dejun Liu on 2017/9/6.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//

#import "NavyUIKit.h"
#import "NVSheetTableViewCell.h"
#import <KLSwitch/KLSwitch.h>

@interface NVJSwitchSheetDataModel : NVSheetDataModel

/**
 开关大小：默认（FIT6P(155), FIT6P(92)）
 */
PP_ASSIGN_BASIC(CGSize, switchSize);
/**
 距离右边控件的距离：默认5.0f
 */
PP_ASSIGN_BASIC(CGFloat, switchMarginRight);
PP_STRONG(UIColor, switchTintColor);
PP_ASSIGN_BASIC(BOOL, switchOn);

@end


@class NVJSwitchTableViewCell;
@protocol NVJSwitchTableViewCellDelegate <NSObject>

- (void)switchTableViewCell:(NVJSwitchTableViewCell *) cell didChange:(BOOL) isOn;

@end

@interface NVJSwitchTableViewCell : NVIntroSheetTableViewCell

PP_STRONG(KLSwitch, switchBtn)
PP_DELEGATE(NVJSwitchTableViewCellDelegate, switchDelegate);

@end
