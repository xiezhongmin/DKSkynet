//
//  DKNetworkMonitorDetailViewModel.m
//  DKSkynet
//
//  Created by admin on 2022/7/11.
//

#import "DKNetworkMonitorDetailViewModel.h"
#import "DKNetworkMonitorDetailSection.h"
#import "DKNetworkTransaction.h"
#import <DKSkynet/DKSkynetWebViewController.h>
#import <DKSkynet/DKSkynetNetworkUtil.h>
#import <DKSkynet/DKSkynetUtility.h>

#define kDKSkynetDefaultCellFontSize  12.0

NSString * const kDKNetworkMonitorDetailTableSectionGeneral = @"General";
NSString * const kDKNetworkMonitorDetailTableSectionRequestHeaders = @"Request allHTTPHeaderFields";
NSString * const kDKNetworkMonitorDetailTableSectionRequestBody = @"Request Body";
NSString * const kDKNetworkMonitorDetailTableSectionResponseHeaders = @"Response allHeaderFields";
NSString * const kDKNetworkMonitorDetailTableSectionResponseBody = @"Response Body";

static const NSInteger kMaxLimitedBody = 1024;

@interface DKNetworkMonitorDetailViewModel ()

@property (nonatomic, copy, readwrite) NSArray <DKNetworkMonitorDetailSection *> *sections;

@end

@implementation DKNetworkMonitorDetailViewModel

- (void)rebuildTableSections:(DKNetworkTransaction *)transaction
{
    NSMutableArray *sections = [NSMutableArray array];

    // general section
    DKNetworkMonitorDetailSection *generalSection = [[self class] generalSectionForTransaction:transaction];
    if ([generalSection.rows count] > 0) {
        [sections addObject:generalSection];
    }
    
    // request headers section
    DKNetworkMonitorDetailSection *requestHeadersSection = [[self class] requestHeadersSectionForTransaction:transaction];
    if ([requestHeadersSection.rows count] > 0) {
        [sections addObject:requestHeadersSection];
    }
    
    // body section
    DKNetworkMonitorDetailSection *postBodySection = [[self class] postBodySectionForTransaction:transaction];
    if ([postBodySection.rows count] > 0) {
        [sections addObject:postBodySection];
    }
    
    // response headers section
    DKNetworkMonitorDetailSection *responseHeadersSection = [[self class] responseHeadersSectionForTransaction:transaction];
    if ([responseHeadersSection.rows count] > 0) {
        [sections addObject:responseHeadersSection];
    }
    
    // reponse body section
    DKNetworkMonitorDetailSection *reponseBodySection = [[self class] responseBodySectionForTransaction:transaction];
    if ([reponseBodySection.rows count] > 0) {
        [sections addObject:reponseBodySection];
    }
    
    self.sections = sections;
}

#pragma mark - Table Data Generation -

