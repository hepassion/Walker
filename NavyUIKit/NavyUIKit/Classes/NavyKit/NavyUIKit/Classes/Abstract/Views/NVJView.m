//
//  NVJView.m
//  App
//
//  Created by Dejun Liu on 2017/8/25.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//

#import "NVJView.h"

@implementation NVJModel


@end

@implementation NVJListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithModels:(NSArray<NVJModel *> *) models
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray arrayWithArray:models];
    }
    return self;
}

@end

@interface NVJView ()

@end

@implementation NVJView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    METHOD_NOT_IMPLEMENTED();
}

- (void)updateUI {
    METHOD_NOT_IMPLEMENTED();
}

- (void)setModel:(NVJModel *)model {
    if (_model != model) {
        _model = model;
    }
//    [self updateUI];
}

- (NVJModel *)getModel {
    return _model;
}

@end
