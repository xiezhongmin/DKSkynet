//
//  DKSkynet.h
//  DKSkynet
//
//  Created by admin on 2022/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DKSkynetPlugin;

@interface DKSkynet : NSObject

+ (instancetype)shared;

+ (void)registerPlugin:(id <DKSkynetPlugin>)plugin;

- (void)startServer;

- (void)stopServer;


@end

NS_ASSUME_NONNULL_END
