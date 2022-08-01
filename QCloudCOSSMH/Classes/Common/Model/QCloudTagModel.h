//
//  QCloudTagModel.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/5/7.
//

#import <Foundation/Foundation.h>
@class QCloudFileTagModel;
@class QCloudSMHContentInfo;
NS_ASSUME_NONNULL_BEGIN

@interface QCloudTagModel : NSObject

@property (nonatomic,copy) NSString *tagId;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *type;

@end

@interface QCloudFileTagItemModel : NSObject

@property (nonatomic,copy) NSString *tagId;

@property (nonatomic,copy) NSString *tagName;

@property (nonatomic,copy) NSString *tagType;

@end

@interface QCloudFileQueryTagModel : NSObject

@property (nonatomic,copy) NSString *tagId;

@property (nonatomic,copy) NSString *tagValue;

@end

@interface QCloudQueryTagFilesInfo : NSObject

@property (nonatomic, assign) NSInteger totalNum;

/**
 对象数组，目录或相簿内的具体内容
 */
@property (nonatomic, strong) NSArray <QCloudSMHContentInfo *>*contents;

@end

NS_ASSUME_NONNULL_END
