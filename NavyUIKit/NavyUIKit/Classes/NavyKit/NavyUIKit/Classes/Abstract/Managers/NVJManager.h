//
//  Manager.h
//  App
//
//  Created by Dejun Liu on 2017/8/22.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//
//  所有Manager超类
//
#import <Foundation/Foundation.h>

@interface NVJManager : NSObject

/**
 每个子类必须实现此方法，用于初始化这个Manager需要的资源
 */
- (void) initialize ;

@end
