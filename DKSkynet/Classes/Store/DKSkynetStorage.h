//
//  DKSkynetStorage.h
//  DKSkynet
//
//  Created by admin on 2022/6/30.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DKSkynetStoreDirectoryOption) {
    DKSkynetStoreDirectoryOptionDocument,  // default
    DKSkynetStoreDirectoryOptionLibraryCaches,
    DKSkynetStoreDirectoryOptionTmp
};

/// 根目录
static NSString * const kDKSynetRootStoreDirectory = @"/com.duke.skynet";
/// 文件保活天数, 超过自动裁剪掉
static NSInteger const kDKSynetStoreFileKeepActive = 7;
/// 默认 Directory Option
static DKSkynetStoreDirectoryOption gDKSkynetStoreDirectoryOption = DKSkynetStoreDirectoryOptionDocument;

@interface DKSkynetStorage : NSObject

@property (nonatomic, copy, readonly) NSString *storeDirectory;
@property (nonatomic, readonly) dispatch_queue_t storeQueue;

+ (instancetype)shared;

/// 设置 Directory Option
/// @param option option description
+ (void)setStoreDirectoryOption:(DKSkynetStoreDirectoryOption)option;

/// 获取所有的日志路径
- (NSArray <NSString *> *)getStoreAllFilesPaths;

/// 获取所有的日志目录路径
- (NSArray <NSString *> *)getStoreDirectoriesPaths;

/// 获取所有日志文件大小总和
- (double)getStoreAllFilesTotalSize;

/// 清除所有日志
- (void)clearAllStoreDirectories:(void (^)(double totalClearedSize, NSError *error))complete;

@end

NS_ASSUME_NONNULL_END
