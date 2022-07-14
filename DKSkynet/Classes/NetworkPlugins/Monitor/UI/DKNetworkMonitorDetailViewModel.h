//
//  DKNetworkMonitorDetailViewModel.h
//  DKSkynet
//
//  Created by admin on 2022/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kDKNetworkMonitorDetailTableSectionGeneral;
extern NSString * const kDKNetworkMonitorDetailTableSectionRequestHeaders;
extern NSString * const kDKNetworkMonitorDetailTableSectionRequestBody;
extern NSString * const kDKNetworkMonitorDetailTableSectionResponseHeaders;
extern NSString * const kDKNetworkMonitorDetailTableSectionResponseBody;

@class DKNetworkMonitorDetailSection;
@class DKNetworkTransaction;
@class DKNetworkMonitorDetailRow;

@interface DKNetworkMonitorDetailViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray <DKNetworkMonitorDetailSection *> *sections;
@property (nonatomic, strong, readonly, class) UIFont *defaultTableCellFont;

- (void)rebuildTableSections:(DKNetworkTransaction *)transaction;

+ (NSAttributedString *)attributedTextForRow:(DKNetworkMonitorDetailRow *)row;

@end

NS_ASSUME_NONNULL_END
