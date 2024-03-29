//
//  QCloudSMHDetailDirectoryRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/16.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHContentInfo.h"
NS_ASSUME_NONNULL_BEGIN

/**
 用于生成查看目录或相簿详情
 */
@interface QCloudSMHDetailDirectoryRequest : QCloudSMHBizRequest

/**
 文件路径；
 */
@property (nonatomic,strong)NSString *filePath;

-(void)setFinishBlock:(void (^ _Nullable)( QCloudSMHContentInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
