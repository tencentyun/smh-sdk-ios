//
//  QCloudSMHCreateSpaceRequest.h
//  QCloudCOSSMH
//
//  Created by codegen on 2026/04/22.
//

#import "QCloudSMHBizRequest.h"
NS_ASSUME_NONNULL_BEGIN
/// 创建租户空间
@interface QCloudSMHCreateSpaceRequest : QCloudSMHBizRequest
/// 是否为公有读，不指定默认为 false
@property (nonatomic, assign) BOOL isPublicRead;
/// 是否为多相簿空间，不指定默认为 false
@property (nonatomic, assign) BOOL isMultiAlbum;
/// 是否允许上传照片，不指定默认为 false
@property (nonatomic, assign) BOOL allowPhoto;
/// 是否允许上传视频，不指定默认为 false
@property (nonatomic, assign) BOOL allowVideo;
/// 允许上传的照片扩展名列表
@property (nonatomic, strong) NSArray<NSString *> *allowPhotoExtname;
/// 允许上传的视频扩展名列表
@property (nonatomic, strong) NSArray<NSString *> *allowVideoExtname;
/// 是否检测敏感内容，不指定默认为 false
@property (nonatomic, assign) BOOL recognizeSensitiveContent;
/// 空间标识，用于区分个人空间和团队空间
@property (nonatomic, strong) NSString *spaceTag;
- (void)setFinishBlock:(void (^_Nullable)(NSDictionary *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END
