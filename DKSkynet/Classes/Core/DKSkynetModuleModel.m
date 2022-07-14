//
//  DKSkynetModuleModel.m
//  DKSkynet
//
//  Created by admin on 2022/5/26.
//

#import "DKSkynetModuleModel.h"

@implementation DKSkynetModuleModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.subPlugins = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray<DKSkynetModuleModel *> *)sortedSubPlugins
{
    NSMutableArray *sortArray = [self.subPlugins mutableCopy];
    [sortArray sortUsingComparator:^NSComparisonResult(DKSkynetModuleModel * _Nonnull obj1, DKSkynetModuleModel *  _Nonnull obj2) {
        if (obj1.prioprity > obj2.prioprity) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    return sortArray;
}

- (BOOL)isEqual:(DKSkynetModuleModel *)object
{
    return [self.pluginId isEqualToString:object.pluginId];
}

@end
