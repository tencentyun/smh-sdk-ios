//
//  QCloudSMHUserBizRequest.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/26.
//

#import "QCloudSMHUserBizRequest.h"

@implementation QCloudSMHUserBizRequest

- (instancetype)init {
    self = [super initWithApiType:QCloudECDTargetAPIUser];
    if (!self) {
        return self;
    }
    return self;
}

- (BOOL)buildRequestData:(NSError *__autoreleasing *)error {
    if (![super buildRequestData:error]) {
        return NO;
    }

    if (!self.userToken || ([self.userToken isKindOfClass:NSString.class] && ((NSString *)self.userToken).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[userToken] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    if (!self.organizationId || ([self.organizationId isKindOfClass:NSString.class] && ((NSString *)self.organizationId).length == 0)) {
        if (error != NULL) {
            *error = [NSError
                qcloud_errorWithCode:QCloudNetworkErrorCodeParamterInvalid
                             message:[NSString stringWithFormat:
                                                   @"InvalidArgument:paramter[OrganizationId] is invalid (nil), it must have some value. please check it"]];
            return NO;
        }
    }
    
    return YES;
}

-(BOOL)prepareInvokeURLRequest:(NSMutableURLRequest *)urlRequest error:(NSError * _Nullable __autoreleasing *)error{
    return YES;
}
@end
