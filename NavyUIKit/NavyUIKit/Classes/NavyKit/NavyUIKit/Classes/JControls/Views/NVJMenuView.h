//
//  NVJMenuView.h
//  App
//
//  Created by Dejun Liu on 2017/9/7.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//
/*
 用法：
 {
 //NVJMenuView
 NVJMenuView *menuView = [[NVJMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0f)];
 menuView.top = v.bottom + 5.0f;
 NSMutableArray *models = [NSMutableArray array];
 for (int i=0; i<4; i++) {
 NVJMenuItemModel *model = [NVJMenuItemModel new];
 model.title = @"待收款";
 [models addObject:model];
 }
 
 NVJMenuListModel *model = [[NVJMenuListModel alloc] initWithModels:models];
 menuView.model = model;
 [self.view addSubview:menuView];
 
 lastView = menuView;
 }
 
 {
 //NVJMenuView
 NVJMenuView *menuView = [[NVJMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0f)];
 menuView.top = lastView.bottom + 5.0f;
 NSMutableArray *models = [NSMutableArray array];
 for (int i=0; i<10; i++) {
 NVJMenuItemModel *model = [NVJMenuItemModel new];
 model.title = @"待收款";
 model.isSort = YES;
 model.ascImage = [UIImage imageNamed:@"icon_pro_ascending"];
 model.descImage = [UIImage imageNamed:@"icon_pro_descending"];
 [models addObject:model];
 if (i==2) {
 model.title = @"A";
 }
 }
 
 NVJMenuListModel *model = [[NVJMenuListModel alloc] initWithModels:models];
 model.underlineAdjustWidthToMenuTitle = NO;
 model.allowScroll = YES;
 menuView.model = model;
 [self.view addSubview:menuView];
 
 lastView = menuView;
 }
 
 */

#import "NVJView.h"
#import <KKCategories/KKCategories.h>

@interface NVJMenuItemModel : NVJModel

/**
 必填
 */
PP_STRING(title)                                //标题

/**
 可选
 */
PP_ASSIGN_BASIC(BOOL, selected)                 //是否选中
PP_STRONG(UIColor, selectedBackgroundColor)     //选中按钮背景色
PP_STRONG(UIColor, selectedTitleColor)          //选中标题颜色
PP_STRONG(UIColor, normalTitleColor)            //正常标题颜色
PP_STRONG(UIFont, normalTitleFont)              //正常标题字体：默认14
PP_STRONG(UIImage, normalImage)                 //正常图标：默认nil
PP_ASSIGN_BASIC(JKImagePosition, imagePosition) //图标和文字之间的排列：图标在文字左边或右边；默认靠右
PP_ASSIGN_BASIC(double, imageTitleSpace)        //图片和文字之间的间距：默认2
PP_ASSIGN_BASIC(double, paddingLeftOrRight)     //按钮内容距离左右两边边距：allowScroll=YES 生效
PP_ASSIGN_BASIC(double, fixedWidth)             //按钮固定宽度；默认是根据内容自适应的，如果此大于0，则采用固定宽度：allowScroll=YES 生效

/**
 button带有排序功能时候，设置isSort为YES；并设置对应的图片
 */
PP_ASSIGN_BASIC(BOOL, isSort)   //YES有排序按钮
PP_ASSIGN_BASIC(BOOL, isDesc)   //是否为降序
PP_STRONG(UIImage, ascImage)    //升序图片
PP_STRONG(UIImage, descImage)   //降序图片
@end

@interface NVJMenuListModel : NVJListModel

PP_ASSIGN_BASIC(BOOL, underlineAnimated)                //滑动线是否有动画
PP_ASSIGN_BASIC(BOOL, underlineHidden)                  //YES滑动线隐藏
PP_ASSIGN_BASIC(BOOL, underlineAdjustWidthToMenuTitle)  //YES滑动线宽度根据内容自适应宽度
PP_ASSIGN_BASIC(double, underlineOffsetToBottom);       //滑动线距离底部的距离：默认0
PP_STRONG(UIColor, underlineColor)                      //滑动线颜色
PP_STRONG(UIColor, backgroundColor)                     //控件背景色
PP_ASSIGN_BASIC(NSInteger, defautIndex);                //默认选中索引
PP_ASSIGN_BASIC(BOOL, allowScroll);                     //超出可滚动
PP_ASSIGN_BASIC(BOOL, autoScrollItemToCenter);          //可滚动时候，对应button自动滚到中间;默认YES

@end


@class NVJMenuView;
@class NVJMenuItemModel;
@protocol NVJMenuViewDelegate <NSObject>

- (void)menuView:(NVJMenuView *) menuView
didSelectionIndex:(NSUInteger)index
        menuItem:(NVJMenuItemModel *) itemModel;
- (BOOL)menuView:(NVJMenuView *) menuView
willSelectionIndex:(NSUInteger)index
        menuItem:(NVJMenuItemModel *) itemModel;
- (void)menuView:(NVJMenuView *) menuView
didSelectionIndex:(NSUInteger)index
        menuItem:(NVJMenuItemModel *) itemModel
          isDesc:(BOOL) isDesc;

@end

@interface NVJMenuView : NVJView

PP_MUTABLE_ARRAY(buttons)
PP_STRONG(UIView, underline)
PP_STRONG(UIScrollView, scrollView)
PP_DELEGATE(NVJMenuViewDelegate, delegate)

//当前选中索引
PP_ASSIGN_BASIC(NSInteger, selectedIndex);

@end

@interface NVJMenuButton : UIButton

PP_ASSIGN_BASIC(BOOL, isSort);  // 是否为排序Button
PP_ASSIGN_BASIC(BOOL, isDesc);  // 是否为降序：isSort=YES才有效；默认NO ；NO为升序 YES为降序
PP_STRONG(UIImage, descImage);  // 降序图标；isSort=YES才有效；
PP_STRONG(UIImage, ascImage);   // 升序图标；isSort=YES才有效；

@end
