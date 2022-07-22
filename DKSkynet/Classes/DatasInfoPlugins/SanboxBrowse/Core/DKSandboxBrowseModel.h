//
//  DKSandboxBrowseModel.h
//  DKSkynet
//
//  Created by admin on 2022/7/15.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DKSandboxBrowseFileType) {
    DKSandboxBrowseFileTypeDirectory = 0, // 目录
    DKSandboxBrowseFileTypeFile, // 文件
    DKSandboxBrowseFileTypeBack, // 返回
    DKSandboxBrowseFileTypeRoot, // 根目录
};

@interface DKSandboxBrowseModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) DKSandboxBrowseFileType type;

@end
