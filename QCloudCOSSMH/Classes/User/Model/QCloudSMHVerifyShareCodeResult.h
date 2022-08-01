//
//  QCloudSMHVerifyShareCodeResult.h
//  Pods
//
//  Created by garenwang on 2021/11/25.
//

NS_ASSUME_NONNULL_BEGIN

/**
 验证提取码。
 若不需要提取码，也需要调用该接口获取查询文件目录 access_token。
 */
@interface QCloudSMHVerifyShareCodeResult : NSObject

///  存储库
@property (nonatomic,strong) NSString *libraryId;

///  空间ID
@property (nonatomic,strong) NSString *spaceId;

///  访问 api 凭证，调用 api 保存至网盘接口时，当做 share_access_token 传入
@property (nonatomic,strong) NSString *accessToken;

/// : 整数，访问令牌的有效时长，单位为秒
@property (nonatomic,strong) NSString *expiresIn;
@end

NS_ASSUME_NONNULL_END
