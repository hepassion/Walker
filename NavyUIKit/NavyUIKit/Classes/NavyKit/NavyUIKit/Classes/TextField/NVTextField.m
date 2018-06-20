//
//  NVTextField.m
//  NavyUIKit
//
//  Created by Jelly on 6/23/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NVTextField.h"
#import "Macros.h"

@interface NVTextField () {
    UIEdgeInsets _tableViewEdgeInsets;
    BOOL _keyboardShowing;
}
- (UIView*) generateToolbar;
- (void) doneButtonDidPressed:(id)sender;
- (void) notifierKeyboardWillShow:(NSNotification*)notification;
- (void) notifierKeyboardWillHide:(NSNotification*)notification;
@end


@implementation NVTextField

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifierKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifierKeyboardWillHide:) name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        self.inputAccessoryView = [self generateToolbar];
    }
    return self;
}

//控制placeHolder的颜色、字体
- (void) drawPlaceholderInRect:(CGRect)rect
{
    [_placeHolderColor setFill];


    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = self.textAlignment;
    NSDictionary* attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          style, NSParagraphStyleAttributeName,
                          self.font, NSFontAttributeName,
                          _placeHolderColor, NSForegroundColorAttributeName,
                          nil];
    [[self placeholder] drawInRect:rect withAttributes:attr];


}

//控制placeHolder的位置，左右缩20
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGSize size = [self.placeholder sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil]];
    
    CGFloat systemVersion     = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGFloat insetY;
    //iOS11之前textfield的占位label无法设置y值，无论设置y为多少，都是会居中显示
    if (systemVersion >= 11) {
        //iOS11以后已经可以调整占位label的y值
        insetY = (bounds.size.height - size.height) / 2;
    }else{
        insetY = 0;
    }
    
    return CGRectMake(FIT6(10),
                      insetY,
                      bounds.size.width - FIT6(60),
                      size.height);
}

//文本的位置改变
//- (CGRect)textRectForBounds:(CGRect)bounds{
//    CGRect inset = CGRectMake(FIT6(10),
//                              0,
//                              bounds.size.width - FIT6(20),
//                              bounds.size.height);
//
//    return inset;
//}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(FIT6(10),
                              0,
                              bounds.size.width - FIT6(60),
                              bounds.size.height);
    return inset;
}

- (BOOL) resignFirstResponder {
    [super resignFirstResponder];
    
    return YES;
}


- (UIView*) generateToolbar {
    UIView* toolbar         = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    toolbar.backgroundColor = [UIColor whiteColor];
    
    UIView* topLine             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, toolbar.bounds.size.width, 0.5)];
    topLine.backgroundColor     = [UIColor lightGrayColor];
    topLine.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
    [toolbar addSubview:topLine];
    
    UIButton *finishedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [finishedButton setTitle:@"完成" forState:UIControlStateNormal];
    finishedButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [finishedButton addTarget:self action:@selector(doneButtonDidPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    finishedButton.frame = CGRectMake(toolbar.frame.size.width - 64 - 10, 0, 64, 44);
    finishedButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [finishedButton setTitleColor:COLOR_HM_THEME
                         forState:UIControlStateNormal];
    
    [toolbar addSubview:finishedButton];
    [topLine bringSubviewToFront:topLine];
    return toolbar;
}

- (void) doneButtonDidPressed:(id)sender {
    if (self.doneDelegate && [self.doneDelegate respondsToSelector:@selector(doneButtonDidPressedDelegate:)]) {
        [self.doneDelegate doneButtonDidPressedDelegate:sender];
    }
    [self resignFirstResponder];
}


- (BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:) ||
        action == @selector(paste:) ||
        action == @selector(select:) ||
        action == @selector(selectAll:)) {
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}


- (void) notifierKeyboardWillShow:(NSNotification*)notification {
    
    UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView* firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if (![firstResponder isEqual:self]) {
        return;
    }
    
    if (_keyboardShowing) {
        return;
    }else {
        _keyboardShowing = YES;
    }
    
    // find table view
    UIView* subView = self.superview;
    while (subView != nil) {
        if ([subView.superview isKindOfClass:[UITableView class]]) {
            subView = subView.superview;
            break;
        }
        subView = subView.superview;
    }
    
    // set content bottom offset
    if ([subView isKindOfClass:[UITableView class]]) {
        UITableView* tableView = (UITableView*)subView;
        _tableViewEdgeInsets = tableView.contentInset;
        
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        NSDictionary *info                   = notification.userInfo;
        CGRect screenFrame                   = [tableView.superview convertRect:tableView.frame
                                                                         toView:[UIApplication sharedApplication].keyWindow];
        CGFloat tableViewBottomOnScreen      = screenFrame.origin.y + screenFrame.size.height;
        CGFloat tableViewGap                 = screenHeight - tableViewBottomOnScreen;
        CGSize keyboardSize                  = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets           = tableView.contentInset;
        contentInsets.bottom                 = keyboardSize.height - tableViewGap;
        
        CGFloat animationDuration            = ((NSNumber *)[info objectForKey:UIKeyboardAnimationDurationUserInfoKey]).doubleValue;
        NSUInteger animationCurve            = ((NSNumber *)[info objectForKey:UIKeyboardAnimationCurveUserInfoKey]).intValue;
        
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:animationCurve
                         animations: ^{
                             tableView.contentInset          = contentInsets;
                             tableView.scrollIndicatorInsets = contentInsets;
                         }
         
                         completion:nil];
    }
}

- (void) notifierKeyboardWillHide:(NSNotification*)notification {
    
    if (!_keyboardShowing) {
        return;
    }else {
        _keyboardShowing = NO;
    }
    
    // find table view
    UIView* subView = self.superview;
    while (subView != nil) {
        if ([subView.superview isKindOfClass:[UITableView class]]) {
            subView = subView.superview;
            break;
        }
        subView = subView.superview;
    }
    
    // set content bottom offset
    if ([subView isKindOfClass:[UITableView class]]) {
        UITableView* tableView = (UITableView*)subView;
        
        UIEdgeInsets contentInsets           = _tableViewEdgeInsets;
        NSDictionary *info                   = notification.userInfo;
        
        CGFloat animationDuration            = ((NSNumber *)[info objectForKey:UIKeyboardAnimationDurationUserInfoKey]).doubleValue;
        NSUInteger animationCurve            = ((NSNumber *)[info objectForKey:UIKeyboardAnimationCurveUserInfoKey]).intValue;
        
        [UIView animateWithDuration:animationDuration
                              delay:0.25f
                            options:animationCurve
                         animations: ^{
                             tableView.contentInset          = contentInsets;
                             tableView.scrollIndicatorInsets = contentInsets;
                         }
                         completion:^(BOOL finished) {
                             _tableViewEdgeInsets = UIEdgeInsetsZero;
                         }];
        
    }
}


@end

