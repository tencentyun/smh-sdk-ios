

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
#import "QCloudSMHUploadPartResult.h"
NS_ASSUME_NONNULL_BEGIN


typedef NSMutableDictionary * _Nullable (^QCloudSMHRenewUploadInfoBlock)(void);

/**
 分块上传
 */
@interface QCloudCOSSMHUploadPartRequest<BodyType> : QCloudBizHTTPRequest
@property (nonatomic, strong) BodyType body;

@property (nonatomic,strong)NSString * domain;

@property (nonatomic,strong)NSString * path;

@property (nonatomic,assign)NSInteger partNumber;
/**
标识本次分块上传的 ID；
使用 Initiate Multipart Upload 接口初始化分片上传时会得到一个 uploadId，
 该 ID 不但唯一标识这一分块数据，也标识了这分块数据在整个文件内的相对位置
*/
@property (strong, nonatomic) NSString *uploadId;

@property (strong, nonatomic) QCloudSMHRenewUploadInfoBlock renewUploadInfo;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHUploadPartResult *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;
@end
NS_ASSUME_NONNULL_END


