//
//  UIViewController+Helper.m
//  NavyUIKit
//
//  Created by Dejun Liu on 2017/3/29.
//  Copyright © 2017年 Deju Liu. All rights reserved.
//

#import "UIViewController+Helper.h"

@implementation UIViewController (Helper)

- (void)pushViewControllerClassString:(NSString *) classString {
    [self.navigationController pushViewController:[NSClassFromString(classString) new] animated:YES];
}

@end
