//
//  NVUserDataModel.m
//  Navy
//
//  Created by Jelly on 7/10/15.
//  Copyright (c) 2015 Steven.Lin. All rights reserved.
//

#import "NVUserDataModel.h"

@implementation NVUserDataModel


- (id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            self.userId             = [[dictionary nvObjectForKey:@"userId"] stringValue];
            self.userName           = [dictionary nvObjectForKey:@"userName"];
            self.token              = [dictionary nvObjectForKey:@"token"];
            self.deviceInfo         = [dictionary nvObjectForKey:@"deviceInfo"];
            
            self.mobile             = [dictionary nvObjectForKey:@"mobile"];
            self.email              = [dictionary nvObjectForKey:@"email"];
            self.identityNumber     = [dictionary nvObjectForKey:@"identityNumber"];
            self.name               = [dictionary nvObjectForKey:@"name"];
            self.address            = [dictionary nvObjectForKey:@"address"];
            self.bankcardShortcut   = [[dictionary nvObjectForKey:@"bindStatus"]boolValue];
            self.bankcardStatus     = [[dictionary nvObjectForKey:@"bankcardStatus"] boolValue];
            self.identityStatus     = [[dictionary nvObjectForKey:@"identityStatus"] boolValue];
            self.payPasswordStatus  = [[dictionary nvObjectForKey:@"payPasswrodStatus"] boolValue];
            self.customerType       = [[dictionary nvObjectForKey:@"customerType"] integerValue];
            self.status             = [[dictionary nvObjectForKey:@"status"] integerValue];
            self.userSign           = [dictionary nvObjectForKey:@"userSign"];
            self.accountantName     = [dictionary nvObjectForKey:@"accountantName"];//理财师姓名
            self.showRefferCode     = [[dictionary nvObjectForKey:@"showRefferCode"] integerValue];//理财师推荐码
            
            self.ventureStatus      = [[dictionary nvObjectForKey:@"ventureStatus"]boolValue];
            
            NSArray* group          = [dictionary nvObjectForKey:@"group"];
            if ([group isKindOfClass:[NSArray class]]) {
                self.group          = group;
            }
            
            self.hidName            = [dictionary nvObjectForKey:@"hidName"];
            self.avaterPath         = [dictionary nvObjectForKey:@"avaterPath"];
            self.bankDepository     = [[dictionary nvObjectForKey:@"bankDepository"]boolValue];
            self.bankUserType       = [dictionary nvObjectForKey:@"bankUserType"];
        }
    }
    
    return self;
}


- (NSDictionary*) dictionaryValue {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic nvSetObject:self.userId forKey:@"userId"];
    [dic nvSetObject:self.token forKey:@"token"];
    [dic nvSetObject:self.mobile forKey:@"mobile"];
    [dic nvSetObject:self.hidName forKey:@"hidName"];
    [dic nvSetObject:self.avaterPath forKey:@"avaterPath"];

    return dic;
}

@end
