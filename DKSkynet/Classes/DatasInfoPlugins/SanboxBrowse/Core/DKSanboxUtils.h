//
//  DKSanboxUtils.h
//  DKSkynet
//
//  Created by admin on 2022/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKSanboxUtils : NSObject

@property (nonatomic, assign) NSInteger fileSize;
@property (nonatomic, strong) NSMutableArray *bigFileArray;

/// 获取某一条文件路径的文件大小
- (void)getFileSizeWithPath:(NSString *)path;

/// share url
+ (void)shareURL:(NSURL *)url formVC:(UIViewController *)vc;

/// share object
+ (void)share:(id)object formVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
