//
//  QCloudSMHSortTypeEnum.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(uint8_t, QCloudSMHSortType) {
    QCloudSMHSortTypeNone                  = 0,  /**< 无排序方式，*/
    QCloudSMHSortTypeMTime                 = 1,  /**< 修改时间*/
    QCloudSMHSortTypeCTime                 = 2,  /**< 创建时间*/
    QCloudSMHSortTypeSize                  = 3,  /**< 大小 */
    QCloudSMHSortTypeName                  = 4,  /**< 名字排序 */
    QCloudSMHSortTypeExpireTime            = 5,  /**< 过期时间 */
    QCloudSMHSortTypeFavoriteTime          = 6,  /**< 收藏时间 */
    QCloudSMHSortTypeVisitTime             = 7,  /**< 访问时间 */
    QCloudSMHSortTypeRemainingTime         = 8,  /**< 剩余时间 */
    QCloudSMHSortTypeRemovalTime           = 9,   /**< 删除时间 */
    QCloudSMHSortTypeUploadTime            = 10,   /**< 上传时间 */
    QCloudSMHSortTypeLocalCreationTime           = 11,   /**< 本地创建时间 */
    QCloudSMHSortTypeLocalModificationTime           = 12,   /**< 本地修改时间 */
    
    QCloudSMHSortTypeMTimeReverse          = 101,  /**< 修改时间*/
    QCloudSMHSortTypeCTimeReverse          = 102,  /**< 创建时间*/
    QCloudSMHSortTypeSizeReverse           = 103,  /**< 大小 */
    QCloudSMHSortTypeNameReverse           = 104,  /**< 名字排序 */
    QCloudSMHSortTypeExpireTimeReverse     = 105,  /**< 过期时间 */
    QCloudSMHSortTypeFavoriteTimeReverse   = 106,  /**< 收藏时间 */
    QCloudSMHSortTypeVisitTimeReverse      = 107,  /**< 访问时间 */
    QCloudSMHSortTypeRemainingTimeReverse  = 108,  /**< 剩余时间 */
    QCloudSMHSortTypeRemovalTimeReverse    = 109,  /**< 删除时间 */
    QCloudSMHSortTypeUploadTimeReverse            = 110,   /**< 上传时间 */
    QCloudSMHSortTypeLocalCreationTimeReverse           = 111,   /**< 本地创建时间 */
    QCloudSMHSortTypeLocalModificationTimeReverse           = 112,   /**< 本地修改时间 */

};


NSString * QCloudSMHOrderByTransferToString(QCloudSMHSortType type);


/// 排序方式，支持 role | enabled | nickname，默认 role;
typedef NS_ENUM(NSUInteger, QCloudSMHGetTeamSortType) {
    QCloudSMHGetTeamSortByRole = 0,
    QCloudSMHGetTeamSortByEnabled = 1,
    QCloudSMHGetTeamSortByNickname = 2,
    QCloudSMHGetTeamSortByRoleAsc = 100,
    QCloudSMHGetTeamSortByEnabledAsc = 101,
    QCloudSMHGetTeamSortByNicknameAsc =102,
};


NSString * QCloudSMHGetTeamSortTypeTransferToString(QCloudSMHGetTeamSortType type);
NS_ASSUME_NONNULL_END

/**
 群组排序方式
 */
typedef NS_ENUM(NSUInteger, QCloudSMHGetGroupSortType) {
    QCloudSMHGroupSortTypeCreationTime     = 0,  /**< 创建时间 */
    QCloudSMHGroupSortTypeJoinTime     = 1,  /**< 加入时间 */
    
    QCloudSMHGroupSortTypeCreationTimeReverse     = 100,  /**< 创建时间 */
    QCloudSMHGroupSortTypeJoinTimeReverse     = 101,  /**< 加入时间 */
};

NS_ASSUME_NONNULL_BEGIN
NSString * QCloudSMHGetGroupSortTypeTransferToString(QCloudSMHGetGroupSortType type);
NS_ASSUME_NONNULL_END

/// 发起类型，own - 我发起的；join - 我加入的；all - 所有类型，默认所有类型，可选参数
typedef NS_ENUM(NSUInteger, QCloudSMHGroupJoinType) {
    QCloudSMHGroupJoinTypeAll     = 0,
    QCloudSMHGroupJoinTypeOwn     = 1,
    QCloudSMHGroupJoinTypeJoin    = 2,
    
};
NS_ASSUME_NONNULL_BEGIN
NSString * QCloudSMHGroupJoinTypeTransferToString(QCloudSMHGroupJoinType type);
NS_ASSUME_NONNULL_END

/// 排序方式，支持 groupRole | enabled | nickname，默认 groupRole;
typedef NS_ENUM(NSUInteger, QCloudSMHGroupMemberSortType) {
    QCloudSMHGroupMemberSortByRole = 0,
    QCloudSMHGroupMemberSortByEnabled = 1,
    QCloudSMHGroupMemberSortByNickname = 2,
    QCloudSMHGroupMemberSortByRoleAsc = 100,
    QCloudSMHGroupMemberSortByEnabledAsc = 101,
    QCloudSMHGroupMemberSortByNicknameAsc =102,
};

NS_ASSUME_NONNULL_BEGIN
NSString * QCloudSMHGroupMemberSortTypeTransferToString(QCloudSMHGroupMemberSortType type);
NS_ASSUME_NONNULL_END

/// 排序方式，支持 enabled | nickname，
typedef NS_ENUM(NSUInteger, QCloudSMHTemporaryUserSortType) {
    QCloudSMHTemporaryUserSortNone = 0,
    QCloudSMHTemporaryUserSortByEnabled = 1,
    QCloudSMHTemporaryUserSortByNickname = 2,
    
    QCloudSMHTemporaryUserSortByEnabledAsc = 101,
    QCloudSMHTemporaryUserSortByNicknameAsc = 102,
};

NS_ASSUME_NONNULL_BEGIN
NSString * QCloudSMHTemporaryUserSortTypeTransferToString(QCloudSMHTemporaryUserSortType type);
NS_ASSUME_NONNULL_END

/// name, expireTime, nickname, shareTraffic
typedef NS_ENUM(NSUInteger, QCloudSMHShareSortType) {
    QCloudSMHShareSortTypeName = 0,
    QCloudSMHShareSortTypeExpireTime = 1,
    QCloudSMHShareSortTypeNickname = 2,
    QCloudSMHShareSortTypeShareTraffic = 3,
    
    QCloudSMHShareSortTypeNameAsc = 100,
    QCloudSMHShareSortTypeExpireTimeAsc = 101,
    QCloudSMHShareSortTypeNicknameAsc = 102,
    QCloudSMHShareSortTypeShareTrafficAsc = 103,
};

NS_ASSUME_NONNULL_BEGIN
NSString * QCloudSMHShareSortTypeTransferToString(QCloudSMHShareSortType type);
NS_ASSUME_NONNULL_END

typedef NS_ENUM(NSUInteger, QCloudSMHApplySortType) {
    QCloudSMHApplySortTypeCreationTime = 0,
    QCloudSMHApplySortTypeOperationTime = 1,
    
    QCloudSMHApplySortTypeCreationTimeAsc = 100,
    QCloudSMHApplySortTypeOperationTimeAsc = 101,
};

NS_ASSUME_NONNULL_BEGIN
NSString * QCloudSMHApplySortTypeTransferToString(QCloudSMHApplySortType type);
NS_ASSUME_NONNULL_END

