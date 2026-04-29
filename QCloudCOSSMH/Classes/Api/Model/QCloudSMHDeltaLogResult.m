#import "QCloudSMHDeltaLogResult.h"

@implementation QCloudSMHDeltaEntry
@end

@implementation QCloudSMHDeltaLogResult

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"contents": QCloudSMHDeltaEntry.class};
}

@end
