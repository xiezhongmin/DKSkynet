//
//  DKSkynetWebViewController.m
//  DKSkynet
//
//  Created by admin on 2022/7/11.
//

#import "DKSkynetWebViewController.h"
#import <WebKit/WebKit.h>
#import "DKSkynetUtility.h"

@interface DKSkynetWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *originalText;

@end

@implementation DKSkynetWebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

- (id)initWithURL:(NSURL *)url
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    return self;
}

- (id)initWithText:(NSString *)text
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.originalText = text;
        [self loadWebViewWithText:text];
    }
    return self;
}

- (void)loadWebViewWithText:(NSString *)text
{
    NSString *htmlString = [NSString stringWithFormat:@"<head><meta name='viewport' content='initial-scale=1.0'></head><body><pre>%@</pre></body>", [DKSkynetUtility stringByEscapingHTMLEntitiesInString:text]];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    if ([self.originalText length] > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionBtnTapped:)];
    }
}

- (void)actionBtnTapped:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"Copy Content"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           [[UIPasteboard generalPasteboard] setString:self.originalText];
                                                       }];
    UIAlertAction *airDropAction = [UIAlertAction actionWithTitle:@"AirDrop Content"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
                                                              UIActivityViewController *airDropVC = [[UIActivityViewController alloc] initWithActivityItems:@[ self.originalText ] applicationActivities:nil];
                                                              [self presentViewController:airDropVC animated:YES completion:nil];
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:copyAction];
    [alertController addAction:airDropAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Getter -

- (WKWebView *)webView
{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}


#pragma mark - WKWebView Delegate -

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (!navigationAction.targetFrame) {
        NSURL *url = navigationAction.request.URL;
        if (url) {
            DKSkynetWebViewController *webVC = [[[self class] alloc] initWithURL:url];
            [self.navigationController pushViewController:webVC animated:YES];

            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        [self loadWebViewWithText:[error description]];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.navigationItem.title = webView.title;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

    if (completionHandler)
        completionHandler();
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}


#pragma mark - Class Helpers -

+ (BOOL)supportsPathExtension:(NSString *)extension {
    BOOL supported = NO;
    NSSet *supportedExtensions = [self webViewSupportedPathExtensions];
    if ([supportedExtensions containsObject:[extension lowercaseString]]) {
        supported = YES;
    }
    return supported;
}

+ (NSSet *)webViewSupportedPathExtensions {
    static NSSet *pathExtenstions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Note that this is not exhaustive, but all these extensions should work well in the web view.
        // See https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/CreatingContentforSafarioniPhone/CreatingContentforSafarioniPhone.html#//apple_ref/doc/uid/TP40006482-SW7
        pathExtenstions = [NSSet setWithArray:@[ @"jpg", @"jpeg", @"png", @"gif", @"pdf", @"svg", @"tiff", @"3gp", @"3gpp", @"3g2",
            @"3gp2", @"aiff", @"aif", @"aifc", @"cdda", @"amr", @"mp3", @"swa", @"mp4", @"mpeg",
            @"mpg", @"mp3", @"wav", @"bwf", @"m4a", @"m4b", @"m4p", @"mov", @"qt", @"mqv", @"m4v" ]];
    });
    return pathExtenstions;
}

@end
