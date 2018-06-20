//
//  NVJHorizontalItemView.h
//  App
//
//  Created by Dejun Liu on 2017/8/25.
//  Copyright © 2017年 Dejun Liu. All rights reserved.
//
/*
 NVJHorizontalItemView *v = [[NVJHorizontalItemView alloc] initWithFrame:CGRectMake(0, 64.0f, SCREEN_WIDTH, 100)];
 v.backgroundColor = HEX(0xefefef);
 v.delegate = self;
 
 //models
 NVJHorizontalItemModel *m = [[NVJHorizontalItemModel alloc] initWithPadding:UIEdgeInsetsMake(10, 10, 10, 10)
 itemSize:CGSizeMake((SCREEN_WIDTH-20)/5, 45)
 columnCount:5];
 m.rowSpace = 0;
 
 for (int i=0; i<7; i++) {
 {
 NVJHorizontalItem *item = [[NVJHorizontalItem alloc] initWithTitle:@"世界你好"
 image:[UIImage imageNamed:@"iocn_account_returnMoney"]
 selected:NO];
 item.autoAdjustButtonHeight = YES;
 item.highlightedBackgroundColor = [[UIColor whiteColor] convertToHSBwithBrighnessDelta:-0.1];
 item.space = 0;
 item.imageSpaceToTop = 0;
 item.titleSpaceToBottom = 5;
 [m.items addObject:item];
 }
 }
 
 [v setModel:m];
 [v updateUI];
 [self.view addSubview:v];
 */

#import "NVJView.h"
#import "NVJDelegateProtocol.h"

@interface NVJHorizontalItem : NVJModel

- (instancetype)initWithTitle:(NSString *) title
                        image:(UIImage *) image
                     selected:(BOOL) selected;

//必填
@property (nonatomic, copy)     NSString *title;
@property (nonatomic, strong)   UIImage *image;
@property (nonatomic, assign)   BOOL selected;                      //默认为NO
@property (nonatomic, assign)   BOOL disable;                       //默认为NO

//可选
@property (nonatomic, assign)   BOOL autoAdjustButtonHeight;        //自动计算图片上边距+图片+间距+文字+文字下边距;默认为NO；
@property (nonatomic, assign)   double space;                       //标题和图片之间间距     默认:0
@property (nonatomic, assign)   double imageSpaceToTop;             //图片到顶部距离        默认：0
@property (nonatomic, assign)   double titleSpaceToBottom;          //图片到顶部距离        默认：0
@property (nonatomic, strong)   UIImage *highlightedImage;          //点击时候的图片        默认:nil
@property (nonatomic, strong)   UIImage *selectedImage;             //点击时候的图片        默认:nil
@property (nonatomic, strong)   UIImage *disableImage;             //点击时候的图片        默认:nil
@property (nonatomic, strong)   UIFont *font;                       //文字字体             默认:系统字体12号
@property (nonatomic, strong)   UIColor *titleColor;                //文字颜色             默认:0x333333
@property (nonatomic, strong)   UIColor *titleSelectedColor;        //文字颜色             默认:0x333333
@property (nonatomic, strong)   UIColor *titleHighlightedColor;     //文字高亮颜色          默认:0x333333
@property (nonatomic, strong)   UIColor *titleDisableColor;         //文字高亮颜色          默认:0x333333
@property (nonatomic, strong)   UIColor *imageTintColor;            //图片着色             默认:nil
@property (nonatomic, strong)   UIColor *imageHighlightedTintColor; //图片着色             默认:nil
@property (nonatomic, strong)   UIColor *imageSelectedTintColor;    //图片着色             默认:nil
@property (nonatomic, strong)   UIColor *imageDisableTintColor;    //图片着色             默认:nil
@property (nonatomic, strong)   UIImage *backgroundImage;           //背景图片             默认:nil
@property (nonatomic, strong)   UIImage *backgroundSelectedImage;   //选中背景图           默认:nil
@property (nonatomic, strong)   UIImage *backgroundHighlightedImage;//高亮背景图           默认:nil
@property (nonatomic, strong)   UIColor *backgroundColor;           //图片着色             默认:nil
@property (nonatomic, strong)   UIColor *highlightedBackgroundColor;//图片着色             默认:nil
@property (nonatomic, strong)   NSURL *imageUrl;                    //按钮图片的url        默认:nil
@property (nonatomic, strong)   UIImage *imageUrlLoadingPlaceHolder;//按钮图片loading占位图 默认:nil
@property (nonatomic, assign)   double imageCornerRadius;           //图片的圆角           默认：0
@property (nonatomic, strong)   UIColor *imageBackgroundColor;      //图片背景色           默认：nil

@end

@interface NVJHorizontalItemModel : NVJModel

/**
 初始化视图模型

 @param padding 距离四边距离
 @param size 每个item大小
 @param columnCount 一行共有几列
 @return 实例
 */
- (instancetype)initWithPadding:(UIEdgeInsets) padding
                       itemSize:(CGSize) size
                    columnCount:(NSInteger) columnCount;

/**
 绘图的按钮距离四边的距离
 默认: (0,0,0,0)
 */
@property (nonatomic, assign)   UIEdgeInsets padding;

/**
 每个按钮对应的模型数组
 */
@property (nonatomic, strong)   NSMutableArray<NVJHorizontalItem *> *items;

/**
 每个按钮的大小
 默认：宽60 高50
 */
@property (nonatomic, assign)   CGSize itemSize;

/**
 每行显示几个按钮
 默认：2
 */
@property (nonatomic, assign)   NSInteger colCount;

/**
 行与行之间间距
 默认：5.0f
 */
@property (nonatomic, assign)   double rowSpace;

@end

@class NVJHorizontalItemView;
@protocol NVJHorizontalItemViewDelegate <NSObject>

@optional
- (void)NVJHorizontalItemViewRenderButton:(UIButton *) button model:(NVJHorizontalItem *) model index:(NSInteger) idx;
- (void)NVJHorizontalItemViewDidSelectedItem:(NVJHorizontalItem *) model button:(UIButton *) button;
- (void)NVJHorizontalItemView:(NVJHorizontalItemView *) view model:(NVJHorizontalItemModel *) model selectedIndex:(NSInteger) index;

@end

/**
 视图
 */
@interface NVJHorizontalItemView : NVJView

PP_DELEGATE(NVJHorizontalItemViewDelegate, delegate)
@property (nonatomic, strong)   NSMutableArray<UIButton *> *buttons;

/**
 model.autoAdjustButtonHeight设置为YES无效，YES时候为视图自动计算适配高度。
 此为计算固定高端不合适。

 @return 高度
 */
- (CGFloat)getHeight;

/**
 model.autoAdjustButtonHeight设置为YES无效，YES时候为视图自动计算适配高度。
 此为计算固定高端不合适。

 @param model <#model description#>
 @return <#return value description#>
 */
+ (CGFloat)getHeightWithModel:(NVJHorizontalItemModel *) model;

@end
