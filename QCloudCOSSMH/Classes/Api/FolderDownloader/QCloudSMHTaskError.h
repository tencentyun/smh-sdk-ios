//
//  QCloudSMHTaskError.h
//  QCloudCOSSMH
//
//  Created by 摩卡 on 2025/11/13.
//

#ifndef QCloudSMHTaskError_h
#define QCloudSMHTaskError_h


#endif /* QCloudSMHTaskError_h */

/// 文件夹任务错误码
static NSString * const QCloudSMHTaskErrorDomain = @"QCloudSMHTaskErrorDomain";

/// 文件路径冲突
static NSInteger const QCloudSMHTaskErrorPathConflict = 10000;

/// 内部错误
static NSInteger const QCloudSMHTaskErrorInternalError = 10001;

/// 创建目录失败
static NSInteger const QCloudSMHTaskCreateFolderFailed = 10002;

/// 用户取消
static NSInteger const QCloudSMHTaskErrorUserCancel = 10003;

/// 用户删除
static NSInteger const QCloudSMHTaskErrorUserDelete = 10004;


