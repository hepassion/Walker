//
//  MHScrollview.m
//  BannerStop
//
//  Created by minghe on 17/3/7.
//  Copyright © 2017年 C. All rights reserved.
//

#import "MHScrollview.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define ImageWidth self.bounds.size.width
#define ImageHeight self.bounds.size.height

@interface MHScrollview()<UIScrollViewDelegate>

@property (nonatomic, strong)  UIScrollView *scrollview;
@property (nonatomic,strong)   UIImageView *leftImage;
@property (nonatomic,strong)   UIImageView *middleImage;
@property (nonatomic,strong)   UIImageView *rightImage;
@property (nonatomic,assign)   NSInteger currentIndex;
@property (nonatomic, strong)  NSTimer *timer;


@end

@implementation MHScrollview

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSMutableArray *)imageUrls{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.imageUrls = imageUrls;
        [self initScrollView];
        [self initTimer];
        
        
    }
    return self;
}

- (void)initScrollView{
    
    self.scrollview.contentOffset = CGPointMake(ImageWidth, 0);
    [self.scrollview addSubview:self.leftImage];
    [self.scrollview addSubview:self.middleImage];
    [self.scrollview addSubview:self.rightImage];
    [self addSubview:_scrollview];
    self.currentIndex = 0;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if (currentIndex == self.imageUrls.count) {
        _currentIndex = 0;
        
    }
    else if (currentIndex == -1){
        _currentIndex = self.imageUrls.count -1 ;
    }
    
    NSString *leftUrl,*middleurl,*rightUrl;
    leftUrl = self.imageUrls[_currentIndex-1>0?_currentIndex-1:self.imageUrls.count-1];
    middleurl = self.imageUrls[_currentIndex];
    rightUrl = self.imageUrls[_currentIndex+1 >= self.imageUrls.count ? 0:_currentIndex+1];
    

    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:leftUrl]];
    [self.middleImage sd_setImageWithURL:[NSURL URLWithString:middleurl]];
    [self.rightImage sd_setImageWithURL:[NSURL URLWithString:rightUrl]];
}

- (void)timerFired:(NSTimer *)timer{
   [self.scrollview setContentOffset:CGPointMake(self.scrollview.contentOffset.x + ImageWidth, 0) animated:YES];
}

#pragma mark scrllview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX >= 2 * ImageWidth) {
        [scrollView setContentOffset:CGPointMake(ImageWidth, 0) animated:NO];
        self.currentIndex  = self.currentIndex + 1;

    }
    else if (offsetX <= 0){
        [scrollView setContentOffset:CGPointMake(ImageWidth, 0) animated:NO];
        self.currentIndex  = self.currentIndex  - 1;

    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.timer.fireDate = [NSDate distantFuture];
    //dispatch_suspend(self.gcdTimer);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
    //    dispatch_resume(self.gcdTimer);

}

- (void)initTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
    
    
//    dispatch_queue_t queue = dispatch_get_main_queue();
//    self.gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
//    uint64_t interval = (uint64_t)(3.0 * NSEC_PER_SEC);
//    dispatch_source_set_timer(self.gcdTimer, start, interval, 0);
//    dispatch_source_set_event_handler(self.gcdTimer, ^{
//        NSLog(@"%@",[NSDate date]);
//        [self.scrollview setContentOffset:CGPointMake(self.scrollview.contentOffset.x + ImageWidth, 0) animated:YES];
//    });
//    dispatch_resume(self.gcdTimer);
    
}
#pragma mark lazy loading

- (UIScrollView *)scrollview{
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc]initWithFrame:self.bounds];;
        _scrollview.contentSize = CGSizeMake(ImageWidth * 3, ImageHeight);
        _scrollview.delegate = self;
        _scrollview.pagingEnabled = YES;
     //   _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.userInteractionEnabled = YES;
        
    }
    return _scrollview;
}

- (void)kkkkkkk:(UIGestureRecognizer *)ges {
    self.imageClickBlock(3);
}

- (UIImageView *)leftImage{
    if (_leftImage == nil) {
       _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
        _leftImage.userInteractionEnabled = YES;
        
        [_leftImage addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(kkkkkkk:)]];

    }
    return _leftImage;
}

- (UIImageView *)middleImage{
    if (_middleImage == nil) {
        _middleImage = [[UIImageView alloc]initWithFrame:CGRectMake(ImageWidth, 0, ImageWidth, ImageHeight)];
        _middleImage.userInteractionEnabled = YES;
        [_middleImage addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(kkkkkkk:)]];
        

    }return _middleImage;
}

- (UIImageView *)rightImage{
    if (_rightImage == nil) {
        _rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(2*ImageWidth, 0, ImageWidth, ImageHeight)];
        _rightImage.userInteractionEnabled = YES;
        
        [_rightImage addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(kkkkkkk:)]];
        

    }
    return _rightImage;
}

@end
