//
//  QCloudSMHFavoriteFileRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHFavoriteTypeEnum.h"
#import "QCloudSMHFavoriteInfo.h"
NS_ASSUME_NONNULL_BEGIN
/**
 收藏文件目录
 */
@interface QCloudSMHFavoriteFileRequest : QCloudSMHUserBizRequest

/// 空间组织id
@property (nonatomic,strong)NSString *spaceOrgId;

/// 空间 ID；
@property (nonatomic,strong)NSString *spaceId;

/// 文件目录路径
@property (nonatomic,strong)NSString *path;

/// 收藏夹 ID，可选参数
@property (nonatomic,strong)NSString *favoriteGroupId;

-(void)setFinishBlock:(void (^_Nullable)( QCloudSMHFavoriteInfo * _Nullable result  , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
