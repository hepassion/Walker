//
//  NVEnvironmentDeployViewController.h
//  Navy
//
//  Created by Jelly on 9/16/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NavyUIKit.h"

@interface NVEnvironment : NSObject

@property (nonatomic ,strong) NSString *title;
@property (nonatomic, strong) NSString *apiPath;
@property (nonatomic, strong) NSString *h5Path;
@property (nonatomic, assign) BOOL selected;

+ (NVEnvironment *) envWithTitle:(NSString *) title
                         ApiPath:(NSString *) apiPath
                            h5Path:(NSString *) h5Path;

@end

@protocol NVEnvironmentDeployViewControllerDelegate;


@interface NVEnvironmentDeployViewController : NVTableViewController

@property (nonatomic, strong) NSMutableArray<NVEnvironment *> *envs;
@property (nonatomic, strong) NVEnvironment *curEnv;
@property (nonatomic, assign) NSInteger indexOfSelected;
@property (nonatomic, assign) id<NVEnvironmentDeployViewControllerDelegate> delegate;

- (instancetype)initWithEnvs:(NSArray<NVEnvironment *> *) envs
                 selectIndex:(NSInteger) index;

@end


@protocol NVEnvironmentDeployViewControllerDelegate <NSObject>
- (void) environmentDeployViewController:(NVEnvironmentDeployViewController*)viewController
                    didSelectEnvironment:(NVEnvironment*)environment;
@end

