//
//  DKNetworkObserver.h
//  DKSkynet
//
//  Created by admin on 2022/6/14.
//

#import <Foundation/Foundation.h>
#import "NSURLConnectionDKHelpers.h"
#import "NSURLSessionTaskDKHelpers.h"

@interface DKNetworkObserver : NSObject <NSURLConnectionDKHelpers, NSURLSessionTaskDKHelpers>

/// Swizzling occurs when the observer is enabled for the first time.
/// NOTE: this setting persists between launches of the app.
@property (nonatomic, class, getter=isEnabled) BOOL enabled;

@end

