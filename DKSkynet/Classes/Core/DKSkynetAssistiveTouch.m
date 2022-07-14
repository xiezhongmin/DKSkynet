//
//  DKSkynetAssistiveTouch.m
//  DKSkynet
//
//  Created by admin on 2022/5/27.
//

#import "DKSkynetAssistiveTouch.h"
#import "XFAssistiveTouch.h"
#import "XFATRootViewController.h"
#import "DKSkynetNavigationController.h"
#import "XFATRootViewController+Model.h"
#import "DKSkynetItemView.h"
#import "DKSkynetPlugin.h"
#import <DKKit.h>

static double kDKSkynetHighMemoryUsage;
@interface DKSkynetAssistiveTouch () <XFXFAssistiveTouchDelegate, XFATRootViewControllerDelegate>

@property (nonatomic, weak) UILabel *cpuUsageLabel;
@property (nonatomic, weak) UILabel *memoryUsageLabel;
@property (nonatomic, weak) UILabel *fpsUsageLabel;
@property (nonatomic, assign) double highMemoryUsage;
@property (nonatomic, strong) NSMutableArray <DKSkynetModuleModel *>*tempSubPlugins;
@property (nonatomic, strong, readwrite) NSMutableArray <DKSkynetModuleModel *>*plugins;

@end

@implementation DKSkynetAssistiveTouch

+ (instancetype)shared
{
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        kDKSkynetHighMemoryUsage = ([NSProcessInfo processInfo].physicalMemory / 1024 / 1024) / 2;
        self.plugins = [[NSMutableArray alloc] init];
        self.tempSubPlugins = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)install
{
    [self setupWithAutoIndent:NO];
}

- (void)setupWithAutoIndent:(BOOL)autoIndent
{
    XFAssistiveTouch *assistiveTouch = [XFAssistiveTouch sharedInstance];
    XFATRootViewController *rootViewController = [XFATRootViewController new];
    DKSkynetNavigationController *nav = [[DKSkynetNavigationController alloc] initWithRootViewController:rootViewController];
    nav.autoIndent = autoIndent;
    [rootViewController dk_performSelectorWithArgs:@selector(setDelegate:), [XFAssistiveTouch sharedInstance]];
    [nav dk_performSelectorWithArgs:@selector(setDelegate:), [XFAssistiveTouch sharedInstance]];
    [[XFAssistiveTouch sharedInstance] setNavigationController:nav];
    assistiveTouch.delegate = self;
    [assistiveTouch showAssistiveTouch];
    
    [self buildUI];
    [self linkedPlugins];
}

- (void)buildUI
{
    XFATItemView *contentView = [[[XFAssistiveTouch sharedInstance] navigationController] valueForKey:@"contentItem"];
    [contentView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CGFloat margin = 2.f;
    CGFloat fontHeight = 13.f;
    UILabel *cpuUsageLabel = ({
        UILabel *cpuUsageLabel = [[UILabel alloc] init];
        cpuUsageLabel.textColor = [UIColor whiteColor];
        cpuUsageLabel.textAlignment = NSTextAlignmentCenter;
        cpuUsageLabel.font = [UIFont fontWithName: @"Menlo" size: fontHeight];
        cpuUsageLabel.frame = CGRectMake(0, margin, contentView.width, fontHeight);
        [contentView addSubview:cpuUsageLabel];
        cpuUsageLabel;
    });
    
    UILabel *memoryUsageLabel = ({
        UILabel *memoryUsageLabel = [[UILabel alloc] init];
        memoryUsageLabel.textColor = [UIColor whiteColor];
        memoryUsageLabel.textAlignment = NSTextAlignmentCenter;
        memoryUsageLabel.font = [UIFont fontWithName: @"Menlo" size: fontHeight];
        memoryUsageLabel.frame = CGRectMake(0, 0, contentView.width, fontHeight);
        memoryUsageLabel.centerY = contentView.height / 2;
        [contentView addSubview:memoryUsageLabel];
        memoryUsageLabel;
    });
    
    UILabel *fpsUsageLabel = ({
        UILabel *fpsUsageLabel = [[UILabel alloc] init];
        fpsUsageLabel.textColor = [UIColor whiteColor];
        fpsUsageLabel.textAlignment = NSTextAlignmentCenter;
        fpsUsageLabel.font = [UIFont fontWithName: @"Menlo" size: fontHeight];
        fpsUsageLabel.frame = CGRectMake(0, contentView.height - fontHeight - margin, contentView.width, fontHeight);
        [contentView addSubview:fpsUsageLabel];
        fpsUsageLabel;
    });
    
    self.cpuUsageLabel = cpuUsageLabel;
    self.memoryUsageLabel = memoryUsageLabel;
    self.fpsUsageLabel = fpsUsageLabel;
    
    int defaultFPS = 60;
    double defaultCPUUsage = 0.0, defaultMemoryUsage = 0.0;
    [self displayCPUUsage:defaultCPUUsage];
    [self displayMemoryUsage:defaultMemoryUsage];
    [self displayFPS:defaultFPS];
}

- (void)displayCPUUsage:(double)usage
{
    int use = usage;
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString: @"CPU" attributes: @{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: self.cpuUsageLabel.font }];
    [attributed appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d%%", use] attributes: @{ NSFontAttributeName: self.cpuUsageLabel.font, NSForegroundColorAttributeName: [UIColor colorWithHue: 0.27 * (0.8 - (use / 100.)) saturation: 1 brightness: 0.9 alpha: 1] }]];
    self.cpuUsageLabel.attributedText = attributed;
}

- (void)displayMemoryUsage:(double)usage
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat: @"%.1f", usage] attributes: @{ NSFontAttributeName: self.memoryUsageLabel.font, NSForegroundColorAttributeName: [UIColor colorWithHue: 0.27 * (0.8 - usage / kDKSkynetHighMemoryUsage) saturation: 1 brightness: 0.9 alpha: 1] }];
    [attributed appendAttributedString: [[NSAttributedString alloc] initWithString: @"MB" attributes: @{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: self.memoryUsageLabel.font }]];
    self.memoryUsageLabel.attributedText = attributed;
}

