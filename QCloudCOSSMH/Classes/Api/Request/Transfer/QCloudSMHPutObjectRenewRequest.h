//
//  QCloudSMHPutObjectRenewRequest.h
//  AOPKit
//
//  Created by garenwang on 2021/7/17.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHInitUploadInfo.h"
NS_ASSUME_NONNULL_BEGIN

/**
 分块上传任务续期
 */
@interface QCloudSMHPutObjectRenewRequest : QCloudSMHBizRequest


/// 完整文件路径，例如 /api/v1/file/smhxxx/-/foo/bar/file_new.docx ；
@property (nonatomic,strong)NSString * confirmKey;


-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHInitUploadInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
