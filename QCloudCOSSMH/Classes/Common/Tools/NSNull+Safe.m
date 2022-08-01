//
//  NSNull+Safe.m
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/23.
//

#import "NSNull+Safe.h"

@implementation NSNull (Safe)

-(NSInteger)length{
    return 0;
}

- (BOOL)isEqualToString:(NSString *)aString{
    return NO;
}

-(NSInteger)integerValue{
    return 0;
}

-(int)intValue{
    return 0;
}

-(double)doubleValue{
    return 0.0;
}

-(float)floatValue{
    return 0.f;
}

-(NSString *)stringValue{
    return @"";
}

-(BOOL)boolValue{
    return NO;
}

-(long long)longLongValue{
    return 0;
}

- (BOOL)hasPrefix:(NSString *)str{
    return NO;
}
- (BOOL)hasSuffix:(NSString *)str{
    return NO;
}


@end
