//
//  QCloudSMHFileShareUpdateLinkRequest.h
//  Pods
//
//  Created by garenwang on 2021/9/16.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudFileShareInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 修改分享链接
 */
@interface QCloudSMHFileShareUpdateLinkRequest : QCloudSMHUserBizRequest

/// 修改信息
/// expireTime：日期字符串，过期时间，必选参数；
/// extractionCode：字符串，提取码，可选参数；
/// linkToLatestVersion：布尔型，是否链接到最新版，必选参数；
/// canPreview：布尔型，是否能预览，必选参数；
/// canDownload：布尔型，是否能下载，必选参数；
/// canSaveToNetDisc：布尔型，是否能保存到网盘，必选参数；
/// canModify:布尔型，是否可在线编辑，可选参数；
/// previewCount: 预览次数限制，可选参数；
/// downloadCount: 下载次数限制，可选参数；
/// disabled: 布尔型，是否被禁用，可选参数，默认 false；
/// watermarkText
@property (nonatomic,strong)QCloudFileShareInfo * shareInfo;

/// 需要修改的分享id
@property (nonatomic,strong)NSString * shareId;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHFileShareResult * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
