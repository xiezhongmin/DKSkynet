//
//  DKNetworkMonitorDetailWebCell.m
//  DKSkynet
//
//  Created by admin on 2022/7/11.
//

#import "DKNetworkMonitorDetailWebCell.h"
#import <WebKit/WebKit.h>
#import <DKSkynet/DKSkynetUtility.h>

NSString * const kDKNetworkMonitorDetailWebCellIdentifier = @"DKNetworkMonitorDetailWebCellIdentifier";

@interface DKNetworkMonitorDetailWebCell ()

@property (nonatomic, weak) WKWebView *webView;

@end

@implementation DKNetworkMonitorDetailWebCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // do nothing
    }
    return self;
}

- (void)webViewLoadString:(NSString *)string
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *htmlString = [NSString stringWithFormat:@"<head><meta name='viewport' content='initial-scale=1.0'></head><body><pre>%@</pre></body>", [DKSkynetUtility stringByEscapingHTMLEntitiesInString:string]];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:htmlString baseURL:nil];
        });
    });
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(8, 0, self.frame.size.width - 16, self.frame.size.height)];
        webView.scrollView.bounces = NO;
        [self addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

@end
