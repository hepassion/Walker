//
//  NVJView.h
//  App
//
//  Created by Dejun Liu on 2017/8/25.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macros.h"

/**
 视图配置Model
 */
@interface NVJModel : NSObject

/**
 绑定一些自定义操作时候，需要的数据传递。
 当callBack回调的时候，可以把这信息一起再传递给你。
 默认为nil
 */
@property (nonatomic, strong) id userinfo;

@end


/**
 存放视图中的一组元素
 */
@interface NVJListModel : NVJModel

PP_MUTABLE_ARRAY(items)

- (instancetype)init;
- (instancetype)initWithModels:(NSArray<NVJModel *> *) models;

@end


/**
 视图基类
 */
@interface NVJView : UIView

@property (nonatomic, strong) NVJModel *model;

/**
 子类必须实现
 初始化UI轮廓
 */
- (void)initUI;

/**
 子类必须实现
 根据模型数据，来动态改变UI显示内容
 */
- (void)updateUI;

/**
 子类可选实现
 设置每个UI对应的模型，并刷新

 @param model 配置模型
 */
- (void)setModel:(NVJModel *)model;
- (NVJModel *)getModel;

@end
