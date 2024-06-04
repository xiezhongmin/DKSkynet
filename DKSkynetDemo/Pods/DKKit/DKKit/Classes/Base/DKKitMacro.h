//
//  DKKitMacro.h
//  DKDebugerExample
//
//  Created by admin on 2020/11/23.
//

#import <UIKit/UIKit.h>
#import <pthread.h>
#import "UIColor+DKUtils.h"


#ifndef DKKitMacro_h
#define DKKitMacro_h

/**
 *  DEBUG
 */
#define DKDEBUG ([NSClassFromString(@"DKDebug") class]? 1:0)
#define DKAssert(condition,...) if (DKDEBUG == 1) NSAssert(condition,__VA_ARGS__)


/**
 *  NSLog
 *  Level: 1 error, 2 Warn, 3 Info, 4 Debug, 5 Verbose, 6 FileLine
 */
#ifndef DK_NSLOG_LEVEL
    #define DK_NSLOG_LEVEL  (6)
#endif

#ifdef DEBUG
#ifndef DKLog
    #define DKLog(frmt, ...)            do{ if(DK_NSLOG_LEVEL >= 0) NSLog((@"" frmt), ##__VA_ARGS__); } while(0)
#endif
#ifndef DKLogDebug
    #define DKLogDebug(frmt, ...)       do{ if(DK_NSLOG_LEVEL >= 4) NSLog((@"[Debug] " frmt), ##__VA_ARGS__); } while(0)
#endif
#ifndef DKLogInfo
    #define DKLogInfo(frmt, ...)        do{ if(DK_NSLOG_LEVEL >= 3) NSLog((@"[Info] " frmt), ##__VA_ARGS__); } while(0)
#endif
#ifndef DKLogError
    #define DKLogError(frmt, ...)       do{ if(DK_NSLOG_LEVEL >= 1) NSLog((@"[Error] " frmt), ##__VA_ARGS__); } while(0)
#endif
#ifndef DKLogWarn
    #define DKLogWarn(frmt, ...)        do{ if(DK_NSLOG_LEVEL >= 2) NSLog((@"[Warn] " frmt), ##__VA_ARGS__); } while(0)
#endif
#ifndef DKLogVerbose
    #define DKLogVerbose(frmt, ...)     do{ if(DK_NSLOG_LEVEL >= 5) NSLog((@"[Verbose] " frmt), ##__VA_ARGS__); } while(0)
#endif
#ifndef DKLogFileLine
    #define DKLogFileLine(frmt, ...)    do{ if(DK_NSLOG_LEVEL >= 6) NSLog((@"<file:%@, line:%d> " frmt), [[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent], __LINE__, ##__VA_ARGS__); } while(0)
#endif
#else
#ifndef DKLog
    #define DKLog(frmt, ...)
#endif
#ifndef DKLogDebug
    #define DKLogDebug(frmt, ...)
#endif
#ifndef DKLogInfo
    #define DKLogInfo(frmt, ...)
#endif
#ifndef DKLogError
    #define DKLogError(frmt, ...)
#endif
#ifndef DKLogWarn
    #define DKLogWarn(frmt, ...)
#endif
#ifndef DKLogVerbose
    #define DKLogVerbose(frmt, ...)
#endif
#ifndef DKLogFileLine
    #define DKLogFileLine(frmt, ...)
#endif
#endif


/**
 *  检测系统版本
 */
#define DK_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define DK_IOS_OR_LATER_VERSION(Version) ([[[UIDevice currentDevice] systemVersion] compare:@""#Version"" options:NSNumericSearch] == NSOrderedDescending)

#define DK_IOS16_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"16" options:NSNumericSearch] == NSOrderedDescending)
#define DK_IOS15_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"15" options:NSNumericSearch] == NSOrderedDescending)
#define DK_IOS14_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"14" options:NSNumericSearch] == NSOrderedDescending)
#define DK_IOS13_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"13" options:NSNumericSearch] == NSOrderedDescending)
#define DK_IOS11_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"11" options:NSNumericSearch] == NSOrderedDescending)
#define DK_IOS10_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"10" options:NSNumericSearch] == NSOrderedDescending)
#define DK_IOS9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] compare:@"9" options:NSNumericSearch] == NSOrderedDescending)
#define DK_IOS8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] == NSOrderedDescending)
#define DK_IOS7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] == NSOrderedDescending)


/**
 *  判断iphoneX
 */
#define DK_ISIPHONE_X \
({BOOL isiPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isiPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isiPhoneX);})


/**
 *  App Version
 */
#define DK_APP_VERSION   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]


/**
 *  Size
 */
#define DK_SCREEN_HEIGHT              ( [UIScreen mainScreen].bounds.size.height )
#define DK_SCREEN_WIDTH               ( [UIScreen mainScreen].bounds.size.width )

#define DK_STATUS_BAR_HEIGHT          ( [[UIApplication sharedApplication] statusBarFrame].size.height )
#define DK_NAV_BAR_HEIGHT             ( 44 )
#define DK_TAB_BAR_HEIGHT             ( DK_ISIPHONE_X ? 83 : 50 )
#define DK_TOP_SAFE_AREA_HEIGHT       ( DK_ISIPHONE_X ? 24 : 0 )
#define DK_BOTTOM_SAFE_AREA_HEIGHT    ( DK_ISIPHONE_X ? 34 : 0 )


/**
 *  Orientation
 */
/// 当前是否是竖屏
#define DK_IS_ORIENTATION_PORTRAIT    UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)

