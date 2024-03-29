//
//  QCloudSSOListModel.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2024/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSSOListItem : NSObject
@property (nonatomic,copy) NSString * protocol;
@property (nonatomic,copy) NSString * alias;
@end

@interface QCloudSSOListModel : NSObject

// 字符串数组，已配置的 SSO 协议列表
@property (nonatomic,copy) NSArray <QCloudSSOListItem *> *list;

// 字符串，默认 SSO 协议，按照 Organization.extensionData.ssoWay 值返回
@property (nonatomic,copy) NSString * defaultType;
@end

NS_ASSUME_NONNULL_END
