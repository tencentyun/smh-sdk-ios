//
//  QCloudSMHDownloadInfoModel.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/27.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentTypeEnum.h"
@class QCloudSMHMetaData;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHDownloadInfoModel : NSObject

/// 带签名的下载链接，签名有效时长约 2 小时，需在签名有效期内发起下载；
@property (strong, nonatomic) NSString * cosUrl;

/// 文件类型；
@property (assign, nonatomic) QCloudSMHContentInfoType type;

/// 文件首次完成上传的时间；
@property (strong, nonatomic) NSString * creationTime;

/// 文件最近一次被覆盖的时间。
@property (strong, nonatomic) NSString * modificationTime;

///  媒体类型；
@property (strong, nonatomic) NSString * contentType;

/// 文件大小，为了避免数字精度问题，这里为字符串格式；
@property (strong, nonatomic) NSString * size;

/// 文件 ETag
@property (strong, nonatomic) NSString * eTag;

/// 文件的 CRC64-ECMA182 校验值，为了避免数字精度问题，这里为字符串格式；
@property (strong, nonatomic) NSString * crc64;

/// 操作后的对象文件类型
@property (nonatomic,assign)QCloudSMHContentInfoType fileType;

/// 是否可通过万象预览；
@property (nonatomic,assign)BOOL previewByCI;

/// 是否可通过 onlyoffice 预览；
@property (nonatomic, assign)BOOL previewByDoc;

/// 是否可用预览图做 icon，非必返；
@property (nonatomic, assign) BOOL previewAsIcon;

/// 元数据，如果没有元数据则不存在该字段；
@property (strong, nonatomic) QCloudSMHMetaData * metaData;

@end

@interface QCloudSMHMetaData : NSObject
@property (strong, nonatomic) NSString * xSmhMetaFoo;
@end
NS_ASSUME_NONNULL_END
