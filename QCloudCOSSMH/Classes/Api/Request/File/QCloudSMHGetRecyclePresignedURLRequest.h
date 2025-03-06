//
//  QCloudSMHGetRecyclePresignedURLRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/2.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 用于预览回收站项目
 
 可用于预览文档、图片、视频等多种文件类型；
 预览文档类型的文件时，返回HTML或JPG格式的文档用于预览；
 预览视频文件时，返回视频的首帧图片作为视频封面预览；
 针对照片或视频封面，优先使用人脸识别智能缩放裁剪为 {Size}px × {Size}px 大小，如果未识别到人脸则居中缩放裁剪为 {Size}px × {Size}px 大小，如果未指定 {Size} 参数则使用照片或视频封面原图，最后 302 跳转到对应的图片的 URL；
 可以直接在使用图片的参数中指定该 URL，例如小程序 <image> 标签、 HTML <img> 标签或小程序 wx.previewImage 接口等，该接口将自动 302 跳转到真实的图片 URL；
 如果文件不属于可预览的文件类型，则会跳转至文件的下载链接；
 */
@interface QCloudSMHGetRecyclePresignedURLRequest : QCloudSMHBizRequest

/**
 回收站 ID，必选参数；
 */
@property (nonatomic,strong)NSString *recycledItemId;

/**
 缩放大小
 */
@property (nonatomic,assign)NSInteger size;

/**
 历史版本id
 */
@property (nonatomic,assign)NSInteger historyId;

/**
 可选参数，如果设置为"pic"则以JPG格式预览文档首页，否则以HTML格式预览文档；
 */
@property (nonatomic,strong)NSString * type;


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
