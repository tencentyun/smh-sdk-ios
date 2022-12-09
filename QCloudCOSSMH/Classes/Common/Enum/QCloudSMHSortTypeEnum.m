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
