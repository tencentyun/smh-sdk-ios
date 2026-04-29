//
//  QCloudSMHDeltaLogResult.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/// 单条增量变动记录（对应 queryDeltaLog 响应中 contents 数组元素）
@interface QCloudSMHDeltaEntry : NSObject
/** 事件类型（FILE.CREATE / FILE.MODIFY / FILE.DELETE 等） */
@property (nonatomic, strong) NSString *eventType;
/** 事件发生时间，ISO 8601 格式 */
@property (nonatomic, strong) NSString *eventTime;
/** 文件/目录的唯一标识 ID */
@property (nonatomic, strong) NSString *inode;
/** 父目录的唯一标识 ID */
@property (nonatomic, strong) NSString *parentInode;
/** 文件名或目录名 */
@property (nonatomic, strong) NSString *name;
/** 节点类型：file / dir / symlink */
@property (nonatomic, strong) NSString *type;
/** 文件大小，字符串格式（仅文件类型返回） */
@property (nonatomic, strong) NSString *size;
/** 文件 ETag（仅文件类型返回） */
@property (nonatomic, strong) NSString *eTag;
/** 文件的 CRC64-ECMA182 校验值，字符串格式（仅文件类型返回） */
@property (nonatomic, strong) NSString *crc64;
/** 媒体类型（仅文件类型返回） */
@property (nonatomic, strong) NSString *contentType;
/** 文件自定义分类（仅文件类型返回） */
@property (nonatomic, strong) NSString *category;
/** 文件类型：excel、powerpoint 等（仅文件类型返回） */
@property (nonatomic, strong) NSString *fileType;
/** 文件的创建时间或上传时间 */
@property (nonatomic, strong) NSString *creationTime;
/** 文件最近一次被覆盖的时间 */
@property (nonatomic, strong) NSString *modificationTime;
/** 文件对应的本地创建时间（仅文件类型返回） */
@property (nonatomic, strong) NSString *localCreationTime;
/** 文件对应的本地修改时间（仅文件类型返回） */
@property (nonatomic, strong) NSString *localModificationTime;
/** 操作者用户 ID */
@property (nonatomic, strong) NSString *userId;
/** 版本号（仅文件类型返回） */
@property (nonatomic, assign) NSInteger versionId;
/** 文件位置：0-普通，1-回收站，2-历史版本，3-已标记删除 */
@property (nonatomic, assign) NSInteger location;
/** 是否被配额策略删除标记 */
@property (nonatomic, assign) BOOL removedByQuota;
/** 软链接指向的目标文件 inode（仅软链接类型返回） */
@property (nonatomic, strong) NSString *linkTo;
/** 额外信息，不同事件类型携带不同的扩展信息 */
@property (nonatomic, strong) NSDictionary *extraInfo;
@end

/// 增量变动日志结果（对应 queryDeltaLog 响应）
@interface QCloudSMHDeltaLogResult : NSObject
/** 下一次请求使用的增量游标 */
@property (nonatomic, strong) NSString *cursor;
/** 是否还有更多数据 */
@property (nonatomic, assign) BOOL hasMore;
/** 增量变更日志列表 */
@property (nonatomic, strong) NSArray<QCloudSMHDeltaEntry *> *contents;
@end

NS_ASSUME_NONNULL_END
