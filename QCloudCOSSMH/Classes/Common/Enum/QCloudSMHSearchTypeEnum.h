//
//  QCloudSMHSearchTypeEnum.h
//  QCloudCOSSMH
//
//  Created by karisli(李雪) on 2021/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(uint8_t, QCloudSMHSearchType) {
    //搜索所有类型文件和文件夹,当不传 type 或传空时默认为 all；
    QCloudSMHSearchTypeAll = 0,
    //仅搜索目录，不搜索文件；
    QCloudSMHSearchTypeDir,
    //仅搜索所有类型文件，不搜索目录；
    QCloudSMHSearchTypeFile,

    QCloudSMHSearchTypeImage,
    QCloudSMHSearchTypeVideo,
    QCloudSMHSearchTypeAudio,
    QCloudSMHSearchTypeWord,
    QCloudSMHSearchTypeExcel,
    QCloudSMHSearchTypePowerPoint,
    QCloudSMHSearchTypePdf,
    
    QCloudSMHSearchTypeDoc,
    QCloudSMHSearchTypeXls,
    QCloudSMHSearchTypePpt,
    QCloudSMHSearchTypeTxt,
    
};

NSString * QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchType type);

/// 根据文件名或文件内容搜索，"fileName"表示仅搜索文件名，"fileContents"表示仅搜索文件内容，"all"表示搜索文件名+文件内容
typedef NS_ENUM(NSUInteger, QCloudSMHSearchSearchByType) {
    QCloudSMHSearchSearchByAll = 0,
    QCloudSMHSearchSearchByFileName,
    QCloudSMHSearchSearchByFileContents,
};

NSString * QCloudSMHSearchByTypeByTransferToString(QCloudSMHSearchSearchByType type);
NS_ASSUME_NONNULL_END

