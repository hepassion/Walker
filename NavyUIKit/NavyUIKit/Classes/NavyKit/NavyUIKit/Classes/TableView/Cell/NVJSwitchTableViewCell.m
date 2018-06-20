//
//  NVSwitchTableViewCell.m
//  App
//
//  Created by Dejun Liu on 2017/9/6.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//

#import "NVJSwitchTableViewCell.h"

@implementation NVJSwitchSheetDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.switchSize = CGSizeMake(FIT6P(155), FIT6P(92));
        self.switchMarginRight = 10.0f;
        self.switchTintColor = [UIColor blueColor];
        self.switchOn = NO;
    }
    return self;
}

@end

@implementation NVJSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WEAK_SELF;
        self.switchBtn = [[KLSwitch alloc] initWithFrame:CGRectMake(0, 0, FIT6P(155), FIT6P(92)) didChangeHandler:^(BOOL isOn) {
            ((NVJSwitchSheetDataModel *)weakself.item).switchOn = isOn;
            if (weakself.switchDelegate &&
                [weakself.switchDelegate respondsToSelector:@selector(switchTableViewCell:didChange:)]) {
                [weakself.switchDelegate switchTableViewCell:weakself didChange:isOn];
            }
        }];
        [self.contentView addSubview:self.switchBtn];
    }
    return self;
}

- (void)setObject:(NVJSwitchSheetDataModel *)object {
    [super setObject:object];
    [self.contentView bringSubviewToFront:self.switchBtn];
    self.switchBtn.width = object.switchSize.width;
    self.switchBtn.height = object.switchSize.height;
    self.switchBtn.centerY  = object.cellHeight.floatValue/2.0f;
    self.switchDelegate = object.delegate;
    
    if (object.intro) {
        self.switchBtn.right    = self.introView.left - object.switchMarginRight;
    } else {
        self.switchBtn.right    = self.width - object.switchMarginRight;
    }
    
    self.switchBtn.onTintColor = object.switchTintColor;
    self.switchBtn.on = object.switchOn;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return [super tableView:tableView rowHeightForObject:object];
}

@end
