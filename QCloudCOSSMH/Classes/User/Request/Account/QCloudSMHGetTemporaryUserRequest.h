//
//  QCloudSMHGetTemporaryUserRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHTemporaryUserResult.h"
#import "QCloudSMHSortTypeEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 临时用户列表，以及搜索
 */
@interface QCloudSMHGetTemporaryUserRequest : QCloudSMHUserBizRequest

/**
 分页码，默认第一页，可选参数；
 */
@property (nonatomic,assign)NSInteger page;

/**
 分页大小，默认 20，可选参数；
 */
@property (nonatomic,assign)NSInteger pageSize;


@property (nonatomic,assign)QCloudSMHTemporaryUserSortType sortType;

/**
 查询的手机号或昵称，如果不带 keyword 参数，则是查询组织下的所有临时用户
 */
@property (nonatomic,strong)NSString * keyword;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHTemporaryUserResult * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
