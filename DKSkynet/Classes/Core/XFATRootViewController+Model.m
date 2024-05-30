//
//  XFATRootViewController+Model.m
//  DKSkynet
//
//  Created by admin on 2022/5/27.
//

#import "XFATRootViewController+Model.h"
#import "DKKit.h"

@implementation XFATRootViewController (Model)

- (DKSkynetModuleModel *)model
{
    return [self dk_getAssociatedValueForKey:@selector(mode)];
}

- (void)setModel:(DKSkynetModuleModel *)model
{
    [self dk_setAssociateValue:model withKey:@selector(mode)];
}

@end
