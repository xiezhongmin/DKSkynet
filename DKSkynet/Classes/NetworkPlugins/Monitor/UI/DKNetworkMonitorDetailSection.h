//
//  DKNetworkMonitorDetailSection.h
//  DKSkynet
//
//  Created by admin on 2022/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DKNetworkMonitorDetailRowStyle) {
    DKNetworkMonitorDetailRowDefault,
    DKNetworkMonitorDetailRowWeb
};

@interface DKNetworkMonitorDetailRow : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, assign) CGFloat cacheCellHeight;
@property (nonatomic, assign) DKNetworkMonitorDetailRowStyle style;
@property (nonatomic, copy) UIViewController * (^selectionFuture)(void);

@end


@interface DKNetworkMonitorDetailSection : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *rows;

@end

NS_ASSUME_NONNULL_END
