//
//  NVHyperlinkLabel.h
//  Navy
//
//  Created by Jelly on 7/12/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NVLabel.h"


@protocol NVHyperlinkLabelDelegate;


@interface NVHyperlinkLabel : NVLabel
@property (nonatomic, strong) NSMutableArray* array;
@property (nonatomic, assign) id<NVHyperlinkLabelDelegate> delegate; // 通过delegate触发URL回调
@property (nonatomic, copy) void(^touchUrlBlock)(NSString *urlPath); // 通过Block触发URL回调

- (void) clear;
- (void) addPlainText:(NSString*)plainText;
- (void) addAttributedPlainText:(NSAttributedString *)attributedPlainText;
- (void) addHyperlink:(NSString*)hyperlink withUrl:(NSString*)urlPath;
- (void) addAttributedHyperlink:(NSAttributedString*)attributedHyperlink withUrl:(NSString*)urlPath;
@end


@protocol NVHyperlinkLabelDelegate <NSObject>
- (void) hyperlinkLabel:(NVHyperlinkLabel*)label touchUrl:(NSString*)urlPath;
@end



