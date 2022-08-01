
#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
NS_ASSUME_NONNULL_BEGIN

@interface QCloudPutObjectRequest <BodyType> : QCloudBizHTTPRequest

@property (nonatomic, strong) BodyType body;

@property (nonatomic,strong)NSString * domain;

@property (nonatomic,strong)NSString * path;

@end
NS_ASSUME_NONNULL_END
