//
//  DKNetworkDemoViewController.m
//  DKSkynetDemo
//
//  Created by admin on 2022/7/14.
//

#import "DKNetworkMonitorDemoViewController.h"
#import <DKKit/DKKit.h>
#import <AFNetworking/AFNetworking.h>

@interface DKNetworkMonitorDemoViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) UIButton *sendNSURLConnectionButton;
@property (nonatomic, strong) UIButton *sendNSURLSessionButton;
@property (nonatomic, strong) UIButton *sendAFNetworkingButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableString *log;

@end

@implementation DKNetworkMonitorDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.log = [[NSMutableString alloc] init];
    
    CGFloat posY = 0.f;
    CGFloat witdh = 250.f;
    CGFloat height = 40.f;
    CGFloat font = 18.f;
    CGFloat margin = 10.f;
    self.sendNSURLConnectionButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont systemFontOfSize:font]];
        [button setTitle:@"Send NSURLConnection" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:DK_RGB(87, 250, 255)];
        [button setCornerRadius:8.f];
        [button addTarget:self action:@selector(sendNSURLConnectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        posY += DK_STATUS_BAR_HEIGHT + DK_NAV_BAR_HEIGHT + margin;
        button.frame = CGRectMake(0, posY, witdh, height);
        button.centerX = self.view.width / 2;
        [self.view addSubview:button];
        button;
    });
    
    self.sendNSURLSessionButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont systemFontOfSize:font]];
        [button setTitle:@"Send NSURLSession" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:DK_RGB(87, 250, 255)];
        [button setCornerRadius:8.f];
        [button addTarget:self action:@selector(sendNSURLSessionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        posY += height + margin;
        button.frame = CGRectMake(0, posY, witdh, height);
        button.centerX = self.view.width / 2;
        [self.view addSubview:button];
        button;
    });
    
    self.sendAFNetworkingButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont systemFontOfSize:font]];
        [button setTitle:@"Send AFNetworking" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:DK_RGB(87, 250, 255)];
        [button setCornerRadius:8.f];
        [button addTarget:self action:@selector(sendAFNetworkingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        posY += height + margin;
        button.frame = CGRectMake(0, posY, witdh, height);
        button.centerX = self.view.width / 2;
        [self.view addSubview:button];
        button;
    });
    
    self.textView = ({
        UITextView *textView = [[UITextView alloc] init];
        textView.editable = NO;
        textView.dataDetectorTypes = UIDataDetectorTypeLink;
        textView.font = [UIFont systemFontOfSize:12];
        posY += height + margin;
        CGFloat height = self.view.height - posY;
        textView.frame = CGRectMake(0, posY, self.view.width, height);
        [self.view addSubview:textView];
        textView;
    });
}

#pragma mark - Action -

- (void)sendNSURLConnectionButtonClick:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"http://tx.rutty.top/hanghao/switch/ns-game/list"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    request.timeoutInterval = 15;
            
    request.HTTPBody = [@"username=duke&pwd=123" dataUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [self.log appendFormat:@">> sendNSURLConnection: %@ \n", url.absoluteString];
        self.textView.text = self.log;
        NSLog(@"NSURLConnection 请求返回的响应信息：%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
#pragma clang diagnostic pop

    NSLog(@"sendNSURLConnectionButtonClick");
}

- (void)sendNSURLSessionButtonClick:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"http://tx.rutty.top/hanghao/switch/ns-game/list"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.timeoutInterval = 15;
    
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = [@"username=duke&pwd=123" dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self.log appendFormat:@">> sendNSURLSession: %@ \n", url.absoluteString];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = self.log;
        });
        NSLog(@"NSURLSession 请求返回的响应信息：%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
    }];

    [task resume];

    NSLog(@"sendNSURLSessionButtonClick");
}

- (void)sendAFNetworkingButtonClick:(UIButton *)sender
{
    NSString *url = @"http://tx.rutty.top/hanghao/switch/ns-game/list";
    NSDictionary *parameters = @{ @"name" : @"duke", @"pwd" : @"123" };
    [self.manager POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.log appendFormat:@">> sendAFNetworking: %@ \n", url];
        self.textView.text = self.log;
        NSLog(@"AFNetworking 请求返回的响应信息：%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    NSLog(@"sendAFNetworkingButtonClick");
}

#pragma mark - Getter -

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc] init];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
        _manager.requestSerializer.timeoutInterval = 15;
    }
    return _manager;
}

@end
