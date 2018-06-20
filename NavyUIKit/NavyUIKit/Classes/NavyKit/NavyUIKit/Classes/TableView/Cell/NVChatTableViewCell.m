//
//  NVChatTableViewCell.m
//  NavyUIKit
//
//  Created by Dejun Liu on 2017/9/9.
//  Copyright © 2017年 Deju Liu. All rights reserved.
//

#import "NVChatTableViewCell.h"
#import "NVLabel.h"
#import <DJMacros/DJMacro.h>
#import "Macros.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define NVChatMessageTextWidth  FIT6P(867.0f)
#define NVChatViewMessageFont   nvNormalFontWithSize(14.0f)
#define NVChatViewMinHeight     14.0f

@implementation NVChatDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.upperLineHidden = YES;
        self.lowerLineHidden = YES;
        self.chatCellType = NVChatTableViewCellTypeGroup;
    }
    return self;
}

@end

@interface NVChatView ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, assign) UIEdgeInsets bgEdge;
@property (nonatomic, assign) UIEdgeInsets padding;

@end

@implementation NVChatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = NVChatViewTypeRight;
        self.messageBackgroundColor = self.type == NVChatViewTypeLeft?HEX(0xffffff):HEX(0xa0e75a);
        
        //2.消息内容
        NVLabel *messageLabel = [[NVLabel alloc] initWithFrame:self.bounds];
        messageLabel.verticalAlignment = NVLabelVerticalAlignmentTop;
        messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        messageLabel.numberOfLines = 0;
        messageLabel.font = NVChatViewMessageFont;
        
        self.messageLabel = messageLabel;
        [self addSubview:messageLabel];
        
    }
    return self;
}

