//
//  DKSanboxUtils.m
//  DKSkynet
//
//  Created by admin on 2022/7/20.
//

#import "DKSanboxUtils.h"
#import <DKKit/DKKitMacro.h>

@implementation DKSanboxUtils

- (void)getFileSizeWithPath:(NSString *)path
{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            // 文件夹
            NSArray *dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSString *subPath = nil;
            for (NSString *str in dirArray) {
                subPath = [path stringByAppendingPathComponent:str];
                [self getFileSizeWithPath:subPath];
            }
        } else {
            // 文件
            NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            NSInteger size = [dict[@"NSFileSize"] integerValue];
            _fileSize += size;
        }
    } else {
        // 不存在该文件 path
        DKLogWarn(@"不存在该文件");
    }
}

+ (void)shareURL:(NSURL *)url formVC:(UIViewController *)vc
{
    [self share:url formVC:vc];
}

+ (void)share:(id)object formVC:(UIViewController *)vc
{
    if (!object) {
        return;
    }
    NSArray *objectsToShare = @[object];//support NSString、NSURL、UIImage

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];

    if(dk_isIpad()){
        if ( [controller respondsToSelector:@selector(popoverPresentationController)] ) {
            controller.popoverPresentationController.sourceView = vc.view;
        }
        [vc presentViewController:controller animated:YES completion:nil];
    }else{
        [vc presentViewController:controller animated:YES completion:nil];
    }
}

@end
