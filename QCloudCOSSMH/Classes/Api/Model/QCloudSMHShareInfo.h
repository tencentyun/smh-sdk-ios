//
//  QCloudSMHShareInfo.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/// 分享文件信息（对应 listShares 响应中 contents 元素的 fileInfo 字段）
@interface QCloudSMHShareFileInfo : NSObject
/** 文件名 */
@property (nonatomic, strong) NSString *name;
/** 空间 ID */
@property (nonatomic, strong) NSString *spaceId;
/** 类型（file/dir） */
@property (nonatomic, strong) NSString *type;
/** 文件大小（数字转的字符串） */
@property (nonatomic, strong) NSString *size;
/** 更新时间 */
@property (nonatomic, strong) NSString *updateTime;
@end

/// 分享信息（对应 listShares 响应中 contents 数组元素）
@interface QCloudSMHShareInfo : NSObject
/** 分享 ID */
@property (nonatomic, strong) NSString *identifier;
/** 分享名称 */
@property (nonatomic, strong) NSString *name;
/** 创建时间 */
@property (nonatomic, strong) NSString *createTime;
/** 过期时间 */
@property (nonatomic, strong) NSString *expireTime;
/** 管理员是否启用 */
@property (nonatomic, assign) BOOL adminEnabled;
/** 创建者是否启用 */
@property (nonatomic, assign) BOOL ownerEnabled;
/** 是否为永久分享 */
@property (nonatomic, assign) BOOL isPermanent;
/** 是否允许预览 */
@property (nonatomic, assign) BOOL canPreview;
/** 是否允许下载 */
@property (nonatomic, assign) BOOL canDownload;
/** 是否允许保存到网盘 */
@property (nonatomic, assign) BOOL canSaveToNetdisk;
/** 预览次数限制 */
@property (nonatomic, assign) NSInteger previewLimit;
/** 已使用的预览次数 */
@property (nonatomic, assign) NSInteger previewUsed;
/** 下载次数限制 */
@property (nonatomic, assign) NSInteger downloadLimit;
/** 已使用的下载次数 */
@property (nonatomic, assign) NSInteger downloadUsed;
/** 分享状态：0-未审核、1-审核中、2-审核通过、3-审核不通过 */
@property (nonatomic, assign) NSInteger status;
/** 访问用户数限制 */
@property (nonatomic, assign) NSInteger userLimit;
/** 已访问的用户数 */
@property (nonatomic, assign) NSInteger userLimitUsed;
/** 分享内其中一个文件信息（仅当请求参数 with_file_info=1 时返回） */
@property (nonatomic, strong) QCloudSMHShareFileInfo *fileInfo;
/** 分享的提取码（没有提取码则为空） */
@property (nonatomic, strong) NSString *code;
/** 创建者 ID */
@property (nonatomic, strong) NSString *creatorId;
@end
NS_ASSUME_NONNULL_END
