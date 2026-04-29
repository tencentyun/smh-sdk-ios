//
//  QCloudSMHPreviewFileRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 获取 HTML 格式文档预览
 返回 HTML 或 JPG 格式的文档用于预览；
 如果文件不属于可预览的文档类型，则会跳转至文件的下载链接。
 接口返回 302 重定向，SDK 会拦截重定向并将 Location 地址通过 finishBlock 返回。
 */
@interface QCloudSMHPreviewFileRequest : QCloudSMHBizRequest

/// 文件路径，必选参数
@property (nonatomic, strong) NSString *filePath;

/// 历史版本 ID，用于获取不同版本的文件内容，可选参数，不传默认为最新版
@property (nonatomic, strong, nullable) NSString *historyId;

/// 文档预览方式，如果设置为 pic 则以 jpg 格式预览文档首页，否则以 html 格式预览文档，可选参数
@property (nonatomic, strong, nullable) NSString *type;

- (void)setFinishBlock:(void (^_Nullable)(NSString *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end
NS_ASSUME_NONNULL_END
