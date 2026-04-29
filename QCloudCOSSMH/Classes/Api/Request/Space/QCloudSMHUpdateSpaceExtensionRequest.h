//
//  QCloudSMHUpdateSpaceExtensionRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 修改租户空间属性
/// @discussion 要求权限：非 acl 鉴权时需要 admin 或 space_admin 权限。
@interface QCloudSMHUpdateSpaceExtensionRequest : QCloudSMHBizRequest
/// 是否为公有读，不指定默认为 false，可选参数
@property (nonatomic, assign) BOOL isPublicRead;
/// 是否允许上传照片，不指定默认为 false，可选参数（仅在媒体类型媒体库中生效）
@property (nonatomic, assign) BOOL allowPhoto;
/// 是否允许上传视频，不指定默认为 false，可选参数（仅在媒体类型媒体库中生效）
@property (nonatomic, assign) BOOL allowVideo;
/// 允许上传的照片扩展名列表，默认为空数组，可选参数（仅在媒体类型媒体库中生效）
@property (nonatomic, strong, nullable) NSArray<NSString *> *allowPhotoExtname;
/// 允许上传的视频扩展名列表，默认为空数组，可选参数（仅在媒体类型媒体库中生效）
@property (nonatomic, strong, nullable) NSArray<NSString *> *allowVideoExtname;
/// 允许上传的文件扩展名列表，默认为空数组，可选参数（仅在非媒体类型媒体库中生效）
@property (nonatomic, strong, nullable) NSArray<NSString *> *allowFileExtname;
/// 是否检测敏感内容，不指定默认为 false，可选参数
@property (nonatomic, assign) BOOL recognizeSensitiveContent;
- (void)setFinishBlock:(void (^_Nullable)(id _Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
