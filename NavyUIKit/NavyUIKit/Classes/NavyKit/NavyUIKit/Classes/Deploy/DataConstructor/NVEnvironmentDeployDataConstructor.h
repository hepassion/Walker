//
//  NVEnvironmentDeployDataConstructor.h
//  Navy
//
//  Created by Jelly on 9/16/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NavyUIKit.h"

@class NVEnvironment;
@interface NVEnvironmentDeployDataConstructor : NVTableViewDataConstructor
@property (nonatomic, strong) NSString* typeOfSelection;

@property (nonatomic ,strong) NSMutableArray<NVEnvironment *> *envs;
@end
