//
//  QCloudSMHShareDetail.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/27.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/// 分享详情中的文件信息（对应 getShareDetail 响应中的 fileInfo 字段）
@interface QCloudSMHShareDetailFileInfo : NSObject
/** 文件名（随机返回一个分享里面的文件/文件夹的 name） */
@property (nonatomic, strong) NSString *fileName;
/** 文件类型（文件或者文件夹） */
@property (nonatomic, strong) NSString *fileType;
/** 文件大小，文件为目录时为空 */
@property (nonatomic, strong) NSString *size;
@end

/// 分享详情（对应 getShareDetail 响应）
@interface QCloudSMHShareDetail : NSObject
/** 分享 ID */
@property (nonatomic, strong) NSString *identifier;
/** 媒体库 ID */
@property (nonatomic, strong) NSString *libraryId;
/** 分享名称 */
@property (nonatomic, strong) NSString *name;
/** 分享访问码（由算法生成的唯一标识） */
@property (nonatomic, strong) NSString *code;
/** 创建者 ID */
@property (nonatomic, strong) NSString *creatorId;
/** 过期时间，ISO 8601 格式 */
@property (nonatomic, strong) NSString *expireTime;
/** 是否为永久分享 */
@property (nonatomic, assign) BOOL isPermanent;
/** 创建时间，ISO 8601 格式 */
@property (nonatomic, strong) NSString *creationTime;
/** 提取码 */
@property (nonatomic, strong) NSString *extractionCode;
/** 分享是否已过期 */
@property (nonatomic, assign) BOOL isExpired;
/** 创建者是否启用 */
@property (nonatomic, assign) BOOL ownerEnabled;
/** 管理员是否启用 */
@property (nonatomic, assign) BOOL adminEnabled;
/** 分享状态：0-未审核、1-审核中、2-审核通过、3-审核不通过 */
@property (nonatomic, assign) NSInteger status;
/** 是否允许保存到网盘 */
@property (nonatomic, assign) BOOL canSaveToNetdisk;
/** 是否允许预览 */
@property (nonatomic, assign) BOOL canPreview;
/** 是否允许下载 */
@property (nonatomic, assign) BOOL canDownload;
/** 是否禁止匿名用户访问 */
@property (nonatomic, assign) BOOL forbidAnonymousUser;
/** 预览次数限制（canPreview 为 true 时返回） */
@property (nonatomic, assign) NSInteger previewLimit;
/** 已使用的预览次数 */
@property (nonatomic, assign) NSInteger previewUsed;
/** 下载次数限制 */
@property (nonatomic, assign) NSInteger downloadLimit;
/** 已使用的下载次数 */
@property (nonatomic, assign) NSInteger downloadUsed;
/** 文件信息（仅当请求参数 with_file_info=1 时返回） */
@property (nonatomic, strong) QCloudSMHShareDetailFileInfo *fileInfo;
/** 指定分享给的用户列表 */
@property (nonatomic, strong) NSArray<NSString *> *toUsers;
/** 访问用户数限制（toUsers 为空时返回） */
@property (nonatomic, assign) NSInteger userLimit;
/** 已访问的用户数 */
@property (nonatomic, assign) NSInteger userLimitUsed;
/** 水印文本 */
@property (nonatomic, strong) NSString *watermarkText;
@end
NS_ASSUME_NONNULL_END
