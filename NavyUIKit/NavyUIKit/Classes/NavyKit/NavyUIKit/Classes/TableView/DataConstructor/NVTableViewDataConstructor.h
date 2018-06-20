//
//  NVTableViewDataConstructor.h
//  NavyUIKit
//
//  Created by Jelly on 6/21/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVDataModel.h"
#import "NVIndexPathArray.h"
#import <DJMacros/DJMacro.h>
#import "NVTableViewCell.h"

@interface NVTableViewDataConstructor : NSObject
@property (nonatomic, strong) NVIndexPathArray * items;
@property (nonatomic, assign) NSInteger indexOfHighlight;
@property (nonatomic, assign) UIViewController* viewControllerDelegate;

- (void) constructData;
- (void) constructData:(void (^)(NSString *, NVDataModel *))reactBlock before:(void(^)(void))beforeBlock;

- (NVDataModel *) modelByCellType:(NSString*)cellType;
- (NVTableViewCell *) cellByCellType:(NSString*)cellType;

- (id) valueForCellType:(NSString*)cellType;
- (void) updateHighlightCell:(CGPoint)offset;

- (void) indexPathByCellType:(NSString*)cellType block:(void (^)(NSIndexPath* indexPath))block;

- (void) refreshValueForCellType:(NSString*)cellType;
- (void) refreshValueForCellType:(NSString *)cellType block:(void (^)(NVDataModel* item))block;

/*
 获取对应type的dataModel
 请使用- (NVDataModel *) modelByCellType:(NSString*)cellType 替代！
 */
- (NVDataModel*) itemByCellType:(NSString*)cellType;

@end



@interface NVTableViewDataConstructor (Index)
@property (nonatomic, strong) NSArray* arrayKeys;
- (void) constructIndex;
@end

