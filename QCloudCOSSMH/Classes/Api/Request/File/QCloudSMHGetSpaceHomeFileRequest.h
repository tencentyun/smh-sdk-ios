//
//  QCloudSMHGetSpaceHomeFileRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHSpaceHomeFileInfo.h"
#import "QCloudSMHSortTypeEnum.h"
#import "QCloudSMHCommonEnum.h"
NS_ASSUME_NONNULL_BEGIN

/**
 用于列出空间首页内容，会忽略目录的层级关系，列出空间下所有文件
 */
@interface QCloudSMHGetSpaceHomeFileRequest : QCloudSMHBizRequest

/// marker: 用于顺序列出分页的标识，可选参数，不传默认第一页；
@property (nonatomic,strong)NSString * marker;

/// limit: 用于顺序列出分页时本地列出的项目数限制，可选参数，不传则默认20；
@property (nonatomic,assign)NSInteger limit;

/**
 排序字段，按名称排序为 name（默认），
 按修改时间排序为 modificationTime，
 按文件大小排序为 size，
 按创建时间排序为 creationTime，
 按上传时间为 uploadTime，
 按照文件对应的本地创建时间排序为 localCreationTime，
 按照文件对应的本地修改时间排序为 localModificationTime；
 */
@property (nonatomic,assign)QCloudSMHSortType sortType;

/**
 筛选方式，必选，onlyDir 只返回文件夹，onlyFile 只返回文件；
 */
@property (nonatomic,assign)QCloudSMHDirectoryFilter directoryFilter;

/**
 文件自定义的分类,string类型,最大长度16字节， 可选，用户可通过更新文件接口修改文件的分类，也可以根据文件后缀预定义文件的分类信息;
 */
@property (nonatomic,strong)NSString * category;


/// 是否带文件路径，true|false，默认为 false，可选参数
@property (nonatomic,assign)BOOL withPath;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHSpaceHomeFileInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
