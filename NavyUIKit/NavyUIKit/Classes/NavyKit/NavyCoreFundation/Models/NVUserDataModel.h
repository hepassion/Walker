//
//  NVUserDataModel.h
//  Navy
//
//  Created by Jelly on 7/10/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NVDataModel.h"
#import "NVSerializedObjectProtocol.h"


typedef NS_ENUM(NSUInteger, NVUserStatus) {
    NVUserStatusNormal          = 01,
    NVUserStatusFreeze,
    NVUserStatusLogoff,
};

typedef NS_ENUM(NSUInteger, NVUserCustomerType) {
    NVUserCustomerTypeOnline        = 01,
    NVUserCustomerTypeOffline,
};


@interface NVUserDataModel : NVDataModel
<NVFundationSerializedObjectProtocol,
NVFundationDeserializedObjectProtocol>
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* deviceInfo;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString *accountantName;     //理财师名字
@property (nonatomic, assign) NSInteger showRefferCode;     //0:不可填写 1:新用户30日内可填写

@property (nonatomic, strong) NSString* mobile;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* identityNumber;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* hidName;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, assign) BOOL bankcardShortcut;        //充值页面判断是否绑卡
@property (nonatomic, assign) BOOL bankcardStatus;
@property (nonatomic, assign) BOOL identityStatus;
@property (nonatomic, assign) BOOL payPasswordStatus;
@property (nonatomic, assign) NVUserStatus status;
@property (nonatomic, assign) NVUserCustomerType customerType;

@property (nonatomic, strong) NSString* userSign;

@property (nonatomic, strong) NSArray* group;

@property (nonatomic, assign) BOOL      bankDepository;     //是否开启银行存管,YES表示需要app弹出 开通新网存管的提示框
@property (nonatomic, copy) NSString*   bankUserType;       //银行存管用户类型01:大陆身份证用户，02：港澳台用户，（为空新用户未实名认证）
@property (nonatomic, assign) BOOL      ventureStatus;      //风险评估状态
@property (nonatomic, strong) NSString* avaterPath;

@end
