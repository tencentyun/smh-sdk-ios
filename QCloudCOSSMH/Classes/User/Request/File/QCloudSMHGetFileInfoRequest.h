//
//  QCloudGetObjectInfoRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/26.
//

#import "QCloudSMHUserBizRequest.h"
#import "QCloudSMHContentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHGetFileInfoRequest : QCloudSMHUserBizRequest

/// 文件或文件夹目录
@property (nonatomic,strong)NSString *dirPath;

/// 空间 ID
@property (nonatomic,strong)NSString *spaceId;

/// 空间所在组织 ID，默认为当前组织 ID
@property (nonatomic,strong)NSString *spaceOrgId;

-(void)setFinishBlock:(void (^ _Nullable)( QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock; 

@end

NS_ASSUME_NONNULL_END
