//
//  QCloudCOSSMHUploadObjectRequest.h
//  Pods
//
//  Created by Dong Zhao on 2017/5/23.
//
//

#import <QCloudCore/QCloudCore.h>
#import "QCloudSMHBizRequest.h"
#import "QCloudSMHConflictStrategyEnumType.h"
#import "QCloudSMHContentInfo+Transfer.h"
NS_ASSUME_NONNULL_BEGIN

@class QCloudSMHConfirmInfo;
@class QCloudSMHInitUploadInfo;
@class QCloudCOSSMHUploadObjectRequest;

typedef void (^QCloudSMHPreviewSendProcessBlock)(int64_t count, int64_t total, BOOL isStart);


typedef void (^RequestsMetricArrayBlock)(NSMutableArray *_Nullable requstMetricArray);


typedef void (^QCloudSMHRequestsConfirmKeyBlock)(NSString *_Nullable confirmKey);


/**
 高级上传接口 COS层封装
 
 */
@interface QCloudCOSSMHUploadObjectRequest<BodyType> : QCloudAbstractRequest


/// 当前请求所属的队列，nil 标识sdk内默认队列，
@property (nonatomic, weak) QCloudOperationQueue * ownerQueue;

@property (nonatomic, assign) QCloudAbstractRequestPriority uploadPriority;

/// 获取confirmKey回调，用于断点续传 获取文件上传任务状态
@property (nonatomic,strong) QCloudSMHRequestsConfirmKeyBlock getConfirmKey;

@property (nonatomic, strong)BodyType body;

/// 当前用户 id
@property (nonatomic,strong)NSString * userId;


/// 断点续传是需要指定
/// 从QCloudSMHRequestsConfirmKeyBlock获取。
@property (nonatomic,strong)NSString * confirmKey;

@property (nonatomic,strong)NSString * spaceId;

@property (nonatomic,strong)NSString * spaceOrgId;

@property (nonatomic,strong)NSString * libraryId;

@property (nonatomic,strong)NSString * uploadPath;

/**
 文件名冲突时的处理方式，默认为 rename
 */
@property (nonatomic,assign)QCloudSMHConflictStrategyEnum conflictStrategy;

@property (nonatomic, strong) QCloudSMHPreviewSendProcessBlock _Nullable previewSendProcessBlock;
/**
 表明该请求是否已经被中断
 */
@property (assign, atomic, readonly) BOOL aborted;

@property (nonatomic, copy) RequestsMetricArrayBlock requstsMetricArrayBlock;

/**
 是否在上传完成以后，将 COS 返回的文件MD5与本地文件算出来的md5进行校验。默认开启，如果校验出错，
 文件仍然会被上传到 COS, 不过我们会在本地抛出校验失败的error。
 */
@property (nonatomic, assign) BOOL enableVerification;

/**
 在进行HTTP请求的时候，可以通过设置该参数来设置自定义的一些头部信息。
 通常情况下，携带特定的额外HTTP头部可以使用某项功能，如果是这类需求，可以通过设置该属性来实现。
 */
@property (strong, nonatomic) NSMutableDictionary *_Nullable customHeaders;

@property (assign, nonatomic) bool uploadBodyIsCompleted;

/**
 文件自定义的分类,string类型,最大长度16字节， 可选，用户可通过更新文件接口修改文件的分类，也可以根据文件后缀预定义文件的分类信息。
 */
@property (nonatomic,strong)NSString * category;

/**
 文件对应的本地创建时间，时间戳字符串，可选参数；
 */
@property (nonatomic,strong)NSString * localCreationTime;

/**
 文件对应的本地修改时间，时间戳字符串，可选参数；
 */
@property (nonatomic,strong)NSString * localModificationTime;

/**
 文件标签列表, 比如 ["动物", "大象", "亚洲象"]
 */
@property (nonatomic,strong)NSArray <NSString *> * labels;

//自定义分片大小
@property (nonatomic, assign) NSUInteger sliceSize;
//自定义分片阈值
@property (nonatomic, assign) NSInteger mutilThreshold;

@property (strong, nonatomic) QCloudHTTPRetryHanlder *_Nullable retryHandler;

- (void)abort:(QCloudRequestFinishBlock _Nullable)finishBlock;


@end
NS_ASSUME_NONNULL_END
