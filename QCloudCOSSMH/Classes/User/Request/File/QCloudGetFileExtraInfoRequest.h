//
//  QCloudGetFileExtraInfoRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2022/6/9.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHFileExtraInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 查看文件目录额外信息
 */
@interface QCloudGetFileExtraInfoRequest : QCloudSMHUserBizRequest


@property (nonatomic,strong)NSArray <QCloudSMHFileExtraReqInfo *> * fileInfos;

- (void)setFinishBlock:(void (^_Nullable)(NSArray <QCloudSMHFileExtraInfo *> *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
