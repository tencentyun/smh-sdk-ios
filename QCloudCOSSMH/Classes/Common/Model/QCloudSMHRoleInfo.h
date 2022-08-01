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
@property (nonatomic,strong)NSString * roleId;
@property (nonatomic,strong)NSString * libraryId;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * roleDesc;
@end


NS_ASSUME_NONNULL_END