- (void)setMessageBackgroundColor:(UIColor *)messageBackgroundColor {
    if (_messageBackgroundColor != messageBackgroundColor) {
        _messageBackgroundColor = messageBackgroundColor;
        
        if (self.bgImageView == nil) {
            //1.背景
            UIImageView * bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
            bgImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            self.bgImageView = bgImgView;
            [self addSubview:bgImgView];
            [self sendSubviewToBack:bgImgView];
        }
        
        //设置背景平铺图
        UIEdgeInsets edge = self.type == NVChatViewTypeLeft?UIEdgeInsetsMake(24, 14, 6, 6):UIEdgeInsetsMake(24, 6, 6, 14);
        self.bgEdge = edge;
        
        NSString *imgName = self.type == NVChatViewTypeLeft?@"chat_left_bg_night.9":@"chat_right_bg.9";
        UIColor *color = messageBackgroundColor;
        UIImage * frameImg1 = [[UIImage imageNamed:imgName] nv_imageWithColor:color];
        frameImg1 = [frameImg1 resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
        [self.bgImageView setImage:frameImg1];
        [self sendSubviewToBack:self.bgImageView];
        
        [self layoutSubviews];
    }
}

- (void)setType:(NVChatViewType)type {
    if (_type != type) {
        _type = type;
    }
    
    self.padding = self.type == NVChatViewTypeLeft?UIEdgeInsetsMake(8, 15, 8, 10):UIEdgeInsetsMake(8, 10, 8, 15);
    
    if (type == NVChatViewTypeRight) {
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
    } else if (type == NVChatViewTypeLeft) {
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.messageLabel.left = self.padding.left;
    self.messageLabel.top = self.padding.top;
    self.messageLabel.width = self.width - self.padding.left - self.padding.right;
    
    double minHeight = NVChatViewMinHeight;
    
    double messageHeight = [self.messageLabel.attributedText boundingRectWithSize:CGSizeMake(self.messageLabel.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    if (messageHeight < minHeight) {
        messageHeight = minHeight;
    } else {
        self.messageLabel.height = messageHeight;
    }
    
    self.height = messageHeight + self.padding.top + self.padding.bottom;
}

- (NSAttributedString *)attrMessage:(NSString *) message {
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.lineSpacing = 2.0f;
    pStyle.alignment                = self.messageLabel.textAlignment;
    
    NSAttributedString *msgAttr = [[NSAttributedString alloc] initWithString:message attributes:@{NSParagraphStyleAttributeName:pStyle,ATT_FONT:self.messageLabel.font}];
    return msgAttr;
}

- (void)setMessage:(id)message {
    if (_message != message) {
        _message = message;
    }

    
    self.messageLabel.attributedText = [self attrMessage:message];
    [self layoutSubviews];
}

+ (CGFloat) heightForMessage:(NSString *)message width:(CGFloat) width {
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.lineSpacing = 2.0f;
    pStyle.alignment                = NSTextAlignmentLeft;
    
    NSAttributedString *msgAttr = [[NSAttributedString alloc] initWithString:message attributes:@{NSParagraphStyleAttributeName:pStyle,ATT_FONT:NVChatViewMessageFont}];
    
    CGFloat textWidth = width - 10 - 15;
    
    double minHeight = NVChatViewMinHeight;
    
    double messageHeight = [msgAttr boundingRectWithSize:CGSizeMake(textWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    if (messageHeight < minHeight) {
        messageHeight = minHeight;
    }
    
    return messageHeight + 8 + 8;
}

@end

@interface NVChatTableViewCell ()

PP_STRONG(NVChatView, chatView)
PP_STRONG(UIImageView, headImageView)
PP_STRONG(UILabel, usernameLabel)

@end

@implementation NVChatTableViewCell

+ (CGFloat)heightForCell {
    return 164.0f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (NVChatView *)chatView {
    if (_chatView == nil) {
        NVChatView *label = [[NVChatView alloc] initWithFrame:CGRectZero];
        label.top = 10.0f;
        label.left = 10.f;
        label.width = self.contentView.width-50;
        label.height = 140.0f;
        self.chatView = label;
        [self.contentView addSubview:label];
    }
    
    return _chatView;
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.width = FIT6P(120);
        _headImageView.height = _headImageView.width;
        _headImageView.top = FIT6P(20.0f);
        _headImageView.userInteractionEnabled = YES;
        WEAK_SELF;
        [_headImageView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            if (_delegate &&
                [_delegate respondsToSelector:@selector(chatTableViewCell:didClickHeadImageViewWithModel:)]) {
                [_delegate chatTableViewCell:weakself
              didClickHeadImageViewWithModel:(NVChatDataModel *)self.item];
            }
        }];
        [self.contentView addSubview:_headImageView];
    }
    
    return _headImageView;
}

- (UILabel *)usernameLabel {
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _usernameLabel.height = FIT6P(36);
        _usernameLabel.width = FIT6P(280);
        _usernameLabel.top = FIT6P(20.0f);
        _usernameLabel.font = nvNormalFontWithSize(11.f);
        _usernameLabel.textColor = HEX(0x737373);
        [self.contentView addSubview:_usernameLabel];
    }
    
    return _usernameLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setObject:(NVChatDataModel *)object {
    [super setObject:object];
    
    if (object.chatCellType == NVChatTableViewCellTypeGroup) {
        self.usernameLabel.height = FIT6P(36);
        self.usernameLabel.hidden = NO;
        self.chatView.top = self.usernameLabel.bottom+FIT6P(10.0f);
    } else if (object.chatCellType == NVChatTableViewCellTypeUser) {
        self.usernameLabel.height = 0;
        self.usernameLabel.hidden = YES;
        self.chatView.top = self.usernameLabel.bottom+0;
    }
    
    if (object.type == NVChatViewTypeLeft) {
        self.headImageView.left = FIT6P(30.0f);
        self.usernameLabel.left = self.headImageView.right+FIT6P(30.0f);
        self.chatView.left = self.headImageView.right+FIT6P(14.0f);
        self.chatView.width = NVChatMessageTextWidth;
    } else {
        self.headImageView.right = self.contentView.width-FIT6P(30.0f);
        self.usernameLabel.right = self.headImageView.left-FIT6P(30.0f);
        self.usernameLabel.textAlignment = NSTextAlignmentRight;
        self.chatView.width = NVChatMessageTextWidth;
        self.chatView.right = self.headImageView.left-FIT6P(14.0f);
    }
    
    CGFloat msgHeight = [NVChatView heightForMessage:object.message width:NVChatMessageTextWidth];
    if (msgHeight < 35.0f) {
        
        CGFloat textWidth = [[self.chatView attrMessage:object.message] boundingRectWithSize:CGSizeMake(10000, self.chatView.messageLabel.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.width;
        
        CGFloat chatViewWidth = textWidth+self.chatView.padding.left+self.chatView.padding.right;
        self.chatView.width = chatViewWidth;
        if (object.type == NVChatViewTypeLeft) {
            self.chatView.left = self.headImageView.right+FIT6P(14.0f);
        } else {
            self.chatView.right = self.headImageView.left-FIT6P(14.0f);
        }
    }
    
    self.chatView.type = object.type;
    self.chatView.message = object.message;
    self.usernameLabel.text = object.username;
    if (object.headImageURL) {
        [self.headImageView sd_setImageWithURL:object.headImageURL];
    } else {
        self.headImageView.image = object.headImage;
    }
    
    if (object.backgroundColor) {
        self.contentView.backgroundColor = object.backgroundColor;
    } else {
        self.contentView.backgroundColor = HEX(0xebebeb);
    }
    
    if (object.messageBackgroundColor) {
        self.chatView.messageBackgroundColor = object.messageBackgroundColor;
    } else {
        self.chatView.messageBackgroundColor = HEX(0xa0e75a);
    }
    
    self.delegate = object.delegate;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(NVChatDataModel *)object {
    CGFloat msgHeight = [NVChatView heightForMessage:object.message width:NVChatMessageTextWidth];
    CGFloat height = msgHeight;
    if (object.chatCellType == NVChatTableViewCellTypeGroup) {
        height += FIT6P(20.0f)+FIT6P(36)+10.0f; //加上用户名高度
    } else if (object.chatCellType == NVChatTableViewCellTypeUser) {
        height += FIT6P(20.0f);
    }
    return height;
}



@end
