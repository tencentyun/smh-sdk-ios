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
 根据文件ID查询文件信息
 */
@interface QCloudSMHGetINodeDetailRequest : QCloudSMHBizRequest

///  文件 ID；
@property (nonatomic,strong)NSString * iNode;

/**
 文件内容的 Cas 标识，可选参数。当 conflict_resolution_strategy 为 overwrite 并且 ContentCas 不为空时，
 只有当文件存在、并且 cas 匹配，重命名或移动文件的操作才会继续进行，否则会返回 409 状态码，错误码为 ContentCasConflict；
 */
@property (nonatomic, strong, nullable) NSString *contentCas;

/**
 是否返回文件内容的 Cas 标识，0 或 1，可选，默认不返回；
 */
@property (nonatomic, assign) BOOL withContentCas;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHINodeDetailInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
