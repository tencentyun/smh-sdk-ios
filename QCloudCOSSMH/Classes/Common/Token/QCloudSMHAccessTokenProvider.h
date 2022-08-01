//
//  QCloudSignatureProvider.h
//  Pods
//
//  Created by Dong Zhao on 2017/3/31.
//
//


#import <Foundation/Foundation.h>

@class QCloudSMHBizRequest;
@class QCloudSMHSpaceInfo;
 
typedef void (^QCloudSMHAuthentationContinueBlock)(QCloudSMHSpaceInfo *spaceInfo, NSError *error);

/**
 生成一个有效的accesstoken;
*/
@protocol QCloudSMHAccessTokenProvider <NSObject>

/**
 获取accessToken
 */
- (void)accessTokenWithRequest:(QCloudSMHBizRequest *)request
                    urlRequest:(NSURLRequest *)urlRequst
                     compelete:(QCloudSMHAuthentationContinueBlock)continueBlock;
@end
