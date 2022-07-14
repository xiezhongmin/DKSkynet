//
//  DKSkynetWebViewController.h
//  DKSkynet
//
//  Created by admin on 2022/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKSkynetWebViewController : UIViewController

- (id)initWithURL:(NSURL *)url;
- (id)initWithText:(NSString *)text;

+ (BOOL)supportsPathExtension:(NSString *)extension;

@end

NS_ASSUME_NONNULL_END
