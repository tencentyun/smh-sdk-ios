//
//  QCloudSMHGetDownloadInfoRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/16.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHCommonEnum.h"
#import "QCloudSMHDownloadInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 用于获取文件下载链接和信息
 
 要求权限：
 非 acl 鉴权：无
 acl 鉴权：canDownload（当前文件夹可下载）
 */
@interface QCloudSMHGetDownloadInfoRequest : QCloudSMHBizRequest

///  完整文件路径，例如 /api/v1/file/smhxxx/-/foo/bar/file.docx
@property (nonatomic,strong)NSString *filePath;

/// 历史版本
@property (nonatomic,assign)NSInteger historyId;

/// 只要调用这个接口获取的返回值，
/// 用来做下载就传 download，
/// 用来预览就传 preview，
/// 用来缩略图就传 list
@property (nonatomic,assign)QCloudSMHPurposeType purpose;

/**
 为可选参数（类型number），单链接下载限速，范围100KB/s-100MB/s，单位B；
 */
@property (nonatomic,assign)NSInteger trafficLimit;

/**
 可选参数，是否只用于校验文件是否可预览和下载，设置该参数后返回结果中不包含cosUrl
 */
@property (nonatomic,assign)BOOL preCheck;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHDownloadInfoModel *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
