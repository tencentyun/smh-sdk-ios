//
//  QCloudSMHShareUserInfo.h
//  Pods
//
//  Created by garenwang on 2021/11/25.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHShareUserInfo : NSObject


///  分享 ID；
@property (nonatomic,strong) NSString * shareId;

///  分享文件名称集合
@property (nonatomic,strong) NSString *name;

///  是否需要提取码
@property (nonatomic,strong) NSString *needExtractionCode;

///  是否允许保存至网盘
@property (nonatomic,strong) NSString *canSaveToNetDisc;

///  过期时间
@property (nonatomic,strong) NSString *expireTime;

///  分享人 ID
@property (nonatomic,strong) NSString *userId;

///  分享人头像
@property (nonatomic,strong) NSString *userAvatar;

///  分享人昵称
@property (nonatomic,strong) NSString *userNickname;

///  布尔型，是否永久有效，可选参数，默认 false；
@property (nonatomic,assign) BOOL isPermanent;

/// 'personal', 表示个人版
/// 'team', 表示团队版
/// 'enterprise', 表示企业版
@property (nonatomic,assign) QCloudSMHOrganizationType editionFlag;
@end

NS_ASSUME_NONNULL_END
