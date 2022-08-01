//
//  QCloudListFavoriteGroupRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/9.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHFavoriteResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 列出收藏夹。
 */
@interface QCloudListFavoriteGroupRequest : QCloudSMHUserBizRequest

/**
 收藏夹 Tag，可选参数
 */
@property (nonatomic,copy)NSString *tag;

- (void)setFinishBlock:(void (^_Nullable)(QCloudSMHFavoriteGroupList *_Nullable result, NSError *_Nullable error))QCloudRequestFinishBlock;

@end

NS_ASSUME_NONNULL_END
