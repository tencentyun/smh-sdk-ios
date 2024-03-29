//
//  QCloudSMHGetINodeDetailRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHINodeDetailInfo.h"
NS_ASSUME_NONNULL_BEGIN

/**
 查询 inode 文件信息（返回路径）
 */
@interface QCloudSMHGetINodeDetailRequest : QCloudSMHBizRequest

///  文件 ID；
@property (nonatomic,strong)NSString * iNode;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHINodeDetailInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