- (void)displayFPS:(int)fps
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", fps] attributes: @{ NSForegroundColorAttributeName: [UIColor colorWithHue: 0.27 * (fps / 60.0 - 0.2) saturation: 1 brightness: 0.9 alpha: 1], NSFontAttributeName: self.fpsUsageLabel.font }];
    [attributed appendAttributedString: [[NSAttributedString alloc] initWithString: @"FPS" attributes: @{ NSFontAttributeName: self.fpsUsageLabel.font, NSForegroundColorAttributeName: [UIColor whiteColor] }]];
    self.fpsUsageLabel.attributedText = attributed;
}

- (void)registerPluginWithModel:(DKSkynetModuleModel *)model
{
    if (!model) { return; }
    if (![model isKindOfClass:DKSkynetModuleModel.class]) { return; }
    if ([self.plugins containsObject:model]) { return; }
    
    if (model.isTop) {
        [self.plugins addObject:model];
    } else {
        [self.tempSubPlugins addObject:model];
    }
}

- (void)showTouch
{
    DKSkynetNavigationController *nav = (DKSkynetNavigationController *)[[XFAssistiveTouch sharedInstance] navigationController];
    if ([nav isKindOfClass:DKSkynetNavigationController.class]) {
        [nav showWithAnimation:true];
    }
}

- (void)dismissTouch
{
    DKSkynetNavigationController *nav = (DKSkynetNavigationController *)[[XFAssistiveTouch sharedInstance] navigationController];
    if ([nav isKindOfClass:DKSkynetNavigationController.class]) {
        [nav dismissWithAnimation:true];
    }
}

- (void)refreshAllModuleState
{
    [self.plugins enumerateObjectsUsingBlock:^(DKSkynetModuleModel   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.itemView) {
            [obj.itemView configWithModel:obj];
        }
    }];
}

- (void)linkedPlugins
{
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, 0);
    dispatch_queue_t queue = dispatch_queue_create("com.skynet.queue", attr);
    dispatch_async(queue, ^{
        NSLog(@"插件注册中...");
        NSMutableArray *header = self.plugins;
        [self _linkedPluginsWithPlugins:self.plugins];
        self.plugins = header;
        NSLog(@"插件注册成功!");
    });
}


#pragma mark - private -

- (BOOL)_checkViewControllerIsTop:(XFATViewController *)viewController {
    if (viewController == [[[[XFAssistiveTouch sharedInstance] navigationController] viewControllers] firstObject]) {
        return true;
    } else {
        return false;
    }
}

