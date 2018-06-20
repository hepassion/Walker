//
//  NVChatTableViewCell.h
//  NavyUIKit
//
//  Created by Dejun Liu on 2017/9/9.
//  Copyright © 2017年 Deju Liu. All rights reserved.
//

#import "NVTableViewLineCell.h"
#import "NVLabel.h"

typedef enum : NSUInteger {
    NVChatViewTypeLeft,
    NVChatViewTypeRight,
} NVChatViewType;

typedef enum : NSUInteger {
    NVChatTableViewCellTypeUser,    //单聊    单聊不会显示用户名
    NVChatTableViewCellTypeGroup,   //群聊    群聊会显示用户名
} NVChatTableViewCellType;

@interface NVChatDataModel : NVLineDataModel

@property (nonatomic, strong) NSURL *headImageURL;
@property (nonatomic, strong) UIImage *headImage;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) id message;
@property (nonatomic, assign) NVChatViewType type;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *messageBackgroundColor;
@property (nonatomic, assign) NVChatTableViewCellType chatCellType;  //默认 群聊

@end

@interface NVChatView : UIView

@property (nonatomic, assign) NVChatViewType type;  //default: NVChatViewTypeLeft
@property (nonatomic, strong) id message;
@property (nonatomic, strong) NVLabel *messageLabel;
@property (nonatomic, strong) UIColor *messageBackgroundColor;

/**
 计算宽度 计算消息高度

 @param message <#message description#>
 @return <#return value description#>
 */
+ (CGFloat) heightForMessage:(NSString *)message width:(CGFloat) width;
- (NSAttributedString *)attrMessage:(NSString *) message;

@end

@class NVChatTableViewCell;
@protocol NVChatTableViewCellDelegate <NSObject>

- (void)chatTableViewCell:(NVChatTableViewCell *) cell didClickHeadImageViewWithModel:(NVChatDataModel *) model;

@end

@interface NVChatTableViewCell : NVTableViewLineCell

PP_DELEGATE(NVChatTableViewCellDelegate, delegate);

@end
