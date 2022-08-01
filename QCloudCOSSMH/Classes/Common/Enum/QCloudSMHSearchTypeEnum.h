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
    QCloudSMHSearchTypeAll= 0,
    //仅搜索目录，不搜索文件；
    QCloudSMHSearchTypeDir,
    //仅搜索所有类型文件，不搜索目录；
    QCloudSMHSearchTypeFile,

    QCloudSMHSearchTypeDoc,
    QCloudSMHSearchTypeXls,
    QCloudSMHSearchTypePpt,
    QCloudSMHSearchTypeTxt,
    QCloudSMHSearchTypePdf,
    QCloudSMHSearchTypeImage,
    QCloudSMHSearchTypeVideo,
    QCloudSMHSearchTypeAudio,


};

NSString * QCloudSMHSearchTypeByTransferToString(QCloudSMHSearchType type);
NS_ASSUME_NONNULL_END

