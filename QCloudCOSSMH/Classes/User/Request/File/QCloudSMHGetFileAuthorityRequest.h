//
//  QCloudSMHGetFileAuthorityRequest.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/8/17.
//

#import "QCloudSMHBaseRequest.h"
#import "QCloudFileAutthorityInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 查看文件共享权限列表
 */
@interface QCloudSMHGetFileAuthorityRequest : QCloudSMHBaseRequest

/**
 目录路径或相簿名，对于多级目录，使用斜杠(/)分隔，例如 foo/bar；对于根目录，该参数留空；
 */
@property (nonatomic,strong)NSString * dirPath;

/**
 文件的媒体库ID，必选参数；
 */
@property (nonatomic,strong)NSString * dirLibraryId;

/**
 文件的空间ID，必选参数；
 */
@property (nonatomic,strong)NSString * dirSpaceId;

/**
 用户访问令牌，必选参数；
 */
@property (nonatomic,strong)NSString * userToken;

/**
 组织 ID，必选参数；
 */
@property (nonatomic,strong)NSString * organizationId;

- (void)setFinishBlock:(void (^)(NSArray <QCloudFileAutthorityInfo *> *_Nullable result, NSError * _Nullable error))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
