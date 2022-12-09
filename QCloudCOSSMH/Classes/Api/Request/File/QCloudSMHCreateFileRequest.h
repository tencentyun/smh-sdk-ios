//
//  QCloudSMHCreateFileRequest.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/7/27.
//

#import "QCloudSMHBizRequest.h"
#import "QCloudSMHContentInfo.h"
NS_ASSUME_NONNULL_BEGIN

/**
 用模板创建文件
 用模板创建文件时如果文件已存在，则自动重命名；
 */
@interface QCloudSMHCreateFileRequest : QCloudSMHBizRequest

/// 完整文件路径，例如 foo/bar/file_new.docx
@property (nonatomic,strong)NSString *filePath;

/// fromTemplate: 模板名字，当前支持 word.docx、excel.xlsx 和 powerpoint.pptx，必选参数；
@property (nonatomic,assign)QCloudSMHFileTemplate fromTemplate;

-(void)setFinishBlock:(void (^ _Nullable)(QCloudSMHContentInfo * _Nullable result, NSError * _Nullable error ))QCloudRequestFinishBlock;
@end

NS_ASSUME_NONNULL_END
