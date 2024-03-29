//
//  QCloudSMHTemporaryUserResult.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2023/1/10.
//

#import <Foundation/Foundation.h>
@class QCloudSMHTemporaryUserItem;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHTemporaryUserResult : NSObject

@property (nonatomic,strong) NSString *totalNum;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,strong) NSArray <QCloudSMHTemporaryUserItem *>*contents;

@end

@interface QCloudSMHTemporaryUserItem : NSObject

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *orgId;
@property (nonatomic,strong) NSString *countryCode;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSString *enabled;
@property (nonatomic,strong) NSString *avatar;

@end

NS_ASSUME_NONNULL_END








