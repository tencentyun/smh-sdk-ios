//
//  QCloudSMHTeamInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/19.
//

#import <Foundation/Foundation.h>
@class QCloudSMHTeamInfoPathNode;
NS_ASSUME_NONNULL_BEGIN



@interface QCloudSMHTeamInfo : NSObject

/// 当返回的条目被截断需要分页获取下一页时返回该字段，在请求下一页时该字段的值即为 NextMarker 参数值；当返回的条目没有被截断即无需继续获取下一页时，不返回该字段；
@property (nonatomic, copy) NSString *nextMarker;

/// 整数，团队 ID；
@property (nonatomic,strong) NSString * teamId;

///  整数，组织 ID；
@property (nonatomic,strong) NSString *orgId;

/// 字符串，团队名称；
@property (nonatomic,strong) NSString *name;

/// 整数，父团队 ID；
@property (nonatomic,assign) NSInteger parentId;

/// 字符串，团队空间 ID；
@property (nonatomic,strong) NSString *spaceId;

/// 整数，团队成员数量；
@property (nonatomic,assign) NSInteger userCount;

/// 整数，递归团队成员数量，仅当 WithRecursiveUserCount = 1 时返回；
@property (nonatomic,assign) NSInteger recursiveUserCount;

/// 对象数组，子级团队列表；
@property (nonatomic,strong) NSArray <QCloudSMHTeamInfo *>*children;

/// 字符串数组，团队的层级目录，假设团层级为 T1/T2/T3，则 T3 的 path 为 ['T1','T2','T3']，仅当 WithPath = ture 时返回；
@property (nonatomic,copy) NSArray *paths;

/// 整数，默认角色 ID；
@property (nonatomic,assign) NSInteger defaultRoleId;

/// 对象数组，团队层级目录对象，仅当 WithPath = 1 时返回；
@property (nonatomic,strong) NSArray <QCloudSMHTeamInfoPathNode *>*pathNodes;

@end

@interface QCloudSMHTeamInfoPathNode : NSObject

/// 整数，团队 ID；
@property (nonatomic,strong) NSString * teamId;

/// 字符串，团队名称；
@property (nonatomic,strong) NSString *name;
@end

@interface QCloudSMHSearchTeamInfo : NSObject

@property (nonatomic,strong)NSString *totalNum;

@property (nonatomic,strong)NSString *page;

@property (nonatomic,strong)NSString *pageSize;

@property (nonatomic,strong) NSArray <QCloudSMHTeamInfo *>*contents;
@end

NS_ASSUME_NONNULL_END