+ (DKNetworkMonitorDetailSection *)generalSectionForTransaction:(DKNetworkTransaction *)transaction
{
    NSMutableArray *rows = [NSMutableArray array];
    
    // url row
    NSURL *url = transaction.request.URL;
    DKNetworkMonitorDetailRow *requestUrlRow = [[DKNetworkMonitorDetailRow alloc] init];
    requestUrlRow.title = @"Request URL";
    requestUrlRow.detailText = url.absoluteString;
    requestUrlRow.selectionFuture = ^{
        UIViewController *urlWebViewController = [[DKSkynetWebViewController alloc] initWithURL:url];
        urlWebViewController.title = url.absoluteString;
        return urlWebViewController;
    };
    [rows addObject:requestUrlRow];

    // request method row
    DKNetworkMonitorDetailRow *requestMethodRow = [[DKNetworkMonitorDetailRow alloc] init];
    requestMethodRow.title = @"Request Method";
    requestMethodRow.detailText = transaction.request.HTTPMethod;
    [rows addObject:requestMethodRow];
    
    // status code row
    NSString *statusCodeString = [DKSkynetNetworkUtil statusCodeStringFromURLResponse:transaction.response];
    if ([statusCodeString length] > 0) {
        DKNetworkMonitorDetailRow *statusCodeRow = [[DKNetworkMonitorDetailRow alloc] init];
        statusCodeRow.title = @"Status Code";
        statusCodeRow.detailText = statusCodeString;
        [rows addObject:statusCodeRow];
    }
    
    // error row
    if (transaction.error) {
        DKNetworkMonitorDetailRow *errorRow = [[DKNetworkMonitorDetailRow alloc] init];
        errorRow.title = @"Error";
        errorRow.detailText = transaction.error.localizedDescription;
        [rows addObject:errorRow];
    }
    
    // startTime Row
    DKNetworkMonitorDetailRow *startTimeRow = [[DKNetworkMonitorDetailRow alloc] init];
    NSDateFormatter *startTimeFormatter = [[NSDateFormatter alloc] init];
    startTimeFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    startTimeRow.title = @"Start Time";
    startTimeRow.detailText = [startTimeFormatter stringFromDate:transaction.startTime];
    [rows addObject:startTimeRow];
    
    // resquest size row
    DKNetworkMonitorDetailRow *resquestSizeRow = [[DKNetworkMonitorDetailRow alloc] init];
    resquestSizeRow.title = @"Resquest Size";
    resquestSizeRow.detailText = [NSByteCountFormatter stringFromByteCount:transaction.requestLength countStyle:NSByteCountFormatterCountStyleBinary];
    [rows addObject:resquestSizeRow];
    
    // response size row
    DKNetworkMonitorDetailRow *responseSizeRow = [[DKNetworkMonitorDetailRow alloc] init];
    responseSizeRow.title = @"Response Size";
    responseSizeRow.detailText = [NSByteCountFormatter stringFromByteCount:transaction.responseLength countStyle:NSByteCountFormatterCountStyleBinary];
    [rows addObject:responseSizeRow];
    
    // mimeType row
    DKNetworkMonitorDetailRow *mimeTypeRow = [[DKNetworkMonitorDetailRow alloc] init];
    mimeTypeRow.title = @"MIME Type";
    mimeTypeRow.detailText = transaction.response.MIMEType;
    [rows addObject:mimeTypeRow];
    
    // mechanism row
    DKNetworkMonitorDetailRow *mechanismRow = [[DKNetworkMonitorDetailRow alloc] init];
    mechanismRow.title = @"Mechanism";
    mechanismRow.detailText = transaction.requestMechanism;
    [rows addObject:mechanismRow];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
    // Metrics
    if (transaction.useURLSessionTaskMetrics) {
        // duration row
        DKNetworkMonitorDetailRow *durationRow = [[DKNetworkMonitorDetailRow alloc] init];
        durationRow.title = @"Total Duration";
        durationRow.detailText = [DKSkynetNetworkUtil stringFromRequestDuration:transaction.duration];
        [rows addObject:durationRow];
        
        NSDate *thisTurnTransMetricsStartFrom = transaction.startTime;
        NSInteger index = 0;
        for (DKURLSessionTaskTransactionMetrics *transMetrics in transaction.taskMetrics.transactionMetrics) {
            if (index++ == 0) {
                NSTimeInterval beforeStartDuration = [transMetrics.fetchStartDate timeIntervalSinceDate:transaction.startTime];
                if (beforeStartDuration > 0.005f) {
                    DKNetworkMonitorDetailRow *durationRow = [[DKNetworkMonitorDetailRow alloc] init];
                    durationRow.title = @"Before First StartFetch";
                    durationRow.detailText = [DKSkynetNetworkUtil stringFromRequestDuration:beforeStartDuration];
                    [rows addObject:durationRow];
                }
            }
            
            if (transMetrics.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeLocalCache) {
                DKNetworkMonitorDetailRow *localCacheFetchRow = [[DKNetworkMonitorDetailRow alloc] init];
                localCacheFetchRow.title = @"Local Cache Fetch";
                NSTimeInterval localFetchDuration = [transMetrics.responseEndDate timeIntervalSinceDate:transMetrics.fetchStartDate];
                localCacheFetchRow.detailText = [DKSkynetNetworkUtil stringFromRequestDuration:localFetchDuration];
                [rows addObject:localCacheFetchRow];

                thisTurnTransMetricsStartFrom = transMetrics.responseEndDate;
                continue;
            }
            NSTimeInterval dnsDuration = [transMetrics.domainLookupEndDate timeIntervalSinceDate:transMetrics.domainLookupStartDate];
            NSTimeInterval connDuration = [transMetrics.connectEndDate timeIntervalSinceDate:transMetrics.connectStartDate];
            NSTimeInterval secConnDuration = [transMetrics.secureConnectionEndDate timeIntervalSinceDate:transMetrics.secureConnectionStartDate];
            NSTimeInterval transDuration = [transMetrics.responseEndDate timeIntervalSinceDate:transMetrics.requestStartDate];

            NSTimeInterval queueingDuration = 0;
            if (transMetrics.domainLookupStartDate) {
                queueingDuration = [transMetrics.domainLookupStartDate timeIntervalSinceDate:thisTurnTransMetricsStartFrom];
            } else if (transMetrics.connectStartDate) {
                queueingDuration = [transMetrics.connectStartDate timeIntervalSinceDate:thisTurnTransMetricsStartFrom];
            } else if (transMetrics.requestStartDate) {
                queueingDuration = [transMetrics.requestStartDate timeIntervalSinceDate:thisTurnTransMetricsStartFrom];
            }
            if (queueingDuration > 0.005f) {
                DKNetworkMonitorDetailRow *durationRow = [[DKNetworkMonitorDetailRow alloc] init];
                durationRow.title = @"Queueing";
                durationRow.detailText = [DKSkynetNetworkUtil stringFromRequestDuration:queueingDuration];
                [rows addObject:durationRow];
            }

            if (dnsDuration > 0.f) {
                DKNetworkMonitorDetailRow *dnsDurationRow = [[DKNetworkMonitorDetailRow alloc] init];
                dnsDurationRow.title = @"DNS";
                dnsDurationRow.detailText = [DKSkynetNetworkUtil stringFromRequestDuration:dnsDuration];
                [rows addObject:dnsDurationRow];
            }

            if (connDuration > 0.f) {
                DKNetworkMonitorDetailRow *connDurationRow = [[DKNetworkMonitorDetailRow alloc] init];
                NSString *connDurText = [DKSkynetNetworkUtil stringFromRequestDuration:connDuration];
                if (secConnDuration > 0.f) {
                    connDurationRow.title = (secConnDuration > 0.f) ? @"Connection" : @"Connection (Secure Conn)";
                    NSString *secureConnDurText = [DKSkynetNetworkUtil stringFromRequestDuration:secConnDuration];
                    connDurationRow.detailText = [NSString stringWithFormat:@"%@ (%@)", connDurText, secureConnDurText];
                } else {
                    connDurationRow.title = @"Connection";
                    connDurationRow.detailText = [DKSkynetNetworkUtil stringFromRequestDuration:connDuration];
                }
                [rows addObject:connDurationRow];
            }

            if (transDuration > 0.f) {
                DKNetworkMonitorDetailRow *transDurationRow = [[DKNetworkMonitorDetailRow alloc] init];
                transDurationRow.title = @"Request/Response";
                transDurationRow.detailText = [DKSkynetNetworkUtil stringFromRequestDuration:transDuration];
                [rows addObject:transDurationRow];
            }

            if (transMetrics.responseEndDate) {
                thisTurnTransMetricsStartFrom = transMetrics.responseEndDate;
            }
        }
    } else {
        DKNetworkMonitorDetailRow *durationRow = [[DKNetworkMonitorDetailRow alloc] init];
        durationRow.title = @"Total Duration";
        durationRow.detailText = [DKSkynetNetworkUtil stringFromRequestDuration:transaction.duration];
        [rows addObject:durationRow];

        DKNetworkMonitorDetailRow *latencyRow = [[DKNetworkMonitorDetailRow alloc] init];
        latencyRow.title = @"Latency";
        latencyRow.detailText = [DKSkynetNetworkUtil stringFromRequestDuration:transaction.latency];
        [rows addObject:latencyRow];
    }
#pragma clang diagnostic pop
    
    DKNetworkMonitorDetailSection *generalSection = [[DKNetworkMonitorDetailSection alloc] init];
    generalSection.title = kDKNetworkMonitorDetailTableSectionGeneral;
    generalSection.rows = rows;
    
    return generalSection;
}

