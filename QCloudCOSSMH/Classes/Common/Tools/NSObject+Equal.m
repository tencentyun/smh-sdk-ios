//
//  NSObject+Equal.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/30.
//

#import "NSObject+Equal.h"
#import <objc/runtime.h>

@implementation NSObject (Equal)

-(BOOL)smh_isEqual:(id)object{
    if (object == nil) {
        return NO;
    }
    if (object == self) {
        return YES;
    }
    
    if (![object isMemberOfClass:self.class]) {
        return NO;
    }
    
    if ([self isKindOfClass:NSString.class]) {
        return [((NSString *)object) isEqualToString:(NSString *)self];
    }
    
    if ([self isKindOfClass:NSNumber.class]) {
        return [((NSNumber *)object) isEqualToNumber:(NSNumber *)self];
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        NSArray * selfArray = (NSArray *)self;
        NSArray * objArray = (NSArray *)object;
        return [selfArray isEqualToArray:objArray];
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary * selfDic = (NSDictionary *)self;
        NSDictionary * objDic = (NSDictionary *)object;
        return [selfDic isEqualToDictionary:objDic];
    }
    
    if ([self isKindOfClass:[NSSet class]]) {
        NSSet * selfSet = (NSSet *)self;
        NSSet * objSet = (NSSet *)object;
        return [selfSet isEqualToSet:objSet];
    }
    
    NSDictionary * selfPro = [self getPropertyAndValueList];
    NSDictionary * objPro = [object getPropertyAndValueList];
    NSMutableDictionary * objMpro = objPro.mutableCopy;
    
    if (selfPro.allKeys.count != objPro.allKeys.count) {
        return NO;
    }
    
    if (selfPro.allKeys.count == objPro.allKeys.count == 0) {
        return YES;
    }
    
    for (NSString * key in selfPro.allKeys) {
        [objMpro removeObjectForKey:key];
        NSObject * value = [selfPro objectForKey:key];
        NSObject * objValue = [objPro objectForKey:key];
        if (![value smh_isEqual:objValue]) {
            return NO;
        }
    }

    if (objMpro.allKeys.count > 0) {
        return NO;
    }
    
    return YES;
}

-(NSDictionary *)getPropertyAndValueList{
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    unsigned int count = 0;
    
    objc_property_t * prolist = class_copyPropertyList([self class], &count);
    
    for (int i = 0 ;i < count; i ++) {
        objc_property_t pro = prolist[i];
        const char * name = property_getName(pro);
        NSString * nameStr = [[NSString alloc]initWithUTF8String:name];
        NSObject * value = [self valueForKey:nameStr];
        if (value != nil) {
            [dic setObject:value forKey:nameStr];
        }
    }
    free(prolist);
    return dic.copy;
}

@end
