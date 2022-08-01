//
//  QCloudSMHSpaceInfo.h
//  AOPKit
//
//  Created by karisli(李雪) on 2021/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHSpaceInfo : NSObject
@property (nonatomic, strong) NSString *libraryId;
@property (nonatomic, strong) NSString *spaceId;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *expiresIn;
@end

@interface QCloudSMHSpaceInfo (BeginDate)
@property (nonatomic, strong) NSDate *beginDate;
@end

NS_ASSUME_NONNULL_END
