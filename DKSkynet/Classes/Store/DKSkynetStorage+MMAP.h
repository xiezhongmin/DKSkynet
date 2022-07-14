//
//  DKSkynetStorage+MMAP.h
//  DKSkynet
//
//  Created by admin on 2022/7/4.
//

#import "DKSkynetStorage.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kMmapPathExtension;
extern NSString * const kFilePathExtension;

@interface DKSkynetStorage (MMAP)

- (NSString *)loadMmapContentFromDirectory:(NSString *)directory fileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
