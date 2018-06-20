//
//  NavyUIKit.h
//  NavyUIKit
//
//  Created by Jelly on 6/17/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DJMacros/DJMacro.h>

#ifdef __OBJC__

/*!
 常用字体Macro
 */
#define FONT_HEITI_LIGHT_SIZE(s)            [UIFont fontWithName:@"STHeitiSC-Light" size:s]
#define FONT_HEITI_LIGHT                    FONT_HEITI_LIGHT_SIZE(14.0f)
#define FONT_HEITI_SIZE(s)                  [UIFont fontWithName:@"STHeitiSC" size:s]
#define FONT_HEITI                          FONT_HEITI_SIZE(14.0f)
#define FONT_HEITI_MEDIUM_SIZE(s)           [UIFont fontWithName:@"STHeitiSC-MEDIUM" size:s]
#define FONT_HEITI_MEDIUM                   FONT_HEITI_MEDIUM_SIZE(14.0f)

#define FONT_HELVETICA_SIZE(s)              [UIFont fontWithName:@"Helvetica" size:s]
#define FONT_HELVETICA_BOLD_SIZE(s)         [UIFont fontWithName:@"Helvetica-Bold" size:s]

#define FONT_HELVETICA_NEUE_SIZE(s)                         [UIFont fontWithName:@"HelveticaNeue" size:s]
#define FONT_HELVETICA_NEUE_BOLD_SIZE(s)                    [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]
#define FONT_HELVETICA_NEUE_LIGHT_SIZE(s)                   [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
#define FONT_HELVETICA_NEUE_ULTRA_LIGHT_SIZE(s)             [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:s]

#define FONT_APPLE_GOTHIC_NEO_THIN_SIZE(s)                  [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:s]
#define FONT_BANK_CARD_NUMBER_SIZE(s)                       [UIFont fontWithName:@"Farrington-7B-Qiqi" size:s]

#define FONT_LANTING_SIZE(s)                        [UIFont fontWithName:@"Lantinghei SC" size:s]

#define FONT_PINGFANG_SIZE(s)                       [UIFont fontWithName:@"PingFang SC" size:s]
#define FONT_PINGFANG_LIGHT_SIZE(s)                 [UIFont fontWithName:@"PingFangSC-Light" size:s]
#define FONT_PINGFANG_THIN_SIZE(s)                  [UIFont fontWithName:@"PingFangSC-Thin" size:s]
#define FONT_PINGFANG_ULTRA_LIGHT_SIZE(s)           [UIFont fontWithName:@"PingFangSC-Ultralight" size:s]

#define FONT_AVENIR_LIGHT_SIZE(s)                   [UIFont fontWithName:@"Avenir-Light" size:s]


#define FONT_SYSTEM_SIZE(s)                 [UIFont systemFontOfSize:s]
#define FONT_BOLD_SYSTEM_SIZE(s)            [UIFont boldSystemFontOfSize:s]


/*!
 常用颜色Macro
 */
#define COLOR_HM_BLACK             HEX(0x333333)
#define COLOR_HM_LIGHT_BLACK       HEX(0x616161)
#define COLOR_HM_DARK_GRAY         HEX(0x666666)
#define COLOR_HM_GRAY              HEX(0xaaaaaa)
#define COLOR_HM_LIGHT_GRAY        HEX(0xdcdcdc)
#define COLOR_HM_WHITE_GRAY        HEX(0xf5f5f5)

#define COLOR_HM_ORANGE            HEX(0xfa5e3f)
#define COLOR_HM_DRAK_ORANGE       HEX(0xff561e)
#define COLOR_HM_LIGHT_ORANGE      HEX(0xe8883f)
#define COLOR_HM_BLUE              HEX(0x4d9dd7)

#define COLOR_LINE                 HEX(0xf0f0f1)
#define COLOR_DEFAULT_WHITE        HEX(0xffffff)
#define COLOR_DEFAULT_BLACK        HEX(0x000000)

#define COLOR_SKY_BLUE             HEX(0x0569c2)
#define COLOR_SKY_GRAY             HEXA(0xb4b4b4,0.8)

/*!
 常用颜色Macro-根据功能定义
 */
#define COLOR_HM_THEME             HEX(0x075ca7)
#define COLOR_HM_THEME_SUB         HEX(0x0569c2)
#define COLOR_HM_IMPORTANT         HEX(0xfa5e3f)
#define COLOR_HM_TEXT              HEX(0x313131)
#define COLOR_HM_NONEDIT_TEXT      HEX(0x959595)

#define ATTR_DICTIONARY(color, size)                    @{NSForegroundColorAttributeName : color, NSFontAttributeName : nvNormalFontWithSize(size)}
#define ATTR_DICTIONARY2(color, bg_color, size)         @{NSForegroundColorAttributeName : color, NSBackgroundColorAttributeName: bg_color, NSFontAttributeName : nvNormalFontWithSize(size)}
#define ATTR_DICTIONARY3(color, font)                   @{NSForegroundColorAttributeName : color, NSFontAttributeName : font}


#define ATTRSTRING(text, attribute)         [[NSMutableAttributedString alloc] initWithString:text attributes:attribute]
#define ATTRSTRING2(attributedString)       [[NSMutableAttributedString alloc] initWithAttributedString:attributedString]

#define APPLICATIONWIDTH                    [UIScreen mainScreen].applicationFrame.size.width
#define APPLICATIONHEIGHT                   [UIScreen mainScreen].applicationFrame.size.height
#define APPLICATIONFRAME                    [UIScreen mainScreen].applicationFrame
#define APPLICATIONBOUNDS                   [UIScreen mainScreen].bounds
#define SCREENHEIGHT                        [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH                         [UIScreen mainScreen].bounds.size.width
#define NAVIGATIONBARBOUNDS                 (self.navigationController.navigationBar.bounds)
#define NAVIGATIONBARHEIGHT                 (NAVIGATIONBARBOUNDS.size.height)
#define TABBARHEIGHT                        (49.0f)
#define BASE_CELL_HEIGHT                    (38.0f * displayScale)



#define nvBoldFontWithSize(size)            FONT_BOLD_SYSTEM_SIZE(size)
#define nvNormalFontWithSize(size)          FONT_SYSTEM_SIZE(size)
#define nvNumberFontWithSize(size)          FONT_LANTING_SIZE(size)




UIFont* navigationTitleFont();
UIFont* navigationTitleFontWithSize(CGFloat size);



#define displayScale    (nativeScale() / 2)
#define fontScale       ((ceil(displayScale)-1)*2)

CGFloat nativeScale(void);

/*!
 DEBUG模式输出Log
 */
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#endif
