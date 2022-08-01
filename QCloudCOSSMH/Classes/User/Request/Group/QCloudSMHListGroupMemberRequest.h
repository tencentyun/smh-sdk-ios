//
//  QCloudSMHListGroupMemberRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/5/25.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHListGroupMemberInfo.h"
#import "QCloudSMHSortTypeEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 查询群组成员
 */
@interface QCloudSMHListGroupMemberRequest : QCloudSMHUserBizRequest

/// 群组 ID，必填项
@property (nonatomic, copy) NSString * groupId;

/// 查询的手机号或昵称，如果不带 keyword 参数，则是查询组织下的所有用户
@property (nonatomic, copy) NSString * keyword;

/// 分页码，默认第一页，可选参数；
@property (nonatomic,assign)NSInteger page;

/// 分页大小，默认 20，可选参数；
@property (nonatomic,assign)NSInteger pageSize;

/// 限制响应体中的条目数，如不指定则默认为 1000；
@property (nonatomic,assign)NSInteger limit;

/// 分页标记，当需要分页时，响应体中将返回下一次请求时用于该参数的值，当请求第一页时无需指定该参数
@property (nonatomic,copy)NSString *marker;

/// 排序方式，支持
/// QCloudSMHGroupMemberSortByRole
/// QCloudSMHGroupMemberSortByEnabled
/// QCloudSMHGroupMemberSortByNickname，
/// 默认 QCloudSMHGroupMemberSortByRole;
@property (nonatomic,assign)QCloudSMHGroupMemberSortType sortType;

-(void)setFinishBlock:(void (^_Nullable)(QCloudSMHListGroupMemberInfo *  _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END



