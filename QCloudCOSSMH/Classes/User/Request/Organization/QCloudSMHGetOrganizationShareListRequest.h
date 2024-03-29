//
//  QCloudSMHGetOrganizationShareListRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHOrganizationShareList.h"

NS_ASSUME_NONNULL_BEGIN

/**
 获取组织分享列表
 */
@interface QCloudSMHGetOrganizationShareListRequest : QCloudSMHUserBizRequest

/// : 分页码，默认第一页，可选参数；
@property (nonatomic,assign)NSInteger page;

/// : 分页大小，默认 20，可选参数；
@property (nonatomic,assign)NSInteger pageSize;

/// 排序方式，默认过期时间 QCloudSMHSortTypeExpireTime；
/// name, expireTime, nickname, shareTraffic
@property (nonatomic,assign)QCloudSMHShareSortType sortType;

/// : 分享名称，可选参数；
@property (nonatomic,strong)NSString *name;

/// : 分享过期时间开始，可选参数；
@property (nonatomic,strong)NSString *expireTimeStart;

/// : 分享过期时间结束，可选参数；
@property (nonatomic,strong)NSString *expireTimeEnd;

/// : 用户昵称/用户手机号/email，可选参数；
@property (nonatomic,strong)NSString *nickNameOrEmailOrPhoneNumber;


- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHOrganizationShareList *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
