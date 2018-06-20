//
//  NVJMenuView.m
//  App
//
//  Created by Dejun Liu on 2017/9/7.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//

#import "NVJMenuView.h"
#import "UIImage+Category.h"
#import "Macros.h"

@implementation NVJMenuItemModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imagePosition = LXMImagePositionRight;
        self.imageTitleSpace = 2.0f;
        self.selectedTitleColor = COLOR_HM_THEME;
        self.normalTitleColor = COLOR_HM_BLACK;
        self.normalTitleFont = [UIFont boldSystemFontOfSize:14];
        self.selectedBackgroundColor = COLOR_HM_LIGHT_GRAY;
        self.paddingLeftOrRight = 5.0f;
    }
    return self;
}

- (void)setAscImage:(UIImage *)ascImage {
    if (_ascImage != ascImage) {
        _ascImage = ascImage;
        _normalImage = ascImage;
    }
}

@end

@implementation NVJMenuListModel

- (instancetype)initWithModels:(NSArray<NVJModel *> *)models
{
    self = [super initWithModels:models];
    if (self) {
        self.underlineAnimated = YES;
        self.backgroundColor = HEX(0xefefef);
        self.underlineColor = COLOR_HM_THEME;
        self.underlineAdjustWidthToMenuTitle = YES;
        self.autoScrollItemToCenter = YES;
    }
    return self;
}

@end

@implementation NVJMenuView

- (void)initUI {
    self.backgroundColor = [UIColor lightGrayColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.contentSize = self.bounds.size;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
//    self.scrollView.contentSize = CGSizeMake(640, self.scrollView.height);
    
    self.underline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.scrollView addSubview:self.underline];
}

- (void)updateUI {
    
}

- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    
    return _buttons;
}

- (NVJMenuListModel *)getModel {
    return (NVJMenuListModel *)[super getModel];
}

- (void)setModel:(NVJMenuListModel *)model {
    [super setModel:model];
    
    if (!model.items.count) {
        return;
    }
    
    double itemWidth = self.width/model.items.count;
    
    [model.items enumerateObjectsUsingBlock:^(NVJMenuItemModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NVJMenuButton *button = [NVJMenuButton buttonWithType:UIButtonTypeCustom];
        button.clipsToBounds = YES;
        button.tag = idx;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitle:obj.title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(menuItemDidClick:)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, itemWidth, self.height);
        
        if (model.allowScroll) {
            double textWidth = [obj.title jk_widthWithFont:obj.normalTitleFont
                                       constrainedToHeight:button.height];
            double imgWidth = obj.normalImage.pointSize.width;
            double btnWidth = 0.0f;
            if (imgWidth > 0) {
                btnWidth = textWidth+obj.imageTitleSpace+imgWidth;
            } else {
                btnWidth = textWidth;
            }
            
            if (obj.fixedWidth > 0) {
                button.width = obj.fixedWidth;
            } else {
                button.width = btnWidth+obj.paddingLeftOrRight;
            }
            
        } else {
            button.left = itemWidth*idx;
        }
        
        [self.scrollView addSubview:button];
        
        if (obj.selectedBackgroundColor) {
            [button setBackgroundImage:[UIImage imageWithColor:obj.selectedBackgroundColor]
                              forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageWithColor:obj.selectedBackgroundColor]
                              forState:UIControlStateHighlighted];
        }
        
        if (obj.selectedTitleColor) {
            [button setTitleColor:obj.selectedTitleColor forState:UIControlStateSelected];
        }
        
        if (obj.normalTitleColor) {
            [button setTitleColor:obj.normalTitleColor forState:UIControlStateNormal];
        }
        
        if (obj.normalTitleFont) {
            button.titleLabel.font = obj.normalTitleFont;
        }
        
        if (obj.normalImage) {
            [button setImage:obj.normalImage forState:UIControlStateNormal];
            [button jk_setImagePosition:obj.imagePosition spacing:obj.imageTitleSpace];
        }
        
        button.isSort = obj.isSort;
        button.isDesc = obj.isDesc;
        button.ascImage = obj.ascImage?obj.ascImage:obj.normalImage;
        button.descImage = obj.descImage;
        button.selected = obj.selected;
        
        [self.buttons addObject:button];
    }];
    
    self.underline.width = itemWidth;
    self.underline.height = 2.0f;
    self.underline.bottom = self.height - model.underlineOffsetToBottom;
    self.underline.left = 0.0f;
    if (model.underlineColor) {
        self.underline.backgroundColor = model.underlineColor;
    }
    if (model.underlineHidden) {
        self.underline.hidden = YES;
    }
    
    if (model.backgroundColor) {
        self.backgroundColor = model.backgroundColor;
    }
    
    [self.scrollView bringSubviewToFront:self.underline];
    
    //自适应button宽度
    if (model.allowScroll) {
        double deltaSpace = 5.0f;
        __block double left = deltaSpace;
        [self.buttons enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            double curBtnWidth = obj.width;
            obj.width = curBtnWidth;
            obj.left = left;
            left += curBtnWidth + deltaSpace;
            
        }];
        
        double totalWidth = left;
        self.scrollView.contentSize = CGSizeMake(totalWidth, self.scrollView.height);
        if (totalWidth < self.scrollView.width) {
            self.scrollView.width = totalWidth;
            self.scrollView.centerX = self.centerX;
        }
        
    }
    
    //设置默认index
    if (model.defautIndex < model.items.count) {
        self.selectedIndex = model.defautIndex;
    } else {
        self.selectedIndex = 0;
    }
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
    }
    
