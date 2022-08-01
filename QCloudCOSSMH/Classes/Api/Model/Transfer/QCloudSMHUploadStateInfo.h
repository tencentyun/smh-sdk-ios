//
//  QCloudSMHUploadStateInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/18.
//

#import <Foundation/Foundation.h>
@class QCloudSMHUploadStatePartsInfo;
@class QCloudSMHInitUploadInfo;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHUploadStateInfo : NSObject

/// 字符串数组 或 null，如果是字符串数组则表示最终的文件路径，数组中的最后一个元素代表最终的文件名，其他元素代表每一级目录名，因为可能存在同名文件自动改名，因此这里的最终路径可能不等同于开始上传时指定的路径；如果是 null 则表示该文件所在的目录或其某个父级目录已被删除，该文件已经无法访问；
@property (nonatomic, strong) NSArray <NSString *> *path;

/// 类型；
@property (nonatomic, strong) NSString *type;

/// 上传任务创建时间；
@property (nonatomic, strong) NSString *creationTime;

/// 是否强制覆盖同路径文件；
@property (nonatomic, strong) NSString *force;

/// 如果为分块上传则返回该字段，包含已上传的分块信息；否则不返回该字段；
@property (nonatomic, strong) NSArray  <QCloudSMHUploadStatePartsInfo *> *parts;

/// 如果为分块上传则返回该字段，包含继续进行分块上传的信息（可参阅开始分块上传文件接口）；否则不返回该字段
@property (nonatomic, strong) QCloudSMHInitUploadInfo *uploadPartInfo;

@end

@interface QCloudSMHUploadStatePartsInfo : NSObject

@property (nonatomic, strong) NSString * PartNumber;
@property (nonatomic, strong) NSString * LastModified;
@property (nonatomic, strong) NSString * ETag;
@property (nonatomic, strong) NSString * Size;
@end

NS_ASSUME_NONNULL_END
