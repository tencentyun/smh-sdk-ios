//
//  QCloudSMHGetFileListByTagsRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudTagModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QCloudFileQueryModel) {
    QCloudFileQueryModelAnd = 0,
    QCloudFileQueryModelOr,
};
/**
 用于根据标签筛选文件
 */
@interface QCloudSMHGetFileListByTagsRequest : QCloudSMHBizRequest

/**
 多标签查询方式，and：所有传入的标签都匹配时才返回（默认），or：任意标签匹配即返回，可选参数；
 */
@property (nonatomic, assign)QCloudFileQueryModel queryModel;

/**
 id: 标签 ID，必填； 注意：是从taglist接口中获取到的tagid
 value：标签值，可选，键值对标签才需要传；
 */
@property (nonatomic, strong)NSArray <QCloudFileQueryTagModel *> * tagList;

- (void)setFinishBlock:(void (^ _Nullable)(QCloudQueryTagFilesInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
