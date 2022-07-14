//
//  DKAssistiveTouchItemView.h
//  DKSkynet
//
//  Created by admin on 2022/5/26.
//

#import "XFATItemView.h"
#import "DKSkynetModuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKSkynetItemView : XFATItemView

- (void)dealWithModuleSelected:(BOOL)isSeleted;

- (void)configWithModel:(DKSkynetModuleModel *)model;

@end

NS_ASSUME_NONNULL_END
