//
//  NVTableViewLineCell.m
//  NavyUIKit
//
//  Created by Jelly on 6/21/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NavyUIKit.h"
#import "NVTableViewLineCell.h"

#define CELL_HEIGHT     40.0f

@implementation NVLineDataModel


@end

@implementation NVTableViewLineCell


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        self.clipsToBounds = NO;
        self.contentView.clipsToBounds = NO;
        if ([self.contentView.superview isKindOfClass:[NSClassFromString(@"UITableViewCellScrollView") class]]) {
            self.contentView.superview.clipsToBounds = NO;
        }
        
        self.lineUpper = [NVNoAnimationLayer layer];
        self.lineUpper.frame = CGRectMake(0.0f, 0.0f, APPLICATIONWIDTH, 0.5f);
        self.lineUpper.backgroundColor = COLOR_LINE.CGColor;
        [self.layer addSublayer:self.lineUpper];
        
        self.lineLower = [NVNoAnimationLayer layer];
        self.lineLower.frame = CGRectMake(0.0f, CELL_HEIGHT - 0.5, APPLICATIONWIDTH, 0.5f);
        self.lineLower.backgroundColor = COLOR_LINE.CGColor;
        [self.layer addSublayer:self.lineLower];
        
    }
    return self;
}


#pragma mark - layout
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat lineHeight = 0.5f;
    if ([self.item isKindOfClass:[NVLineDataModel class]]) {
        NVLineDataModel *model = (NVLineDataModel *)self.item;
        
        if (model.lineHeight > 0) {
            lineHeight = model.lineHeight;
        }
        
        self.lineUpper.frame = CGRectMake(model.lineUpperMargin.left,
                                          model.lineUpperMargin.top,
                                          self.width-model.lineUpperMargin.left-model.lineUpperMargin.right,
                                          lineHeight);
        self.lineLower.frame = CGRectMake(model.lineLowerMargin.left,
                                                                                                                                                 self.frame.size.height - lineHeight,
                                                                                                                                                 self.width-model.lineLowerMargin.left-model.lineLowerMargin.right,
                                                                                                                                                 lineHeight);
        if (model.lineColor) {
            self.lineUpper.backgroundColor = model.lineColor.CGColor;
            self.lineLower.backgroundColor = model.lineColor.CGColor;
        }
    } else {
        self.lineUpper.frame = CGRectMake(0,
                                          0,
                                          self.width,
                                          lineHeight);
        self.lineLower.frame = CGRectMake(0,
                                          self.frame.size.height - lineHeight,
                                          self.width,
                                          lineHeight);
    }
}

- (void)setObject:(id)object {
    [super setObject:object];
    if ([object isKindOfClass:[NVLineDataModel class]]) {
        NVLineDataModel *model = object;
        if (model.upperLineHidden) {
            self.lineUpper.hidden = YES;
        }else self.lineUpper.hidden = NO;
        
        if (model.lowerLineHidden) {
            self.lineLower.hidden = YES;
        }else self.lineLower.hidden = NO;
    } else {
        self.lineLower.hidden = YES;
        self.lineUpper.hidden = YES;
    }
}

@end



@implementation NVTableViewIndentLineCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        [self.lineUpper setBackgroundColor:COLOR_LINE];
        //        [self.lineLower setBackgroundColor:COLOR_LINE];
        
        CGFloat line = 0.5f;
        
        self.lineUpper.frame = CGRectMake(20.0f, 0.0f, APPLICATIONWIDTH - 20.0f, line);
        self.lineLower.frame = CGRectMake(20.0f, self.frame.size.height, APPLICATIONWIDTH - 20.0f, line);
    }
    
    return self;
}

#pragma mark - layout
- (void) setObject:(id)object {
    [super setObject:object];
}

+ (NSString*) cellIdentifier {
    return CLS_TABLE_VIEW_INDENT_LINE_CELL;
}

@end




