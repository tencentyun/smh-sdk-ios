//
//  QCloudSMHCheckFavoriteRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/17.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHCheckFavoriteInfo.h"
#import "QCloudSMHCheckFavoriteResultInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 查看文件目录收藏状态
 */
@interface QCloudSMHCheckFavoriteRequest : QCloudSMHUserBizRequest

/// 文件信息
@property (nonatomic,strong)NSArray<QCloudSMHCheckFavoriteInfo *> * checkFavoriteInfos;
-(void)setFinishBlock:(void (^ _Nullable)(NSArray <QCloudSMHCheckFavoriteResultInfo *> * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
