//
//  DKSkynetModuleModel.h
//  DKSkynet
//
//  Created by admin on 2022/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DKSkynetItemView;

@interface DKSkynetModuleModel : NSObject

@property (nonatomic, copy) NSString *pluginId;
@property (nonatomic, copy) NSString *pluginName;
@property (nonatomic, copy) NSString *pluginImageName;
@property (nonatomic, copy) NSString *pluginHighLightName;
@property (nonatomic, copy) NSString *pluginHighLightImageName;
@property (nonatomic, assign) NSInteger prioprity;
@property (nonatomic, copy) NSString *superPluginId;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, strong) id slf;
@property (nonatomic) void (*didStart)(id slf, SEL cmd, BOOL *isHightLight);
@property (nonatomic) void (*didStop)(id slf, SEL cmd);
@property (nonatomic, weak) DKSkynetItemView *itemView;
@property (nonatomic, strong) NSMutableArray <DKSkynetModuleModel *>*subPlugins;

- (NSMutableArray <DKSkynetModuleModel *> *)sortedSubPlugins;

@end

NS_ASSUME_NONNULL_END
