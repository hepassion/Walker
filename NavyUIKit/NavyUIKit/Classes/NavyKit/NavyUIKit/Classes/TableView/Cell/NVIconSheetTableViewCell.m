//
//  NVIconSheetTableViewCell.m
//  xiaochunlaile
//
//  Created by Steven.Lin on 27/11/15.
//  Copyright © 2015 Steven.Lin. All rights reserved.
//

#import "NVIconSheetTableViewCell.h"
#import "NavyUIKit.h"


@implementation NVIconSheetDataModel

@end



@interface NVIconSheetTableViewCell ()
@property (nonatomic, strong) UIImageView* uiIconView;
@end


#define CELL_HEIGHT     BASE_CELL_HEIGHT


@implementation NVIconSheetTableViewCell

- (void)initUI {
    self.backgroundColor        = COLOR_DEFAULT_WHITE;
    self.selectionStyle         = UITableViewCellSelectionStyleNone;
    
    self.uiIconView             = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f,
                                                                                (CELL_HEIGHT - 20.0f)/2,
                                                                                20.0f,
                                                                                20.0f)];
    [self.contentView addSubview:self.uiIconView];
    self.uiIconView.contentMode = UIViewContentModeScaleAspectFit;
    self.uiIconView.image       = [UIImage imageNamed:@"icon_info_manage.png"];
    
    
    CGRect frame                = _uiTitle.frame;
    frame.origin.x              = 30.0f + 10.0f;
    _uiTitle.frame              = frame;
}


- (void) setObject:(id)object {
    [super setObject:object];
    
    NVIconSheetDataModel* dataModel     = (NVIconSheetDataModel*)self.item;
    double height = dataModel.cellHeight.doubleValue;
    if (!dataModel.imageTintColor) {
        self.uiIconView.image               = [UIImage imageNamed:dataModel.imageNamed];
    } else {
        self.uiIconView.image               = [[UIImage imageNamed:dataModel.imageNamed] nv_tintedImageWithColor:dataModel.imageTintColor];
    }
    if (dataModel.iconLeft) {
        self.uiIconView.left = dataModel.iconLeft.doubleValue;
    }
    
    if (dataModel.iconTop) {
        self.uiIconView.top = dataModel.iconTop.doubleValue;
    }
    
    if (dataModel.iconSize) {
        CGSize size = [dataModel.iconSize CGSizeValue];
        self.uiIconView.size = size;
    }
    
    if (dataModel.iconVerticalAlignCenter) {
        self.uiIconView.centerY = height/2.0f;
    }
    
    if (dataModel.iconValueDistance) {
        double left = self.uiIconView.right+dataModel.iconValueDistance.doubleValue;
        
        UITextField *field = [self viewWithTag:TAG_SHEET_CELL_FIELD];
        field.left = left;
        
        UILabel *label = [self viewWithTag:TAG_SHEET_CELL_VALUE_LABEL];
        label.left = left;
    }
}


+ (CGFloat) heightForCell {
    return CELL_HEIGHT;
}

@end

