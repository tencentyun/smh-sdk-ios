//
//  QCloudSMHINodeDetailInfo.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2024/3/28.
//

#import "QCloudSMHINodeDetailInfo.h"

@implementation QCloudSMHINodeDetailInfo
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    NSMutableDictionary *transfromDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *COSAccountTypeenumValue = transfromDic[@"type"];
    if (COSAccountTypeenumValue && [COSAccountTypeenumValue isKindOfClass:[NSString class]] && COSAccountTypeenumValue.length > 0) {
        NSInteger value = QCloudSMHContentInfoTypeDumpFromString(COSAccountTypeenumValue);
        transfromDic[@"type"] = @(value);
    }
    
    return transfromDic;
}
@end
