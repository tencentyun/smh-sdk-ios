#import "QCloudSMHM3u8UploadInfo.h"
#import <QCloudCore/NSObject+QCloudModel.h>

@implementation QCloudSMHM3u8UploadInfo

@end

@implementation QCloudSMHM3u8PrepareResult

/// 自定义反序列化：将 segments 字典中的子字典转为 QCloudSMHM3u8UploadInfo 模型对象
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // playlist 子字典 → QCloudSMHM3u8UploadInfo
    id playlistValue = dic[@"playlist"];
    if ([playlistValue isKindOfClass:[NSDictionary class]]) {
        _playlist = [QCloudSMHM3u8UploadInfo qcloud_modelWithDictionary:playlistValue];
    }
    // segments: { "dir/1.ts": { domain, path, ... }, ... } → NSDictionary<NSString *, QCloudSMHM3u8UploadInfo *>
    id segmentsValue = dic[@"segments"];
    if ([segmentsValue isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary<NSString *, QCloudSMHM3u8UploadInfo *> *result = [NSMutableDictionary dictionary];
        [(NSDictionary *)segmentsValue enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                QCloudSMHM3u8UploadInfo *info = [QCloudSMHM3u8UploadInfo qcloud_modelWithDictionary:obj];
                if (info) {
                    result[key] = info;
                }
            }
        }];
        _segments = [result copy];
    }
    return YES;
}

@end

@implementation QCloudSMHM3u8QuickUploadResult

@end

@implementation QCloudSMHM3u8ConfirmPlaylistInfo

@end

@implementation QCloudSMHM3u8ConfirmResult

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"playlist": [QCloudSMHM3u8ConfirmPlaylistInfo class]};
}

@end

@implementation QCloudSMHM3u8RenewResult

/// 自定义反序列化：将 playlist 和 segments 字典转为模型对象
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // playlist 子字典 → QCloudSMHM3u8UploadInfo
    id playlistValue = dic[@"playlist"];
    if ([playlistValue isKindOfClass:[NSDictionary class]]) {
        _playlist = [QCloudSMHM3u8UploadInfo qcloud_modelWithDictionary:playlistValue];
    }
    // segments: { "dir/1.ts": { domain, path, ... }, ... }
    id segmentsValue = dic[@"segments"];
    if ([segmentsValue isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary<NSString *, QCloudSMHM3u8UploadInfo *> *result = [NSMutableDictionary dictionary];
        [(NSDictionary *)segmentsValue enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                QCloudSMHM3u8UploadInfo *info = [QCloudSMHM3u8UploadInfo qcloud_modelWithDictionary:obj];
                if (info) {
                    result[key] = info;
                }
            }
        }];
        _segments = [result copy];
    }
    return YES;
}

@end

@implementation QCloudSMHM3u8ModifyResult

/// 自定义反序列化：将 segments 字典转为模型对象
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    id segmentsValue = dic[@"segments"];
    if ([segmentsValue isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary<NSString *, QCloudSMHM3u8UploadInfo *> *result = [NSMutableDictionary dictionary];
        [(NSDictionary *)segmentsValue enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                QCloudSMHM3u8UploadInfo *info = [QCloudSMHM3u8UploadInfo qcloud_modelWithDictionary:obj];
                if (info) {
                    result[key] = info;
                }
            }
        }];
        _segments = [result copy];
    }
    return YES;
}

@end