//    NVJMenuListModel *model = (NVJMenuListModel *)self.model;
//    ((NVJMenuItemModel *)model.items[selectedIndex]).selected = YES;
//    ((UIButton *)self.buttons[selectedIndex]).selected = YES;
    [self menuItemDidClick:self.buttons[selectedIndex]];
}

- (void)menuItemDidClick:(NVJMenuButton *) button {
    NVJMenuListModel *model = (NVJMenuListModel *)self.model;
    NVJMenuItemModel *itemModel = [model.items objectAtIndex:button.tag];
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(menuView:
                                                    willSelectionIndex:
                                                    menuItem:)]) {
        if (![self.delegate menuView:self willSelectionIndex:button.tag menuItem:itemModel]) {
            return;
        };
    }
    
    _selectedIndex = button.tag;
    
    if (!button.isSort) {
        button.userInteractionEnabled = NO;
        [self.buttons enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (button != obj) {
                obj.selected = NO;
                obj.userInteractionEnabled = YES;
            }
        }];
    } else {
        [self.buttons enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (button != obj) {
                obj.selected = NO;
            }
        }];
        
        if (button.selected == YES) {
            button.isDesc = !button.isDesc;
            if (button.isDesc) {
                [button setImage:button.descImage forState:UIControlStateSelected];
                [button setImage:button.descImage forState:UIControlStateNormal];
                [button setImage:button.descImage forState:UIControlStateHighlighted];
            } else {
                [button setImage:button.ascImage forState:UIControlStateSelected];
                [button setImage:button.ascImage forState:UIControlStateNormal];
                [button setImage:button.ascImage forState:UIControlStateHighlighted];
            }
            
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(menuView:
                                                            didSelectionIndex:
                                                            menuItem:
                                                            isDesc:)]) {
                [self.delegate menuView:self
                      didSelectionIndex:button.tag
                               menuItem:itemModel
                                 isDesc:button.isDesc];
            }
        }
    }
    
    button.selected = YES;
    itemModel.selected = YES;
    
    [((NVJMenuListModel *)self.model).items enumerateObjectsUsingBlock:^(NVJMenuItemModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (itemModel != obj) {
            obj.selected = NO;
        }
    }];
    
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(menuView:
                                                   didSelectionIndex:
                                                   menuItem:)]) {
        [self.delegate menuView:self
              didSelectionIndex:button.tag
                       menuItem:itemModel];
    }
    
    if (model.underlineAdjustWidthToMenuTitle) {
        double btnWidth = button.titleLabel.width?button.titleLabel.width:[button.titleLabel.text jk_widthWithFont:button.titleLabel.font
                                                                                               constrainedToHeight:button.height];;
        if (button.imageView.width > 0) {
            btnWidth = button.titleLabel.width+button.imageView.width+((NVJMenuItemModel *)model.items[button.tag]).imageTitleSpace;
        }

        if (btnWidth > button.width) {
            btnWidth = button.width;
        }
        if (model.underlineAnimated) {
            [UIView animateWithDuration:0.25 animations:^{
                self.underline.width = btnWidth;
                self.underline.centerX = button.centerX;
            }];
        } else {
            self.underline.width = btnWidth;
            self.underline.centerX = button.centerX;
        }
        
    } else {
        if (model.underlineAnimated) {
            [UIView animateWithDuration:0.25 animations:^{
                self.underline.width = button.width;
                self.underline.left = button.left;
            }];
        } else {
            self.underline.width = button.width;
            self.underline.left = button.left;
        }
    }
    
    if (model.allowScroll) {
        if (model.autoScrollItemToCenter) {
            //目标Item滚动到中间
            double offsetX = button.centerX-self.scrollView.width/2;
            if (offsetX < 0) {  //左边边界条件
                [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                return;
            }
            if (offsetX > self.scrollView.contentSize.width-self.scrollView.width) {
                //右边边界条件
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-self.scrollView.width, 0) animated:YES];
                return;
            }
            
            [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        } else {
            [self.scrollView scrollRectToVisible:button.frame animated:YES];
        }
    }
}

@end

@implementation NVJMenuButton

@end
