//
//  QCloudSMHBatchBaseRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/3.
//

#import <QCloudCore/QCloudCore.h>
#import "QCloudGetTaskStatusRequest.h"
#import "QCloudSMHBatchMoveRequest.h"
#import "QCloudSMHBatchResult.h"
#import "QCloudSMHService.h"

#import "QCloudSMHTaskResult.h"

NS_ASSUME_NONNULL_BEGIN
/**
 批量任务基类
 */
@interface QCloudSMHBatchBaseRequest <BATCHTYPE> : QCloudHTTPRequest 
@property (nonatomic,strong)NSString *taskId;

@property (nonatomic)NSArray <BATCHTYPE>*batchInfos;

/**
媒体库 ID，必选参数
*/
@property (nonatomic,strong)NSString *libraryId;

/**
空间 ID，如果媒体库为单租户模式，则该参数固定为连字符(-)；如果媒体库为多租户模式，则必须指定该参数
*/
@property (nonatomic,strong)NSString *spaceId;

/**
用户身份识别，当访问令牌对应的权限为管理员权限且申请访问令牌时的用户身份识别为空时用来临时指定用户身份，详情请参阅生成访问令牌接口
*/
@property (nonatomic,strong)NSString *userId;

/**
 空间所在组织id
 */
@property (nonatomic,strong)NSString * spaceOrgId;

- (void)startAsyncTask;
@end

NS_ASSUME_NONNULL_END
