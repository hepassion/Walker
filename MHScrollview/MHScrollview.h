//
//  MHScrollview.h
//  BannerStop
//
//  Created by minghe on 17/3/7.
//  Copyright © 2017年 C. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^imageClick)(NSInteger);


@interface MHScrollview : UIView

@property (nonatomic, strong)NSMutableArray *imageUrls;

@property (nonatomic, copy)imageClick imageClickBlock;
- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSMutableArray *)imageUrls;



@end
