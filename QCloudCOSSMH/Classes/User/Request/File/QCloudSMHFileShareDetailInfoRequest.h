//
//  QCloudSMHFileShareDetailInfoRequest.h
//  Pods
//
//  Created by garenwang on 2021/9/16.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHShareUserInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 获取分享链接信息（打开分享 url 时查询）
 */
@interface QCloudSMHFileShareDetailInfoRequest : QCloudSMHBaseRequest

@property (nonatomic,strong)NSString * shareToken;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHShareUserInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
