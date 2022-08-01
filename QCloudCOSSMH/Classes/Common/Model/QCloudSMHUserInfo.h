//
//  QCloudSMHUserInfo.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHUserInfo : NSObject
@property (nonatomic,strong) NSString *name;


@property (nonatomic,strong) NSString *userId;

/// 组织ID
@property (nonatomic, copy) NSString * orgId;
@end

@interface QCloudSMHUploadPersonalInfoResult : NSObject
@property (nonatomic,strong) NSString *code;

@property (nonatomic,assign) NSInteger expiresIn;
@end

NS_ASSUME_NONNULL_END
