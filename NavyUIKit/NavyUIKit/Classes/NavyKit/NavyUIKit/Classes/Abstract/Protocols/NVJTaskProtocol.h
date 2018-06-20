//
//  Manager.h
//  App
//
//  Created by Dejun Liu on 2017/8/22.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//
//  任务协议：
//  1.如需要完成登陆任务，登陆完成后执行根据回调完成下一个任务，这里需要一个任务完成的回调
//

#import <Foundation/Foundation.h>

/**
 任务完成后的回调函数

 @param success YES 任务完成 NO 失败
 @param info 任务完成后可以用来传递一些参数
 */
typedef void (^NVJTaskCompletion)(BOOL success, id info);


/**
 子类.m文件中必须实现：
 @synthesize completion;
 */
@protocol NVJTaskProtocol

@property(nonatomic, copy) NVJTaskCompletion completion;

@end
