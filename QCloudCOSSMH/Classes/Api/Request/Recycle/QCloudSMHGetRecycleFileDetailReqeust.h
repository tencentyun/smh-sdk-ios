//
//  QCloudSMHGetRecycleFileDetailReqeust.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/7/28.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHRecycleObjectListInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 用于查看回收站文件详情，以便进行预览
 */
@interface QCloudSMHGetRecycleFileDetailReqeust : QCloudSMHBizRequest

///  回收站 ID，必选参数；
@property (nonatomic,assign) NSInteger recycledItemId;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHRecycleObjectItemInfo * _Nullable result , NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
