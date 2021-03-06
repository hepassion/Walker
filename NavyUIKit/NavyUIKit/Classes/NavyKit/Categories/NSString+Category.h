//
//  NSString+Category.h
//  NavyCoreFoundation
//
//  Created by Jelly on 6/17/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

- (BOOL) isValidMobileNumber;
- (BOOL) isValidVerifyCode;
- (BOOL) isValidBankCardNumber;
- (BOOL) isValidIdentityCard;
- (BOOL) isValidHKTWMCIdentityCode;//有效的港澳台回乡证
- (BOOL) isValidEmailAddress;
- (BOOL) isValidChinese;
- (BOOL) isName;
- (BOOL) isValidZip;
- (BOOL) hasExistedSpace;
- (BOOL) isValidAmount;

+ (NSString*) stringFormatCurrencyFloorWithDouble:(double)currency;     //钱转为2位小数(直接舍去第三位),并添加逗号
+ (NSString*) stringFormatCurrencyRoundWithDouble:(double)currency;     //钱转为2位小数(对第三位进行四舍伍入),并添加逗号
+ (NSString*) stringFormatCurrencyToIntegerWithDouble:(double)currency; //转为带有逗号的整数字符串
+ (NSString*) stringFormatJPYCurrencyWithDouble:(double)currency;

+ (BOOL)isBlankString:(NSString *)string;
- (NSString*) stringValue;
/**
 *  银行卡每4位一个空白字符，显示样式
 *
 *  @return 银行卡每4位一个空白字符字符串
 */
- (NSString*) toBankStyleString;
- (NSString*) removeWhiteSpace;
@end


@interface NSString (urlEncode)
- (NSString *)URLEncodedString;
- (NSString *)URLEncodedChineseString;
- (NSString *)URLDecodedChineseString;
@end


@interface NSString (Base64)
+ (NSString *)base64StringFromData:(NSData *)data length:(NSUInteger)length;
@end


@interface NSString (MD5)
- (NSString*) md5String;
@end


@interface NSString (Format)
+ (NSString*) stringMobileFormat:(NSString*)mobile;
+ (NSString*) stringChineseFormat:(double)value;

@end


@interface NSString (UrlParameters)
- (NSDictionary*) parameters;
- (NSArray*) parametersSorted;
- (NSDictionary*)jsonPatameters;

@end


@interface NSString (Date)
+ (NSString*) stringFromDate:(NSDate*)date;
@end





