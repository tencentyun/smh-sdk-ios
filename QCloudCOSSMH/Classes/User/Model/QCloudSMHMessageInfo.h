//
//  QCloudSMHMessageInfo.h
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHMessageTypeEnum.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHMessageInfo : NSObject

/// 消息ID
@property (nonatomic,assign) NSInteger messageID;
@property (nonatomic,strong) NSString *wsid;

/// 消息标题
@property (nonatomic,strong) NSString *title;

/// 消息内容
@property (nonatomic,strong) NSString *content;

/// 消息发送人ID
@property (nonatomic,strong) NSString *notifiedBy;

/// 消息发送人昵称，可空
@property (nonatomic,strong) NSString *notifiedByNickname;

/// 消息发送人头像
@property (nonatomic,strong) NSString *notifiedByAvatar;

/// 消息接收人ID
@property (nonatomic,strong) NSString *toUserId;

/// 消息接收人昵称，可空
@property (nonatomic,strong) NSString *toUserNickname;

/// 消息接收人头像
@property (nonatomic,strong) NSString *toUserAvatar;

/// 消息类型
@property (nonatomic,assign) QCloudSMHMessageType type;

/// 是否已读
@property (nonatomic,assign) BOOL hasRead;

/// 创建时间
@property (nonatomic,strong) NSString *creationTime;

/// 消息详细分类，可选值：
@property (nonatomic,assign) QCloudSMHMessageTypeDetail typeDetail;

/// icon 图标 
@property (nonatomic,assign) QCloudSMHMessageIconType iconType;

/// 外链类型，outside（跳外部链接）、inside-background-management（跳后台管理）
@property (nonatomic,assign) QCloudSMHMessageLinkType linkType;

/// 外链名称
@property (nonatomic,strong) NSString *linkName;

/// 外链 url
@property (nonatomic,strong) NSString *linkUrl;
@end

NS_ASSUME_NONNULL_END
