//
//  NVJTableViewHorizontalItemsCell.h
//  App
//
//  Created by Dejun Liu on 2017/8/28.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//
/*
 用法：
 {
 //models
 NVJHorizontalItemModel *itemModel = [[NVJHorizontalItemModel alloc] initWithPadding:UIEdgeInsetsMake(10, 10, 10, 10)
 itemSize:CGSizeMake((SCREEN_WIDTH-20)/5, 45)
 columnCount:4];
 itemModel.rowSpace = 10;
 
 for (int i=0; i<6; i++) {
 NVJHorizontalItem *item = [[NVJHorizontalItem alloc] initWithTitle:@"世界你好"
 image:[UIImage imageNamed:@"pay_zhifubao"]
 selected:NO];
 item.highlightedBackgroundColor = [[UIColor whiteColor] convertToHSBwithBrighnessDelta:-0.1];
 item.space = 10;
 item.imageSpaceToTop = 0;
 item.titleSpaceToBottom = 0;
 item.autoAdjustButtonHeight = YES;
 [itemModel.items addObject:item];
 }
 
 NVJTableViewHorizListDataModel* model      = [[NVJTableViewHorizListDataModel alloc] init];
 model.cellClass              = [NVJTableViewHorizListCell class];
 model.cellType               = [NSString stringWithFormat:@"cell.horiz.list.1"];
 model.cellHeight             = [NSNumber numberWithFloat:[NVJTableViewHorizListCell heightForCellWithModel:itemModel]];
 model.delegate = self.viewControllerDelegate;
 
 model.model = itemModel;
 
 [self.items addObject:model];
 }
 */

#import "NavyUIKit.h"
#import "NVJHorizontalItemsView.h"

@interface NVJTableViewHorizListDataModel : NVLineDataModel

@property (nonatomic, strong) NVJHorizontalItemModel* model;

@end

@class NVJTableViewHorizListCell;
@protocol NVJTableViewHorizListCellDelegate <NSObject>

- (void)tableViewHorizListCell:(NVJTableViewHorizListCell *) cell didSelectedItem:(NVJHorizontalItem *) item button:(UIButton *)button;

@end

@interface NVJTableViewHorizListCell : NVTableViewLineCell
<NVJHorizontalItemViewDelegate>

@property (nonatomic, strong) NVJHorizontalItemView *itemsView;


/**
 根据model动态计算cell高度
 
 model.autoAdjustButtonHeight设置为YES无效，会出现偏差，YES时候为视图自动计算适配高度。
 此为计算固定高端不合适。

 @param model <#model description#>
 @return <#return value description#>
 */
+ (CGFloat)heightForCellWithModel:(NVJHorizontalItemModel *) model;

@end
