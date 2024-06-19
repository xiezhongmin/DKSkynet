//
//  UIImage+DKSanbox.m
//  DKSkynet
//
//  Created by admin on 2022/7/20.
//

#import "UIImage+DKSanbox.h"

@implementation UIImage (DKSanbox)

+ (nullable UIImage *)dk_xcassetImageNamed:(NSString *)name
{
    if(name &&
       ![name isEqualToString:@""]) {
        NSURL *url = [[NSBundle bundleForClass:NSClassFromString(@"DKSkynet")] URLForResource:@"DKSanbox" withExtension:@"bundle"];
        if(!url) return [UIImage new];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        UIImage *image = [UIImage imageNamed:name inBundle:imageBundle compatibleWithTraitCollection:nil];
        return image;
    }
    
    return nil;
}

@end
