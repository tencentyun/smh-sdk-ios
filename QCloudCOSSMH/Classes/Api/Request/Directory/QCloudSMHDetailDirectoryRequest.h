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
 用于查看目录或相簿详情
 */
@interface QCloudSMHDetailDirectoryRequest : QCloudSMHBizRequest

/**
 文件路径；
 */
@property (nonatomic,strong)NSString *filePath;

/**
 是否返回 inode，即文件目录 ID，可选，默认不返回；
 */
@property (nonatomic,assign)BOOL withInode;
/**
 是否返回收藏状态，可选，默认不返回；
 */
@property (nonatomic,assign)BOOL withFavoriteStatus;

/**
 是否返回文件内容的 Cas 标识，0 或 1，可选，默认不返回；
 */
@property (nonatomic, assign) BOOL withContentCas;

-(void)setFinishBlock:(void (^ _Nullable)( QCloudSMHContentInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
