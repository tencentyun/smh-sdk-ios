//
//  QCloudSMHListHistoryVersionResult.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/18.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHHistoryVersionInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHListHistoryVersionResult : NSObject

/// 当返回的条目被截断需要分页获取下一页时返回该字段，在请求下一页时该字段的值即为 NextMarker 参数值；当返回的条目没有被截断即无需继续获取下一页时，不返回该字段；
@property (nonatomic, copy) NSString *nextMarker;
@property (nonatomic, assign) NSInteger totalNum;

/// 对象数组，目录或相簿内的具体内容
@property (nonatomic, strong) NSArray <QCloudSMHHistoryVersionInfo *>*contents;
@end

NS_ASSUME_NONNULL_END
