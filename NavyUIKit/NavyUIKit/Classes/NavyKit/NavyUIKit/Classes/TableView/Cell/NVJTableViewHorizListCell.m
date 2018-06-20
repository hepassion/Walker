//
//  NVJTableViewHorizontalItemsCell.m
//  App
//
//  Created by Dejun Liu on 2017/8/28.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//

#import "NVJTableViewHorizListCell.h"
#import "UIColor+Category.h"

@implementation NVJTableViewHorizListDataModel


@end

@implementation NVJTableViewHorizListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

- (NVJHorizontalItemView *)itemsView {
    if (_itemsView == nil) {
        _itemsView = [[NVJHorizontalItemView alloc] initWithFrame:CGRectMake(0, 0, self.width, [NVJTableViewHorizListCell heightForCell])];
        _itemsView.delegate = self;
        [self.contentView addSubview:_itemsView];
    }
    
    return _itemsView;
}

- (void)setObject:(NVJTableViewHorizListDataModel *)object {
    [super setObject:object];
    
    [self.itemsView setModel:object.model];
    [self.itemsView updateUI];
}

+ (CGFloat)heightForCellWithModel:(NVJHorizontalItemModel *) model {
    return [NVJHorizontalItemView getHeightWithModel:model];
}

#pragma mark - NVJHorizontalItemViewDelegate
- (void)NVJHorizontalItemView:(NVJHorizontalItemView *)view model:(NVJHorizontalItemModel *)model selectedIndex:(NSInteger)index {

}

- (void)NVJHorizontalItemViewDidSelectedItem:(NVJHorizontalItem *)model button:(UIButton *)button {
    if (self.item.delegate &&
        [self.item.delegate respondsToSelector:@selector(tableViewHorizListCell:didSelectedItem:button:)]) {
        [self.item.delegate tableViewHorizListCell:self didSelectedItem:model button:button];
    }
}

- (void)NVJHorizontalItemViewRenderButton:(UIButton *)button model:(NVJHorizontalItem *)model index:(NSInteger)idx {
    
}

@end
