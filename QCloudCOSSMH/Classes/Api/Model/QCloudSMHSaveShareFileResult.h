//
//  QCloudSMHSaveShareFileResult.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 转存分享文件 - 单个文件的转存结果
@interface QCloudSMHSaveShareFileItemResult : NSObject

/// 单个项目的复制结果状态码（200: rename 时成功，204: ask/overwrite 时成功，403/404/409/500 等: 失败）
@property (nonatomic, assign) NSInteger status;

/// 最终的路径（字符串数组），因为可能存在自动重命名，所以最终路径可能不等同于复制时指定的路径
@property (nonatomic, copy, nullable) NSArray<NSString *> *path;

/// 发起请求时传入的对应源路径（可能是字符串或字符串数组），对应 JSON 字段 copyFrom
@property (nonatomic, strong, nullable) id sourcePath;

/// 发起请求时传入的对应目标路径的数组形式
@property (nonatomic, copy, nullable) NSArray<NSString *> *to;

@end

/// 转存分享文件 - 响应结果
/// HTTP 200/207 时返回 result 数组；HTTP 202 时返回 taskId
@interface QCloudSMHSaveShareFileResult : NSObject

/// 同步方式复制时的结果列表（HTTP 200/207）
@property (nonatomic, copy, nullable) NSArray<QCloudSMHSaveShareFileItemResult *> *result;

/// 异步方式复制时的任务 ID（HTTP 202），可通过查询任务接口查询任务状态
@property (nonatomic, assign) NSInteger taskId;

@end

NS_ASSUME_NONNULL_END
