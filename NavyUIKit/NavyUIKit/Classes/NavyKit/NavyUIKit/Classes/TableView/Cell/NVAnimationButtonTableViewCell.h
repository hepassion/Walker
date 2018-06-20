//
//  NVAnimationButtonTableViewCell.h
//  Navy
//
//  Created by Jelly on 8/25/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NavyUIKit.h"
#import "NVButtonTableViewCell.h"



@interface NVAnimationButtonDataModel : NVButtonDataModel
@property (nonatomic, strong) NSString* normalTitle;
@property (nonatomic, strong) NSString* loadingTitle;
@property (nonatomic, strong) NSString* completeTitle;
@property (nonatomic, strong) NSString* failureTitle;
@end




typedef NS_ENUM(NSUInteger, NVAnimationButtonState) {
    NVAnimationButtonStateNormal,
    NVAnimationButtonStateLoading,
    NVAnimationButtonStateComplete,
    NVAnimationButtonStateFailure,
    NVAnimationButtonStateRestore,
};

@protocol NVAnimationButtonTableViewCellDelegate;


@interface NVAnimationButtonTableViewCell : NVTableViewNullCell
@property (nonatomic, assign) id<NVAnimationButtonTableViewCellDelegate> delegate;
@property (nonatomic, assign) NVAnimationButtonState state;
- (void) startLoadingAnimation; //加载动画
- (void) startCompleteAnimation;//完成动画
- (void) startFailureAnimation; //失败动画
- (void) restore;               //恢复正常状态
@end


@protocol NVAnimationButtonTableViewCellDelegate <NSObject>
- (BOOL) willStartLoadingAtAnimationButtonTableViewCell:(NVAnimationButtonTableViewCell*)cell;
- (void) animationButtonTableViewCell:(NVAnimationButtonTableViewCell*)cell didChangeState:(NVAnimationButtonState)state;
@end



