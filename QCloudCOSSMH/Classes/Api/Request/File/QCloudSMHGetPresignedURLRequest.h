//
//  QCloudSMHGetPresignedURLRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/2.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 用于获取照片/视频封面缩略图
 */
@interface QCloudSMHGetPresignedURLRequest : QCloudSMHBizRequest

/**
 完整文件路径，例如 /api/v1/file/smhxxx/-/foo/bar/file.docx
 */
@property (nonatomic,strong)NSString *filePath;


/// 文档获取预览缩略图：type=pic。
@property (nonatomic,strong)NSString *type;

/**
 缩放大小
 */
@property (nonatomic,assign)NSInteger size;

/**
 历史版本id
 */
@property (nonatomic,assign)NSInteger historyId;

/// 用途，可选参数，列表页传 list、
/// 预览页传 preview（默认）；
@property (nonatomic,assign)QCloudSMHPurposeType purpose;

/// 缩放宽度，不传高度时，高度按等比例缩放，不传 Size 和 Scale 时生效；
@property (nonatomic,assign)NSInteger widthSize;

/// 缩放高度，不传宽度时，宽度按等比例缩放，不传 Size 和 Scale 时生效；
@property (nonatomic,assign)NSInteger heightSize;

/// 帧数，针对 gif 的降帧处理；
@property (nonatomic,assign)NSInteger frameNumber;

/// 等比例缩放百分比，可选参数，不传 Size 时生效；
@property (nonatomic,assign)NSInteger scale;

- (void)setFinishBlock:(void (^_Nullable)(NSString *_Nullable result , NSError *_Nullable error))finishBlock ;
@end

NS_ASSUME_NONNULL_END