+ (DKNetworkMonitorDetailSection *)requestHeadersSectionForTransaction:(DKNetworkTransaction *)transaction
{
    DKNetworkMonitorDetailSection *requestHeadersSection = [[DKNetworkMonitorDetailSection alloc] init];
    requestHeadersSection.title = kDKNetworkMonitorDetailTableSectionRequestHeaders;
    DKNetworkMonitorDetailRow *row = [[DKNetworkMonitorDetailRow alloc] init];
    row.title = @"Request allHTTPHeaderFields";
    row.style = DKNetworkMonitorDetailRowWeb;
    NSMutableString *detailText = [[NSMutableString alloc] init];

    [transaction.request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
        [detailText appendString:[NSString stringWithFormat:@"%@:%@\n", key, obj]];
    }];
    row.detailText = detailText;
    if (detailText.length == 0) {
        row.detailText = @"Request allHTTPHeaderFields are nil";
    }
    requestHeadersSection.rows = @[ row ];
    return requestHeadersSection;
}

+ (DKNetworkMonitorDetailSection *)postBodySectionForTransaction:(DKNetworkTransaction *)transaction
{
    DKNetworkMonitorDetailSection *postBodySection = [[DKNetworkMonitorDetailSection alloc] init];
    postBodySection.title = kDKNetworkMonitorDetailTableSectionRequestBody;
    DKNetworkMonitorDetailRow *row = [[DKNetworkMonitorDetailRow alloc] init];
    row.title = kDKNetworkMonitorDetailTableSectionRequestBody;
    if ([transaction.cachedRequestBody length] > 0) {
        if ([transaction.cachedRequestBody length] > kMaxLimitedBody) {
            row.detailText = @"Too long to show, tap to view.";
            row.style = DKNetworkMonitorDetailRowDefault;
        } else {
            row.detailText = [DKSkynetUtility prettyJSONStringFromData:[self postBodyDataForTransaction:transaction]];
            if (row.detailText.length) {
                row.detailText = [row.detailText stringByReplacingOccurrencesOfString:@"&" withString:@"\n" options:0 range:NSMakeRange(0, row.detailText.length)];
            }
            row.style = DKNetworkMonitorDetailRowWeb;
        }
        row.selectionFuture = ^{
            NSString *contentType = [transaction.request valueForHTTPHeaderField:@"Content-Type"];
            UIViewController *detailViewController = [self detailViewControllerForMIMEType:contentType data:[self postBodyDataForTransaction:transaction]];
            if (detailViewController) {
                detailViewController.title = @"Request Body";
            } else {
                NSString *alertMessage = [NSString stringWithFormat:@"Hawkeye does not have a viewer for request body data with MIME type: %@", [transaction.request valueForHTTPHeaderField:@"Content-Type"]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [[[UIAlertView alloc] initWithTitle:@"Can't View Body Data" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
#pragma clang diagnostic pop
            }
            return detailViewController;
        };
    } else {
        row.detailText = @"Request Body is nil";
    }
    postBodySection.rows = @[ row ];
    return postBodySection;
}

+ (DKNetworkMonitorDetailSection *)responseHeadersSectionForTransaction:(DKNetworkTransaction *)transaction
{
    DKNetworkMonitorDetailSection *responseHeadersSection = [[DKNetworkMonitorDetailSection alloc] init];
    responseHeadersSection.title = kDKNetworkMonitorDetailTableSectionResponseHeaders;
    if ([transaction.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)transaction.response;
        DKNetworkMonitorDetailRow *row = [[DKNetworkMonitorDetailRow alloc] init];
        row.title = @"Response allHeaderFields";
        row.style = DKNetworkMonitorDetailRowWeb;
        NSMutableString *detailText = [[NSMutableString alloc] init];

        [httpResponse.allHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
            [detailText appendString:[NSString stringWithFormat:@"%@:%@\n", key, obj]];
        }];
        row.detailText = detailText;
        if (detailText.length == 0) {
            row.detailText = @"Response allHeaderFields are nil";
        }
        responseHeadersSection.rows = @[ row ];
    }
    return responseHeadersSection;
}

+ (DKNetworkMonitorDetailSection *)responseBodySectionForTransaction:(DKNetworkTransaction *)transaction
{
    DKNetworkMonitorDetailSection *responseBodySection = [[DKNetworkMonitorDetailSection alloc] init];
    responseBodySection.title = kDKNetworkMonitorDetailTableSectionResponseBody;
    DKNetworkMonitorDetailRow *row = [[DKNetworkMonitorDetailRow alloc] init];
    row.title = kDKNetworkMonitorDetailTableSectionResponseBody;
    if ([transaction.responseBody length] > 0 || transaction.responseContentType == DKNetworkResponseMIMETypeOther) {
        if (transaction.responseContentType == DKNetworkResponseMIMETypeOther || [transaction.responseBody length] > kMaxLimitedBody) {
            row.detailText = @"Too long to show, tap to view.";
            row.style = DKNetworkMonitorDetailRowDefault;
        } else {
            row.detailText = [DKSkynetUtility prettyJSONStringFromData:transaction.responseBody];
            row.style = DKNetworkMonitorDetailRowWeb;
        }
        __weak NSData *weakResponseData = transaction.responseBody;
        row.selectionFuture = ^{
            if (transaction.responseContentType == DKNetworkResponseMIMETypeOther) {
                __block UIViewController *responseBodyDetailViewController = nil;
                __block NSString *mineType = nil;
                __block NSData *viewControllerData;
                dispatch_semaphore_t sem = dispatch_semaphore_create(0);
                NSURLSession *session = [NSURLSession sharedSession];
                NSURLSessionTask *task = [session dataTaskWithRequest:transaction.request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        mineType = response.MIMEType;
                                                        viewControllerData = data;
                                                        dispatch_semaphore_signal(sem);
                                                    }];
                [task resume];
                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
                responseBodyDetailViewController = [self detailViewControllerForMIMEType:mineType data:viewControllerData];
                return responseBodyDetailViewController;
            } else {
                UIViewController *responseBodyDetailViewController = nil;
                NSData *strongResponseData = weakResponseData;
                if (strongResponseData) {
                    responseBodyDetailViewController = [self detailViewControllerForMIMEType:transaction.response.MIMEType data:strongResponseData];
                    if (!responseBodyDetailViewController) {
                        NSString *alertMessage = [NSString stringWithFormat:@"Hawkeye does not have a viewer for responses with MIME type: %@", transaction.response.MIMEType];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        [[[UIAlertView alloc] initWithTitle:@"Can't View Response" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
#pragma clang diagnostic pop
                    }
                    responseBodyDetailViewController.title = @"Response";
                } else {
                    NSString *alertMessage = @"The response has been purged from the cache";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    [[[UIAlertView alloc] initWithTitle:@"Can't View Response" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
#pragma clang diagnostic pop
                }
                return responseBodyDetailViewController;
            }
        };
    } else {
        row.detailText = @"Response Body is nil";
    }
    responseBodySection.rows = @[ row ];
    return responseBodySection;
}

#pragma mark - private -

+ (UIViewController *)detailViewControllerForMIMEType:(NSString *)mimeType data:(NSData *)data
{
    // FIXME (RKO): Don't rely on UTF8 string encoding
    UIViewController *detailViewController = nil;
    if ([DKSkynetUtility isValidJSONData:data] || [mimeType isEqual:@"application/json"]) {
        NSString *prettyJSON = [DKSkynetUtility prettyJSONStringFromData:data];
        if ([prettyJSON length] > 0) {
            detailViewController = [[DKSkynetWebViewController alloc] initWithText:prettyJSON];
        }
    } else if ([mimeType hasPrefix:@"image/"]) {
        UIImage *image = [UIImage imageWithData:data];
        if (image == nil) {
            if ([mimeType containsString:@"webp"]) {
                SEL sdWebPSEL = NSSelectorFromString(@"sd_imageWithWebPData:");
                if ([UIImage respondsToSelector:sdWebPSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    image = [UIImage performSelector:sdWebPSEL withObject:data];
#pragma clang diagnostic pop
                }
            }
        }
        if (image == nil) {
            Class yyImageCls = NSClassFromString(@"YYImage");
            if (yyImageCls) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                SEL yyImgSEL = NSSelectorFromString(@"imageWithData:");
                image = [yyImageCls performSelector:yyImgSEL withObject:data];
            }
        }
        detailViewController = [NSClassFromString(@"FLEXImagePreviewViewController") performSelector:NSSelectorFromString(@"forImage:") withObject:image];
#pragma clang diagnostic pop
    } else if ([mimeType isEqual:@"application/x-plist"]) {
        id propertyList = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:NULL];
        detailViewController = [[DKSkynetWebViewController alloc] initWithText:[propertyList description]];
    }

    // Fall back to trying to show the response as text
    if (!detailViewController) {
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([text length] > 0) {
            detailViewController = [[DKSkynetWebViewController alloc] initWithText:text];
        }
    }
    return detailViewController;
}

+ (NSData *)postBodyDataForTransaction:(DKNetworkTransaction *)transaction
{
    NSData *bodyData = transaction.cachedRequestBody;
    if ([bodyData length] > 0) {
        NSString *contentEncoding = [transaction.request valueForHTTPHeaderField:@"Content-Encoding"];
        if ([contentEncoding rangeOfString:@"deflate" options:NSCaseInsensitiveSearch].length > 0 || [contentEncoding rangeOfString:@"gzip" options:NSCaseInsensitiveSearch].length > 0) {
            bodyData = [DKSkynetNetworkUtil inflatedDataFromCompressedData:bodyData];
        }
    }
    return bodyData;
}

#pragma mark - View Configuration -

+ (NSAttributedString *)attributedTextForRow:(DKNetworkMonitorDetailRow *)row
{
    UIColor *titleColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    NSDictionary *titleAttributes = @{
        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0],
        NSForegroundColorAttributeName : titleColor
    };
    NSDictionary *detailAttributes = @{
        NSFontAttributeName : self.defaultTableCellFont,
        NSForegroundColorAttributeName : [UIColor blackColor]
    };

    NSString *title = row.title ? [NSString stringWithFormat:@"%@: ", row.title] : @"";
    NSString *detailText = row.detailText ?: @"";
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:titleAttributes]];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:detailText attributes:detailAttributes]];

    return attributedText;
}

#pragma mark - Getter -

+ (UIFont *)defaultTableCellFont
{
    static UIFont *_defaultTableCellFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultTableCellFont = [UIFont fontWithName:@"HelveticaNeue" size:kDKSkynetDefaultCellFontSize];
    });
    return _defaultTableCellFont;
}

@end
