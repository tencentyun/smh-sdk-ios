//
//  QCloudSMHMessageInfo.m
//  Pods
//
//  Created by karisli(李雪) on 2021/12/6.
//

#import "QCloudSMHMessageInfo.h"

@implementation QCloudSMHMessageInfo
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"messageID" : @"id",
    };
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    NSString *typeDetail = transfromDic[@"typeDetail"];
    if (typeDetail && [typeDetail isKindOfClass:[NSString class]] && typeDetail.length > 0) {
        NSInteger value = QCloudSMHMessageTypeDetailFromString(typeDetail);
        transfromDic[@"typeDetail"] = @(value);
    }
    
    NSString *linkType = transfromDic[@"linkType"];
    if (linkType && [linkType isKindOfClass:[NSString class]] && linkType.length > 0) {
        NSInteger value = QCloudSMHMessageLinkTypeFromString(linkType);
        transfromDic[@"linkType"] = @(value);
    }
    
    NSString *iconType = transfromDic[@"iconType"];
    if (iconType && [iconType isKindOfClass:[NSString class]] && iconType.length > 0) {
        NSInteger value = QCloudSMHMessageIconTypeFromString(iconType);
        transfromDic[@"iconType"] = @(value);
    }
    
    return transfromDic;
}


@end
