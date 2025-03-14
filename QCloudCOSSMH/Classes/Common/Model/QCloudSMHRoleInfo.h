//
//  QCloudSMHRoleInfo.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2021/8/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudSMHRoleInfo : NSObject

@property (nonatomic,assign)BOOL canView;
@property (nonatomic,assign)BOOL canPreview;
@property (nonatomic,assign)BOOL canDownload;
@property (nonatomic,assign)BOOL canUpload;
@property (nonatomic,assign)BOOL canDelete;
@property (nonatomic,assign)BOOL canModify;
@property (nonatomic,assign)BOOL canAuthorize;
@property (nonatomic,assign)BOOL canShare;
@property (nonatomic,assign)BOOL canPreviewSelf;
@property (nonatomic,assign)BOOL canDownloadSelf;
@property (nonatomic,assign)BOOL canRestore;

@property (nonatomic,assign)BOOL isOwner;
@property (nonatomic,assign)BOOL isDefault;
@property (nonatomic,assign)NSInteger roleId;
@property (nonatomic,strong)NSString * libraryId;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * roleDesc;
@end

@interface QCloudSMHButtonAuthority : NSObject


/// : 布尔值，查看详情
@property (nonatomic,assign)BOOL showViewButton;

/// : 布尔值，预览
@property (nonatomic,assign)BOOL showPreviewButton;

/// : 布尔值，下载
@property (nonatomic,assign)BOOL showDownloadButton;

/// : 布尔值，上传
@property (nonatomic,assign)BOOL showUploadButton;

/// : 布尔值，删除
@property (nonatomic,assign)BOOL showDeleteButton;

/// : 布尔值，共享
@property (nonatomic,assign)BOOL showAuthorizeButton;

/// : 布尔值，分享
@property (nonatomic,assign)BOOL showShareButton;

/// : 布尔值，编辑
@property (nonatomic,assign)BOOL showModifyButton;

/// : 布尔值，移动
@property (nonatomic,assign)BOOL showMoveButton;

/// : 布尔值，重命名
@property (nonatomic,assign)BOOL showRenameButton;

/// : 布尔值，复制
@property (nonatomic,assign)BOOL showCopyButton;

/// : 布尔值，还原
@property (nonatomic,assign)BOOL showRestoreButton;
@end

NS_ASSUME_NONNULL_END
