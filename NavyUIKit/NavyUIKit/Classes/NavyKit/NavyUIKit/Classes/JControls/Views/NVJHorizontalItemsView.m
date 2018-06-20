//
//  NVJHorizontalItemView.m
//  App
//
//  Created by Dejun Liu on 2017/8/25.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//

#import "NVJHorizontalItemsView.h"
#import "UIImage+Category.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <KKCategories/KKCategories.h>

@implementation NVJHorizontalItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:12];
        self.titleColor = HEX(0x333333);
        self.space = 0;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *) title
                        image:(UIImage *) image
                     selected:(BOOL) selected
{
    self = [self init];
    if (self) {
        self.title = title;
        self.image = image;
        self.selected = selected;
    }
    return self;
}

@end

@implementation NVJHorizontalItemModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.colCount = 2;
        self.itemSize = CGSizeMake(60, 50);
        self.rowSpace = 5.0f;
    }
    return self;
}

- (instancetype)initWithPadding:(UIEdgeInsets) padding
                       itemSize:(CGSize) size
                    columnCount:(NSInteger) columnCount
{
    self = [self init];
    if (self) {
        self.padding = padding;
        self.itemSize = size;
        self.colCount = columnCount;
    }
    return self;
}

- (NSMutableArray<NVJHorizontalItem *> *)items {
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    
    return _items;
}

@end

@interface NVJHorizontalItemView ()

@end

@implementation NVJHorizontalItemView

-(void)initUI {
    self.buttons = [NSMutableArray array];
}

-(void)updateUI {
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.buttons removeAllObjects];
    
    NVJHorizontalItemModel *m = (NVJHorizontalItemModel *)self.model;
    UIEdgeInsets edge = m.padding;
    
    WEAK_SELF;
    //添加buttons
    [m.items enumerateObjectsUsingBlock:^(NVJHorizontalItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx;
        button.selected = obj.selected;
        [button addTarget:self action:@selector(didTapItem:) forControlEvents:UIControlEventTouchUpInside];
        
        if (obj.imageTintColor) {
            [button setImage:[obj.image imageWithColor:obj.imageTintColor] forState:UIControlStateNormal];
        } else {
            [button setImage:obj.image forState:UIControlStateNormal];
        }
        
        if (obj.imageHighlightedTintColor) {
            UIImage *image = obj.highlightedImage?obj.highlightedImage:obj.image;
            [button setImage:[image imageWithColor:obj.imageHighlightedTintColor] forState:UIControlStateHighlighted];
        } else {
            UIImage *image = obj.highlightedImage?obj.highlightedImage:obj.image;
            [button setImage:image forState:UIControlStateHighlighted];
        }
        
        if (obj.imageSelectedTintColor) {
            UIImage *image = obj.selectedImage?obj.selectedImage:obj.image;
            [button setImage:[image imageWithColor:obj.imageSelectedTintColor] forState:UIControlStateSelected];
        } else {
            UIImage *image = obj.selectedImage?obj.selectedImage:obj.image;
            [button setImage:image forState:UIControlStateSelected];
        }
        
        if (obj.imageDisableTintColor) {
            UIImage *image = obj.disableImage?obj.disableImage:obj.image;
            [button setImage:[image imageWithColor:obj.imageDisableTintColor] forState:UIControlStateDisabled];
        } else {
            UIImage *image = obj.disableImage?obj.disableImage:obj.image;
            [button setImage:image forState:UIControlStateDisabled];
        }
        
        [button setTitle:obj.title forState:UIControlStateNormal];
        [button setTitleColor:obj.titleColor forState:UIControlStateNormal];
        if (obj.titleHighlightedColor) {
            [button setTitleColor:obj.titleHighlightedColor forState:UIControlStateHighlighted];
        }
        if (obj.titleSelectedColor) {
            [button setTitleColor:obj.titleSelectedColor forState:UIControlStateSelected];
        }
        
        if (obj.titleDisableColor) {
            [button setTitleColor:obj.titleDisableColor forState:UIControlStateDisabled];
        }
        
        if (obj.backgroundColor) {
            [button setBackgroundImage:[UIImage imageWithColor:obj.backgroundColor] forState:UIControlStateNormal];
        }
        
        if (obj.highlightedBackgroundColor) {
            [button setBackgroundImage:[UIImage imageWithColor:obj.highlightedBackgroundColor] forState:UIControlStateHighlighted];
        }
        
        if (obj.backgroundImage) {
            [button setBackgroundImage:obj.backgroundImage forState:UIControlStateNormal];
        }
        
        if (obj.backgroundSelectedImage) {
            [button setBackgroundImage:obj.backgroundSelectedImage forState:UIControlStateSelected];
        }
        
        if (obj.backgroundHighlightedImage) {
            [button setBackgroundImage:obj.backgroundHighlightedImage forState:UIControlStateHighlighted];
        }
        
        if (obj.imageUrl) {
            [button sd_setImageWithURL:obj.imageUrl forState:UIControlStateNormal placeholderImage:obj.imageUrlLoadingPlaceHolder];
            [button sd_setImageWithURL:obj.imageUrl forState:UIControlStateHighlighted placeholderImage:obj.imageUrlLoadingPlaceHolder];
        }
        
        button.titleLabel.font = obj.font;
        button.size = m.itemSize;
        button.backgroundColor = [UIColor whiteColor];
        button.enabled = !obj.disable;
        
        [self.buttons addObject:button];
        [self addSubview:button];
        
        //对齐图片文字
        if (obj.title.length > 0 && obj.image != nil) {
            // the space between the image and text
            CGFloat spacing = obj.space;
            
            // lower the text and push it left so it appears centered
            //  below the image
            CGSize imageSize = button.imageView.image.size;
            button.titleEdgeInsets = UIEdgeInsetsMake(
                                                      0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
            
            // raise the image and push it right so it appears centered
            //  above the text
            CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
            button.imageEdgeInsets = UIEdgeInsetsMake(
                                                      - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
            
            // increase the content height to avoid clipping
            CGFloat edgeOffset = fabsf(titleSize.height - imageSize.height) / 2.0;
            button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset+obj.imageSpaceToTop, 0.0, edgeOffset+obj.titleSpaceToBottom, 0.0);
            if (obj.autoAdjustButtonHeight) {
                double height = obj.imageSpaceToTop+button.imageView.height+obj.space+button.titleLabel.height+obj.titleSpaceToBottom;
                button.height = height;
                m.itemSize = CGSizeMake(m.itemSize.width, button.height);
            }
        }
        
        [button.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull btnSubView, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([btnSubView isKindOfClass:[UIImageView class]] &&
                btnSubView == button.imageView) {
                //设置图片圆角
                if (obj.imageCornerRadius > 0) {
                    btnSubView.layer.cornerRadius = obj.imageCornerRadius;
                }
                if (obj.imageBackgroundColor) {
                    btnSubView.backgroundColor = obj.imageBackgroundColor;
                }
            }
        }];
        
        //render delegate
        STRONG_SELF;
        if (strongself.delegate &&
            [strongself.delegate respondsToSelector:@selector(NVJHorizontalItemViewRenderButton:model:index:)]) {
            [strongself.delegate NVJHorizontalItemViewRenderButton:button model:obj index:idx];
        }
    }];
    
    //设置位置
    CGSize size = m.itemSize;
    int count = m.items.count;
