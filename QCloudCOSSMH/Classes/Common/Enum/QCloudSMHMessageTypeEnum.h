//
//  QCloudSMHMessageTypeEnum.h
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, QCloudSMHMessageType) {
    QCloudSMHMessageTypeAll = 0,
    QCloudSMHMessageTypeSystem,
    QCloudSMHMessageTypeWarning,
};

typedef NS_ENUM(NSUInteger, QCloudSMHMessageLinkType) {
    QCloudSMHMessageLinkNone = 0, 
    QCloudSMHMessageLinkOutside , /// 跳外部链接
    QCloudSMHMessageLinkInsideBackgroundManagement, /// 跳后台管理
};
QCloudSMHMessageLinkType  QCloudSMHMessageLinkTypeFromString(NSString *key);

typedef NS_ENUM(NSUInteger, QCloudSMHMessageTypeDetail) {
    QCloudSMHMessageTypeAuthorityAndSettingMsg = 0,
    QCloudSMHMessageTypeShareMsg,
    QCloudSMHMessageTypeEsignMsg,
    QCloudSMHMessageTypeUserManageMsg,
    QCloudSMHMessageTypeQuotaAndRenewMsg
};

QCloudSMHMessageTypeDetail  QCloudSMHMessageTypeDetailFromString(NSString *key);


typedef NS_ENUM(NSUInteger, QCloudSMHMessageIconType) {
    QCloudSMHMessageIconTypeAdd = 0, // 加号
    QCloudSMHMessageIconTypeMinus, // 减号
    QCloudSMHMessageIconTypeWarn,  // 感叹号
    QCloudSMHMessageIconTypeOther, // 其他
};

QCloudSMHMessageIconType  QCloudSMHMessageIconTypeFromString(NSString *key);

NS_ASSUME_NONNULL_END
