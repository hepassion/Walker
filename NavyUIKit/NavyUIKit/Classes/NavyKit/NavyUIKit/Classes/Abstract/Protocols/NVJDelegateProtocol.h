//
//  JDelegateProtocol.h
//  App
//
//  Created by Dejun Liu on 2017/8/25.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//
//  使用Block取代Delegate
//

#import <Foundation/Foundation.h>

/**
 子类.m文件中必须实现：
 @synthesize completion;
 */
@protocol NVJDelegateProtocol

@property(nonatomic, copy) void (^completion)(id result);

@end
