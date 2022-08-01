//
//  QCloudSMHGetAlbumRequest.h
//  QCloudSMHGetAlbumRequest
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHUploadStateInfo.h"
NS_ASSUME_NONNULL_BEGIN

/**
 获取相簿封面图
 */
@interface QCloudSMHGetAlbumRequest : QCloudSMHBizRequest

/// 缩放大小，可选参数，相关说明参阅接口说明。
@property (nonatomic,strong)NSString * size;

/// 相簿名，分相簿媒体库必须指定该参数，不分相簿媒体库不能指定该参数。
@property (nonatomic,strong)NSString * albumName;

@end

NS_ASSUME_NONNULL_END
