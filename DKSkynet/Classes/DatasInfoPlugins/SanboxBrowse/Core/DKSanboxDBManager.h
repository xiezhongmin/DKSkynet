//
//  DKSkynetDBManager.h
//  DKSkynet
//
//  Created by admin on 2022/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKSanboxDBManager : NSObject

+ (DKSanboxDBManager *)shareManager;

@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, copy) NSString *tableName;

- (NSArray *)tablesAtDB;
- (NSArray *)dataAtTable;

@end

NS_ASSUME_NONNULL_END
