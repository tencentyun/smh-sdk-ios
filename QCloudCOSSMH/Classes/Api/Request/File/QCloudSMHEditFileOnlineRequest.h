//
//  QCloudSMHEditFileOnlineRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/27.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHContentInfo.h"
NS_ASSUME_NONNULL_BEGIN

/**
 获取在编编辑链接
 */
@interface QCloudSMHEditFileOnlineRequest : QCloudSMHBizRequest

/// 完整文件路径，例如 foo/bar/file_new.docx
@property (nonatomic,strong)NSString *filePath;

-(void)setFinishBlock:(void (^ _Nullable)(NSString * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
