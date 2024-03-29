//
//  QCloudSMHGetSSOListRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/7/06.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudSSOListModel.h"
NS_ASSUME_NONNULL_BEGIN
/**
 获取企业配置的 SSO 列表。
 */
@interface QCloudSMHGetSSOListRequest : QCloudSMHBaseRequest

/**
 企业 ID，可选参数，跟 Domain 二选一
 */
@property (nonatomic,strong)NSString * corpId;

/**
 自定义域名，可选参数，跟 CorpId 二选一
 */
@property (nonatomic,strong)NSString * domain;


- (void)setFinishBlock:(void (^)(QCloudSSOListModel * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
