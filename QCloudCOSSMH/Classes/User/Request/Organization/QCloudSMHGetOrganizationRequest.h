//
//  QCloudSMHGetOrganizationRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/16.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHOrganizationsInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 列出当前登录用户所属组织
 */
@interface QCloudSMHGetOrganizationRequest : QCloudSMHBaseRequest
@property (nonatomic,strong)NSString *userToken;

-(void)setFinishBlock:(void (^ _Nullable)(NSArray <QCloudSMHOrganizationInfo *>* _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