/// 当前是否是横屏
#define DK_IS_ORIENTATION_LANDSCAPE   UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)


/**
 *  Scale
 */
/// 根据 375*667(iPhone 6) 尺寸比例, 计算 size
#define DK_SCALE_SIZE_FROM375(x)                ((x)*DK_SCREEN_WIDTH/375)
/// 如果横屏显示
#define DK_SCALE_SIZE_FROM375_IF_LANDSCAPE(x)   (DK_IS_ORIENTATION_LANDSCAPE ? ((x)*DK_SCREEN_HEIGHT/375) : DK_SCALE_SIZE_FROM375(x))


/**
 *  Color
 */
/// RGB
#define DK_RGB(R, G, B)    [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#define DK_RGBA(R,G,B,A)   [UIColor colorWithRed:(R)/255.0f \
                        green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
#define DK_RGB_VALUE(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/// 16进制颜色
//#define DK_COLOR_HEX(hex)             [UIColor colorWithRed:(((hex & 0xFF0000) >> 16))/255.0 green:(((hex &0xFF00) >>8))/255.0 blue:((hex &0xFF))/255.0 alpha:1.0]
//#define DK_COLOR_HEX_A(hex, a)        [UIColor colorWithRed:(((hex & 0xFF0000) >> 16))/255.0 green:(((hex &0xFF00) >>8))/255.0 blue:((hex &0xFF))/255.0 alpha:a]

/// Example: DK_COLOR_HEX(0xF0F),  DK_COLOR_HEX(0x66ccff), DK_COLOR_HEX(#66CCFF88)
#define DK_COLOR_HEX(hex)   [UIColor dk_colorWithHexString: ((__bridge NSString *)CFSTR(#hex))]

/// Example: #RGB: @"F0F" or @"0xF0F",  #ARGB: @"F0FC" or @"0xFF0F",  #RRGGBB: @"66ccff" or @"0x66ccff",  #AARRGGBB: @"66CCFF88" or @"0x66CCFF88"
#define DK_COLOR_HEX_STR(hexString)   [UIColor dk_colorWithHexString: hexString]


/**
 *  weakify, strongify
 */
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


/**
 *  单例模式
 */
#define DUKESINGLETON
static id sharedInstance;
#define duke_as_singleton    \
+ (instancetype)sharedInstance; \
+ (void)purgeSharedInstance;

#define duke_def_singleton(__token) \
static id __singleton__objc__ ## __token;                     \
static dispatch_once_t __singleton__token__ ## __token;       \
+ (instancetype)sharedInstance \
{ \
dispatch_once(&__singleton__token__ ## __token, ^{ __singleton__objc__ ## __token = [[self alloc] init]; }); \
return __singleton__objc__ ## __token; \
}   \
+ (void)purgeSharedInstance \
{   \
__singleton__objc__ ## __token  = nil;    \
__singleton__token__ ## __token = 0; \
}


/**
 *  Synthsize a dynamic Associated object property in @implementation scope
 */

/**
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
     @interface NSObject (MyAdd)
     @property (nonatomic, retain) UIColor *myColor;
     @end
     
     #import <objc/runtime.h>
     @implementation NSObject (MyAdd)
     DK_SYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
     @end
 */
#ifndef DK_SYNTH_DYNAMIC_PROPERTY_OBJECT
#define DK_SYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif

/**
 Synthsize a dynamic c type property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
     @interface NSObject (MyAdd)
     @property (nonatomic, retain) CGPoint myPoint;
     @end
     
     #import <objc/runtime.h>
     @implementation NSObject (MyAdd)
     DK_SYNTH_DYNAMIC_PROPERTY_CTYPE(myPoint, setMyPoint, CGPoint)
     @end
 */
#ifndef DK_SYNTH_DYNAMIC_PROPERTY_CTYPE
#define DK_SYNTH_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    _type_ cValue = { 0 }; \
    NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
    [value getValue:&cValue]; \
    return cValue; \
}
#endif


/**
 *  自动归档
 */
#ifndef DK_AUTO_ENCODE_DECODE_PROPERTY
#define DK_AUTO_ENCODE_DECODE_PROPERTY \
- (void)encodeWithCoder:(NSCoder *)aCoder \
{ \
    unsigned int count = 0; \
    Ivar *ivars = class_copyIvarList([self class], &count); \
    for (int i = 0; i < count; i++) { \
        Ivar ivar = ivars[i]; \
        const char *name = ivar_getName(ivar); \
        NSString *key = [NSString stringWithUTF8String:name]; \
        [aCoder encodeObject:[self valueForKey:key] forKey:key]; \
    } \
    free(ivars); \
} \
- (id)initWithCoder:(NSCoder *)aDecoder { \
    if (self = [super init]) { \
        unsigned int count = 0; \
        Ivar *ivars = class_copyIvarList([self class], &count); \
        for (int i = 0; i < count; i++) { \
            Ivar ivar = ivars[i]; \
            const char *name = ivar_getName(ivar); \
            NSString *key = [NSString stringWithUTF8String:name]; \
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key]; \
        } \
        free(ivars); \
    } \
    return self; \
}
#endif


/**
 Whether in main queue/thread.
 */
static inline bool dk_is_main_queue(void) {
    return pthread_main_np() != 0;
}

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.
 */
static inline void dk_async_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 Submits a block for execution on a main queue and waits until the block completes.
 */
static inline void dk_sync_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

static inline bool dk_isIpad(void) {
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
}

#endif /* DKKitMacro_h */

