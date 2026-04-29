//
//  QCloudSMHShareFileItem.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/27.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/// 分享文件/目录条目（对应 listShareFiles 响应中 contents 数组元素）
@interface QCloudSMHShareFileItem : NSObject
/** 文件或目录名称 */
@property (nonatomic, strong) NSString *name;
/** 文件所在空间 ID */
@property (nonatomic, strong) NSString *spaceId;
/** 类型，file（文件）或 dir（目录） */
@property (nonatomic, strong) NSString *type;
/** 文件大小（整数转的字符串），为目录时不返回 */
@property (nonatomic, strong) NSString *size;
/** 最后修改时间，ISO 8601 格式 */
@property (nonatomic, strong) NSString *updateTime;
/** 是否允许预览 */
@property (nonatomic, assign) BOOL canPreview;
/** 是否允许下载 */
@property (nonatomic, assign) BOOL canDownload;
/** 是否允许转存到网盘 */
@property (nonatomic, assign) BOOL canSaveToNetdisk;
/** 文件/目录的 inode 标识，用于下载、预览、访问子目录 */
@property (nonatomic, strong) NSString *inode;
@end
NS_ASSUME_NONNULL_END
