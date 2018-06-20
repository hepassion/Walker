//
//  NVErrorDataModel.h
//  NavyCoreFoundation
//
//  Created by Jelly on 6/17/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NVDataModel.h"
#import <UIKit/UIKit.h>
#import "NVSerializedObjectProtocol.h"


UIKIT_EXTERN NSString* const kResponseErrorTypeNeedLogin;
UIKIT_EXTERN NSString* const kResponseErrorTypeFail;
UIKIT_EXTERN NSString* const kResponseErrorTypeInvalid;
UIKIT_EXTERN NSString* const kResponseErrorTypeException;
UIKIT_EXTERN NSString* const kResponseErrorTypeError;
UIKIT_EXTERN NSString* const kResponseErrorTypeDataPurview;
UIKIT_EXTERN NSString* const kResponseErrorTypeUpgrade;
UIKIT_EXTERN NSString* const kResponseErrorTypeUpgradeForce;
UIKIT_EXTERN NSString* const kResponseErrorTypeRedirection;


@interface NVErrorDataModel : NVDataModel
@property (nonatomic, assign) NSInteger code;           //状态码
@property (nonatomic, strong) NSString* error;          //错误消息
@property (nonatomic, strong) NSString* message;        //成功消息
@property (nonatomic, strong) NSString* errorType;      //错误类型
@property (nonatomic, strong) NSString* redirectUrl;    //维护期间，重定向URL
@end


@interface NVExceptionDataModel : NVDataModel

@end






@interface NVSuccessDataModel : NVDataModel
<NVFundationSerializedObjectProtocol,
NVFundationDeserializedObjectProtocol>

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, assign) BOOL result;
@end


