//
//  QCloudSMHCheckDirectoryApplyRequest.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/30.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCheckDirectoryApplyResult.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN
/**
 用于检查文件是否在审批中
 */
@interface QCloudSMHCheckDirectoryApplyRequest : QCloudSMHUserBizRequest

/// 空间 ID
@property (nonatomic,strong)NSString * spaceId;

/// 授权文件目录集合
@property (nonatomic,strong)NSArray * pathList;

-(void)setFinishBlock:(void (^ _Nullable)(NSArray <QCloudSMHCheckDirectoryApplyItem *> * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
