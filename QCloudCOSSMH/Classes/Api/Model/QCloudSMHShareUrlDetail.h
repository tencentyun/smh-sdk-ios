//
//  QCloudSMHShareUrlDetail.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/27.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCreateShareResult.h"
NS_ASSUME_NONNULL_BEGIN

/// 分享URL详情（对应 getShareUrlDetail 响应）
@interface QCloudSMHShareUrlDetail : NSObject
/** 分享名称 */
@property (nonatomic, strong) NSString *name;
/** 是否已启用 */
@property (nonatomic, assign) BOOL enabled;
/** 分享是否已过期 */
@property (nonatomic, assign) BOOL isExpired;
/** 是否需要提取码 */
@property (nonatomic, assign) BOOL needExtractionCode;
/** 是否允许匿名用户访问 */
@property (nonatomic, assign) BOOL allowAnonymousUser;
/** 是否允许保存到网盘 */
@property (nonatomic, assign) BOOL canSaveToNetDisc;
/** 是否允许预览 */
@property (nonatomic, assign) BOOL canPreview;
/** 是否允许下载 */
@property (nonatomic, assign) BOOL canDownload;
/** 分享状态 */
@property (nonatomic, assign) NSInteger status;
/** 创建者用户 ID */
@property (nonatomic, strong) NSString *userId;
/** 是否启用分享水印 */
@property (nonatomic, assign) BOOL enableShareWatermark;
/** 分享水印类型（如 UserCustom） */
@property (nonatomic, strong) NSString *shareWatermarkType;
/** 水印文本 */
@property (nonatomic, strong) NSString *watermarkText;
/** 文件名（单文件分享时） */
@property (nonatomic, strong) NSString *fileName;
/** 分享域名配置 */
@property (nonatomic, strong) QCloudSMHShareDomainInfo *domain;
@end
NS_ASSUME_NONNULL_END
