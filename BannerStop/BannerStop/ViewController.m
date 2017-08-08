//
//  ViewController.m
//  BannerStop
//
//  Created by minghe on 17/3/7.
//  Copyright © 2017年 C. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MHScrollview.h"
#import "CycleScrollView.h"
#import "AppDelegate.h"
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getImageUrl];
    [self getData];
    self.dic = [NSMutableDictionary new];
    
    MHScrollview *mhScrollview = [[MHScrollview alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) imageUrls:self.imageUrls];
     mhScrollview.imageClickBlock = ^(NSInteger index){
        NSLog(@"%ld",index);
         
        
    };
   [self.view addSubview:mhScrollview];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame =CGRectMake(0, 200, ScreenWidth, 100);
    [button setTitle:@"fgggggt" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hghgghghhghg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 300, ScreenWidth, [UIScreen mainScreen].bounds.size.height-200) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    [self.view addSubview:self.tableView];
   
        
    
    
}

- (void)hghgghghhghg{
    UITableViewCell *cell = [self.dic objectForKey:[NSNumber numberWithInteger:0]];
    NSLog(@"%@", cell);
    
}


-  (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.dic setObject:cell forKey:[NSNumber numberWithInteger:indexPath.row]];
    
    NSURLRequestUseProtocolCachePolicy
    
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return 30.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

- (void)getData{
    self.dataArray = [NSMutableArray new];
    for (int i = 0; i < 100; i++) {
        NSString *str = [NSString stringWithFormat:@"number= %d",i];
        [self.dataArray addObject:str];
    }
}

- (void)getImageUrl{
    [self.imageUrls addObject:@"http://www.flyertea.com/newcomment/Data/Uploads/Appbanner/20161230/1483087006.jpg"];
    
    [self.imageUrls addObject:@"http://www.flyertea.com/newcomment/Data/Uploads/Appbanner/20161227/1482809076.jpg"];
    [self.imageUrls addObject:@"http://www.flyertea.com/newcomment/Data/Uploads/Appbanner/20170103/1483409422.jpg"];
    [self.imageUrls addObject:@"http://www.flyertea.com/newcomment/Data/Uploads/Appbanner/20170104/1483492242.jpg"];
    [self.imageUrls addObject:@"http://www.flyertea.com/newcomment/Data/Uploads/Appbanner/20161219/1482110191.jpg"];
    [self.imageUrls addObject:@"http://www.flyertea.com/newcomment/Data/Uploads/Appbanner/20161223/1482457448.png"];
}

- (NSMutableArray *)imageUrls{
    if (_imageUrls == nil) {
        _imageUrls = [NSMutableArray new];
    }return _imageUrls;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