//    double delta = (self.width - edge.left - edge.right-size.width*1)/(count-1);
//    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.top = edge.top;
//        if (count == 1) {
//            obj.centerX = self.centerX;
//        } else {
//            obj.left = edge.left + idx * delta;
//        }
//        
//    }];
    
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger rowCount = ceil(count/(double)m.colCount);
        
        //Y轴距离计算
        NSInteger curRow = ceil((idx + 1)/(double)m.colCount);
        obj.top = edge.top+(curRow-1)*(size.height+m.rowSpace);
        
        NSInteger curColCount = 0;
        if (curRow < rowCount) {
            curColCount = m.colCount;
        } else {
            NSInteger lastRowCount = count%m.colCount;
            if (lastRowCount == 0) {
                curColCount = m.colCount;
            } else {
                curColCount = lastRowCount;
            }
        }
        
        //水平计算
        NSInteger curCol = (idx)%m.colCount;
        if (curColCount == 1) {
            obj.left = edge.left;
        } else {
            double delta = (self.width - edge.left - edge.right-size.width*1)/(m.colCount-1);
            obj.left = edge.left + curCol * delta;
        }
    }];
    
    self.height = [self getHeight];
}

- (void)didTapItem:(UIButton *) btn {
//    btn.selected = !btn.selected;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(NVJHorizontalItemViewDidSelectedItem:button:)]) {
        NVJHorizontalItemModel *model = (NVJHorizontalItemModel *)self.model;
        [self.delegate NVJHorizontalItemViewDidSelectedItem:model.items[btn.tag] button:btn];
    }
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(NVJHorizontalItemView:model:selectedIndex:)]) {
        NVJHorizontalItemModel *model = (NVJHorizontalItemModel *)self.model;
        [self.delegate NVJHorizontalItemView:self model:model selectedIndex:btn.tag];
    }
}

- (CGFloat)getHeight {
    NVJHorizontalItemModel *m = (NVJHorizontalItemModel *)self.model;
    NSInteger rowCount = ceil(m.items.count/(double)m.colCount);
    return m.padding.top+m.padding.bottom+rowCount*m.itemSize.height+(rowCount-1)*m.rowSpace;
}

+ (CGFloat)getHeightWithModel:(NVJHorizontalItemModel *)model {
    NVJHorizontalItemModel *m = model;
    NSInteger rowCount = ceil(m.items.count/(double)m.colCount);
    return m.padding.top+m.padding.bottom+rowCount*m.itemSize.height+(rowCount-1)*m.rowSpace;
}

@end