- (void)_linkedPluginsWithPlugins:(NSMutableArray <DKSkynetModuleModel *> *)plugins
{
    if (!self.tempSubPlugins.count || !plugins.count) {
        return;
    }
    
    NSMutableArray *tempSubPlugins = [self.tempSubPlugins mutableCopy];
    for (DKSkynetModuleModel *obj1 in tempSubPlugins) {
        for (DKSkynetModuleModel *obj2 in plugins) {
            if ([obj1.superPluginId isEqualToString:obj2.pluginId]) {
                [obj2.subPlugins addObject:obj1];
                [self.tempSubPlugins removeObject:obj1];
                continue;
            }
            if (obj2.subPlugins.count) {
                [self _linkedPluginsWithPlugins:obj2.subPlugins];
            }
        }
    }
}

#pragma mark - present -

- (void)presentViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^ __nullable)(void))completion
{
    [self presentViewController:viewController hasWrapNavigationController:NO animated:animated completion:completion];
}

- (void)presentViewController:(UIViewController *)viewController
  hasWrapNavigationController:(BOOL)hasWrapNavigationController
                     animated:(BOOL)animated
                   completion:(void (^ __nullable)(void))completion
{
    if (!viewController || ![viewController isKindOfClass:UIViewController.class]) {
        return;
    }
    
    UIViewController *currentViewController = self.dk_topViewController;
    if (!currentViewController || [currentViewController isMemberOfClass:viewController.class]) {
        return;
    }
    
    if (hasWrapNavigationController) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        if (@available(iOS 13.0, *)) {
            navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        [currentViewController presentViewController:navigationController animated:animated completion:completion];
    } else {
        [currentViewController presentViewController:viewController animated:YES completion:completion];
    }
}

#pragma mark - Getter -

- (NSArray *)sortArray
{
    NSMutableArray *sortArray = [self.plugins mutableCopy];
    [sortArray sortUsingComparator:^NSComparisonResult(DKSkynetModuleModel * _Nonnull obj1, DKSkynetModuleModel *  _Nonnull obj2) {
        if (obj1.prioprity > obj2.prioprity) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    return sortArray;
}

#pragma mark - XFXFAssistiveTouchDelegate, XFATRootViewControllerDelegate -

- (NSInteger)numberOfItemsInViewController:(XFATRootViewController *)viewController {
    if ([self _checkViewControllerIsTop:viewController]) {
        return self.plugins.count;
    } else {
        return viewController.model.subPlugins.count;
    }
}

- (XFATItemView *)viewController:(XFATRootViewController *)viewController itemViewAtPosition:(XFATPosition *)position {
    NSArray *displayArray = [self sortArray];
    DKSkynetItemView *view = [[DKSkynetItemView alloc] init];
    DKSkynetModuleModel *model;
    if ([self _checkViewControllerIsTop:viewController]) {
        NSInteger index = position.index;
        model = [displayArray objectAtIndex:index];
    } else {
        model = [[[viewController model] sortedSubPlugins] objectAtIndex:position.index];
    }
    [view configWithModel:model];
    return view;
}

- (void)viewController:(XFATRootViewController *)viewController didSelectedAtPosition:(XFATPosition *)position {
    DKSkynetModuleModel *model;
    if ([self _checkViewControllerIsTop:viewController]) {
        NSArray *displayArray = [self sortArray];
        NSInteger index = position.index;
        model = [displayArray objectAtIndex:index];
    } else {
        model = [[[viewController model] sortedSubPlugins] objectAtIndex:position.index];
    }
    
    if (model.subPlugins.count) {
        XFATRootViewController *viewController = [[XFATRootViewController alloc] initWithItems:nil];
        viewController.delegate = self;
        viewController.model = model;
        [[XFAssistiveTouch sharedInstance].navigationController pushViewController:viewController atPisition:position];
        return;
    } else if (!model.didStart) {
        DKLogWarn(@"此分组暂无内容");
        return;
    }
    
    [[[XFAssistiveTouch sharedInstance] navigationController] shrink];
    
    if (model.didStart) {
        BOOL isOn = model.isOn;
        model.didStart(model.slf, @selector(pluginDidStart:), &isOn);
        model.isOn = isOn;
        if (@available(iOS 10.0, *)) {
            UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
            [feedBackGenertor impactOccurred];
        } else {
            // Fallback on earlier versions
        }
        [model.itemView configWithModel:model];
    }
}

@end
