//
//  QCloudSMHBatchMultiSpaceFileInfoRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/26.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHContentInfo.h"

NS_ASSUME_NONNULL_BEGIN


/// 批量获取文件详情（可跨空间）
@interface QCloudSMHBatchMultiSpaceFileInfoRequest : QCloudSMHUserBizRequest

/// 文件或文件夹目录
@property (nonatomic,strong)NSArray <QCloudSMHFileInputInfo *> *infos;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHListFileInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock; 

@end

NS_ASSUME_NONNULL_END
