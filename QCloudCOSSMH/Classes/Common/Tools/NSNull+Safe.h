//
//  NSNull+Safe.h
//  QCloudCOSSMH
//
//  Created by garenwang on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNull (Safe)
-(NSInteger)length;

- (BOOL)isEqualToString:(NSString *)aString;

-(NSInteger)integerValue;

-(int)intValue;

-(double)doubleValue;

-(float)floatValue;

-(NSString *)stringValue;

-(BOOL)boolValue;

-(long long)longLongValue;

- (BOOL)hasPrefix:(NSString *)str;

- (BOOL)hasSuffix:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
