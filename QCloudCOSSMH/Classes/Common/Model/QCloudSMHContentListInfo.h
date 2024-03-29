//
//  CBContentListInfo.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import "QCloudSMHContentInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHContentListInfo : NSObject
@property (nonatomic, strong) NSArray *paths;
/**
 当返回的条目被截断需要分页获取下一页时返回该字段，在请求下一页时该字段的值即为 NextMarker 参数值；当返回的条目没有被截断即无需继续获取下一页时，不返回该字段；
 */
@property (nonatomic, copy) NSString *nextMarker;

@property (nonatomic, copy) NSString *eTag;

/**
 整数，当前目录中的文件数（不包含孙子级）；
 */
@property (nonatomic, assign) NSInteger fileCount;
@property (nonatomic, assign) NSInteger totalNum;

/**
 整数，当前目录中的子目录数（不包含孙子级）
 */
@property (nonatomic, assign) NSInteger subDirCount;


/**
 对象数组，目录或相簿内的具体内容
 */
@property (nonatomic, strong) NSArray <QCloudSMHContentInfo *>*contents;
@property (nonatomic, strong)  QCloudSMHRoleInfo*authorityList;
@property (nonatomic, strong)  QCloudSMHButtonAuthority*authorityButtonList;

@end

NS_ASSUME_NONNULL_END
