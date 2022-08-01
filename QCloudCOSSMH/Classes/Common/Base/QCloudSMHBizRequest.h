//
//  QCloudSMHBizRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/17.
// 需要访问令牌(accessToken)的request的基类

#import "QCloudSMHBaseRequest.h"
#import "QCloudSMHAccessTokenProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHBizRequest : QCloudSMHBaseRequest

@property (nonatomic, assign) id <QCloudSMHAccessTokenProvider> accessTokenProvider;



/**
媒体库 ID，必选参数
*/
@property (nonatomic,strong)NSString *libraryId;

/**
空间 ID，如果媒体库为单租户模式，则该参数固定为连字符(-)；如果媒体库为多租户模式，则必须指定该参数
*/
@property (nonatomic,strong)NSString *spaceId;

/**
 空间所在组织id,仅访问外部群组时需要填写该字段;
 */
@property (nonatomic,strong)NSString *spaceOrgId;

/**
用户身份识别，当访问令牌对应的权限为管理员权限且申请访问令牌时的用户身份识别为空时用来临时指定用户身份，详情请参阅生成访问令牌接口
*/
@property (nonatomic,strong)NSString *userId;


-(void)updateLibraryId:(NSString *)libraryId;

@end

NS_ASSUME_NONNULL_END
