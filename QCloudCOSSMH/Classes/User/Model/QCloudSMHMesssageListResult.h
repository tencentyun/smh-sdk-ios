//
//  QCloudSMHMesssageListResult.h
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHMessageInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHMesssageListResult : NSObject

/// 所有类型下的总数
@property (nonatomic, assign) NSInteger allMessageNum;
/// 当返回的条目被截断需要分页获取下一页时返回该字段，在请求下一页时该字段的值即为 NextMarker 参数值；当返回的条目没有被截断即无需继续获取下一页时，不返回该字段；
@property (nonatomic, copy) NSString *nextMarker;
/// 当前分类下的消息数量
@property (nonatomic, assign) NSInteger totalNum;
/// 未读消息数量
@property (nonatomic, assign) NSInteger unreadMessageNumber;
/// 未读告警消息数量
@property (nonatomic, assign) NSInteger unreadWarnMessageNumber;
/// 未读系统消息数量
@property (nonatomic, assign) NSInteger unreadSystemMessageNumber;
@property (nonatomic,strong) NSArray<QCloudSMHMessageInfo *> * contents;
@end

NS_ASSUME_NONNULL_END
