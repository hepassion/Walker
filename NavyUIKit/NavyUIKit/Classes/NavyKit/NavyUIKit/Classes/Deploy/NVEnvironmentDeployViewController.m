//
//  NVEnvironmentDeployViewController.m
//  Navy
//
//  Created by Jelly on 9/16/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NVEnvironmentDeployViewController.h"
#import "NVEnvironmentDeployDataConstructor.h"
#import "NVTagTableViewCell.h"
#import "NVButtonTableViewCell.h"

@implementation NVEnvironment

- (instancetype)initWithTitle:(NSString *) title
                      ApiPath:(NSString *) apiPath
                       h5Path:(NSString *) h5Path
{
    self = [super init];
    if (self) {
        _apiPath = apiPath;
        _h5Path = h5Path;
        _title = title;
    }
    return self;
}

+ (NVEnvironment *) envWithTitle:(NSString *) title
                         ApiPath:(NSString *) apiPath
                          h5Path:(NSString *) h5Path
{
    return [[NVEnvironment alloc] initWithTitle:title
                                        ApiPath:apiPath
                                         h5Path:h5Path];
}

@end


@interface NVEnvironmentDeployViewController ()
<NVTableViewAdaptorDelegate,
NVButtonTableViewCellDelegate>
@property (nonatomic, strong) NVEnvironmentDeployDataConstructor* dataConstructor;
@end


@implementation NVEnvironmentDeployViewController

- (instancetype)initWithEnvs:(NSArray<NVEnvironment *> *) envs selectIndex:(NSInteger) index
{
    self = [super init];
    if (self) {
        self.envs = [NSMutableArray arrayWithArray:envs];
        self.indexOfSelected = index;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor   = COLOR_HM_WHITE_GRAY;
    
    CGRect frame            = self.uiTableView.frame;
    frame.size.height       -= NAVIGATIONBARHEIGHT +20;
    
    self.uiTableView.frame = frame;
}


- (NSString*) getNavigationTitle {
    return @"环境配置";
}


- (void) constructData {
    if (_dataConstructor == nil) {
        _dataConstructor = [[NVEnvironmentDeployDataConstructor alloc] init];
        _dataConstructor.viewControllerDelegate = self;
    }
    
    self.dataConstructor.envs = self.envs;
    
    [self.dataConstructor constructData];
    self.adaptor.items = self.dataConstructor.items;
    [self.uiTableView reloadData];
}

- (void)setIndexOfSelected:(NSInteger)indexOfSelected {
    [self.envs enumerateObjectsUsingBlock:^(NVEnvironment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    [self.envs objectAtIndex:indexOfSelected].selected = YES;
    [self constructData];
}

- (NSInteger)indexOfSelected {
    __block NSInteger index = 0;
    [self.envs enumerateObjectsUsingBlock:^(NVEnvironment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            index = idx;
        }
    }];
    return index;
}


#pragma mark - NVTableViewAdaptorDelegate
- (void) tableView:(UITableView *)tableView didSelectObject:(id<NVTableViewCellItemProtocol>)object rowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellType = object.cellType;
    
    if (![cellType containsString:@"cell.type.env."]) {
        return;
    }
    
    NSInteger index = [[cellType stringByReplacingOccurrencesOfString:@"cell.type.env." withString:@""] integerValue];
    NVEnvironment *env = [self.envs objectAtIndex:index];
    env.selected = YES;
    [self.envs enumerateObjectsUsingBlock:^(NVEnvironment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != env) {
            obj.selected = NO;
        }
    }];
    
    [self constructData];
}

- (NVEnvironment *)curEnv {
    __block NVEnvironment *env = nil;
    [self.envs enumerateObjectsUsingBlock:^(NVEnvironment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            env = obj;
        }
    }];
    
    return env;
}


#pragma mark - NVButtonTableViewCellDelegate
- (void) didClickButtonTableViewCell:(NVButtonTableViewCell *)cell {
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(environmentDeployViewController:didSelectEnvironment:)]) {
        [self.delegate environmentDeployViewController:self
                                  didSelectEnvironment:self.curEnv];
    } else {
        
    }
}

@end



