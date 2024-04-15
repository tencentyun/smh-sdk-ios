//
//  QCloudSMHGetRecentlyUsedFileRequest.h
//  Pods
//
//  Created by karisli(李雪) on 2021/9/10.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHRecentlyUsedFileInfo.h"
NS_ASSUME_NONNULL_BEGIN

/**
 查询最近使用的文件列表
 */
@interface QCloudSMHGetRecentlyUsedFileRequest : QCloudSMHBizRequest

/// marker: 用于顺序列出分页的标识，可选参数，不传默认第一页；
@property (nonatomic,strong)NSString * marker;

/// limit: 用于顺序列出分页时本地列出的项目数限制，可选参数，不传则默认20；
@property (nonatomic,assign)NSInteger limit;

/// FilterActionBy: 筛选操作方式，可选，不传返回全部，preview 只返回预览操作，modify 返回编辑操作；
@property (nonatomic,strong)NSString * filterActionBy;


/// 是否带文件路径，true|false，默认为 false，可选参数
@property (nonatomic,assign)BOOL withPath;

/// 筛选文件类型，可选参数，字符串数组，当前支持的类型包括：
/// all: 刷选所有类型文档
/// pdf: 仅搜索 PDF 文档，对应的文件扩展名为 .pdf；
/// powerpoint: 仅搜索演示文稿，如 .ppt、.pptx、.pot、.potx 等；
/// excel: 仅搜索表格文件，如 .xls、.xlsx、.ett、.xltx、.csv 等；
/// word: 仅搜索文档，如 .doc、.docx、.dot、.wps、.wpt 等；
/// text: 仅搜索纯文本，如 .txt、.asp、.htm 等；
/// doc、xls 或 ppt: 仅搜索 Word、Excel 或 Powerpoint 类型文档，对应的文件扩展名为 .doc(x)、.xls(x) 或 .ppt(x)；
/// 可以是文档后缀数组，如 ['.ppt', '.doc', '.excel']等；也可以是上述筛选类型数组，如 ['pdf', 'powerpoint', 'word'] 等
@property (nonatomic,strong)NSArray * type;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHRecentlyUsedFileInfo * _Nullable result , NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
