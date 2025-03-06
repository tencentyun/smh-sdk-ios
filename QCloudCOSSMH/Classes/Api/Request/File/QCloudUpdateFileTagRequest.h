//
//  QCloudUpdateFileTagRequest.h
//  Pods
//
//  Created by garenwang(王博) on 2025/2/27.
//

#import "QCloudSMHBizRequest.h"

NS_ASSUME_NONNULL_BEGIN
/**
 用于更新文件的标签（Labels）或分类（Category）
 */
@interface QCloudUpdateFileTagRequest : QCloudSMHBizRequest

/**
 文件路径；
 */
@property (nonatomic,strong)NSString * filePath;

/**
 文件自定义的分类,string类型,最大长度16字节， 可选，用户可通过更新文件接口修改文件的分类，也可以根据文件后缀预定义文件的分类信息。
 */
@property (nonatomic,strong)NSString * category;

/**
 文件对应的本地创建时间，时间戳字符串，可选参数；
 */
@property (nonatomic,strong) NSString * localCreationTime;

/**
 文件对应的本地修改时间，时间戳字符串，可选参数；
 */
@property (nonatomic,strong) NSString * localModificationTime;

/**
 文件标签列表, 比如 ["动物", "大象", "亚洲象"]
 */
@property (nonatomic,strong) NSArray <NSString *> * labels;

@end

NS_ASSUME_NONNULL_END
