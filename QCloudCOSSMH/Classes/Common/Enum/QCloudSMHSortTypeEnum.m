//
//  QCloudSMHOrderTypeEnum.m
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/26.
//

#import "QCloudSMHSortTypeEnum.h"

NSString * QCloudSMHOrderByTransferToString(QCloudSMHSortType type){
    switch (type) {
        case QCloudSMHSortTypeName:
            return @"name";
        case QCloudSMHSortTypeMTime:
            return @"modificationTime";
        case QCloudSMHSortTypeSize:
            return @"size";
        case QCloudSMHSortTypeCTime:
            return @"creationTime";
        case QCloudSMHSortTypeExpireTime:
            return @"expireTime";
        case QCloudSMHSortTypeFavoriteTime:
            return @"favoriteTime";
        case QCloudSMHSortTypeVisitTime:
            return @"visitTime";
        case QCloudSMHSortTypeRemovalTime:
            return @"removalTime";
        case QCloudSMHSortTypeRemainingTime:
            return @"remainingTime";
        default:
            break;
    }
    return @"name";
}

NSString * QCloudSMHGetGroupSortTypeTransferToString(QCloudSMHGetGroupSortType type){
    switch (type) {
        case QCloudSMHGroupSortTypeCreationTime:
        case QCloudSMHGroupSortTypeCreationTimeReverse:
            return @"creationTime";
        case QCloudSMHGroupSortTypeJoinTime:
        case QCloudSMHGroupSortTypeJoinTimeReverse:
            return @"joinTime";
        default:
            break;
    }
    return @"";
}


NSString * QCloudSMHGroupMemberSortTypeTransferToString(QCloudSMHGroupMemberSortType type){
    switch (type) {
        case QCloudSMHGroupMemberSortByRole:
        case QCloudSMHGroupMemberSortByRoleAsc:
            return @"groupRole";
        case QCloudSMHGroupMemberSortByEnabled:
        case QCloudSMHGroupMemberSortByEnabledAsc:
            return @"enabled";
        case QCloudSMHGroupMemberSortByNickname:
        case QCloudSMHGroupMemberSortByNicknameAsc:
            return @"nickname";
        default:
            break;
    }
    return @"";
}

NSString * QCloudSMHGroupJoinTypeTransferToString(QCloudSMHGroupJoinType type){
    
    
    switch (type) {
        case QCloudSMHGroupJoinTypeOwn:
            return @"own";
        case QCloudSMHGroupJoinTypeJoin:
            return @"join";
        case QCloudSMHGroupJoinTypeAll:
        default:
            return @"all";
            break;
    }
}

NSString * QCloudSMHTemporaryUserSortTypeTransferToString(QCloudSMHTemporaryUserSortType type){
    switch (type) {
        case QCloudSMHTemporaryUserSortByEnabled:
        case QCloudSMHTemporaryUserSortByEnabledAsc:
            return @"enabled";
        case QCloudSMHTemporaryUserSortByNickname:
        case QCloudSMHTemporaryUserSortByNicknameAsc:
            return @"nickname";
        case QCloudSMHTemporaryUserSortNone:
        default:
            return @"";
    }
}
/// name, expireTime,nickname , shareTraffic
NSString * QCloudSMHShareSortTypeTransferToString(QCloudSMHShareSortType type){
    switch (type) {
        case QCloudSMHShareSortTypeName:
        case QCloudSMHShareSortTypeNameAsc:
            return @"name";
            break;
        
        case QCloudSMHShareSortTypeExpireTime:
        case QCloudSMHShareSortTypeExpireTimeAsc:
            return @"expireTime";
            break;
        case QCloudSMHShareSortTypeNickname:
        case QCloudSMHShareSortTypeNicknameAsc:
            return @"nickname";
            break;
        case QCloudSMHShareSortTypeShareTraffic:
        case QCloudSMHShareSortTypeShareTrafficAsc:
            return @"shareTraffic";
            break;
        default:
            return @"expireTime";
            break;
    }
}

NSString * QCloudSMHApplySortTypeTransferToString(QCloudSMHApplySortType type){
    switch (type) {
        case QCloudSMHApplySortTypeCreationTime:
        case QCloudSMHApplySortTypeCreationTimeAsc:
            return @"creationTime";
            break;
        case QCloudSMHApplySortTypeOperationTime:
        case QCloudSMHApplySortTypeOperationTimeAsc:
            return @"operationTime";
            break;
        default:
            return @"creationTime";
            break;
    }
}
