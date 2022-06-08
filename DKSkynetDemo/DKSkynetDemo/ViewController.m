//
//  ViewController.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/26.
//

#import "ViewController.h"
#import <DKSkynet.h>

@interface ViewController () {
    BOOL _isShow;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor brownColor];
    NSLog(@"DKSkynet init");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _isShow = !_isShow;
    
    if (_isShow) {
        [[DKSkynet shared] startServer];
    } else {
        [[DKSkynet shared] stopServer];
    }
}


@end
