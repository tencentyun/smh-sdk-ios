//
//  QCloudSMHSpaceExtensionInfo.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/// 租户空间扩展属性信息（对应 getSpaceExtension 响应）
@interface QCloudSMHSpaceExtensionInfo : NSObject
/** 是否为公有读，不指定默认为 false */
@property (nonatomic, assign) BOOL isPublicRead;
/** 是否允许上传照片，不指定默认为 false */
@property (nonatomic, assign) BOOL allowPhoto;
/** 是否允许上传视频，不指定默认为 false */
@property (nonatomic, assign) BOOL allowVideo;
/** 允许的照片扩展名数组，默认为空数组 */
@property (nonatomic, strong) NSArray<NSString *> *allowPhotoExtname;
/** 允许的视频扩展名数组，默认为空数组 */
@property (nonatomic, strong) NSArray<NSString *> *allowVideoExtname;
/** 是否检测敏感内容，不指定默认为 false */
@property (nonatomic, assign) BOOL recognizeSensitiveContent;
@end
NS_ASSUME_NONNULL_END
