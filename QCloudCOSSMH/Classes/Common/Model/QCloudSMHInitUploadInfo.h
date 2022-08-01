//
//  QCloudSMHInitUploadInfo.h
//  QCloudSMHInitUploadInfo
//
//  Created by garenwang on 2021/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHInitUploadInfo : NSObject


///  字符串，实际上传文件时的域名；
@property (nonatomic, strong) NSString * domain;

/// 字符串，实际文件上传时的 URL 路径；
@property (nonatomic, strong) NSString * path;

/// 键值对，实际上传时需指定的请求头部
@property (nonatomic, strong) NSDictionary * headers;

@property (nonatomic, strong) NSString * uploadId;

/// 字符串，用于完成文件上传的确认参数；
@property (nonatomic, strong) NSString * confirmKey;

@property (nonatomic, strong) NSDate * expiration;


/// 是否需要刷新
-(BOOL)shouldRefreshWithOffest:(NSInteger)offset;

@end


NS_ASSUME_NONNULL_END
