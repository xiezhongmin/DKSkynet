//
//  DKSkynetDBManager.m
//  DKSkynet
//
//  Created by admin on 2022/7/22.
//

#import "DKSanboxDBManager.h"
#import <sqlite3.h>

@interface DKSanboxDBManager ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DKSanboxDBManager

+ (DKSanboxDBManager *)shareManager
{
    static DKSanboxDBManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

// 打开数据库
- (sqlite3 *)openDB
{
    sqlite3 *db = nil;
    sqlite3_open([self.dbPath UTF8String], &db);
    return db;
}

// 获取指定路径数据库中的数据表
- (NSArray *)tablesAtDB
{
    sqlite3 *db = [self openDB];
    if (db == nil) {
        return @[];
    }
    NSMutableArray *tableNameArray = [NSMutableArray array];
    //查询sqlite_master表
    NSString *sql = @"select type, tbl_name from sqlite_master";
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *type_c = sqlite3_column_text(stmt, 0);
            const unsigned char *tbl_name_c = sqlite3_column_text(stmt, 1);
            NSString *type = [NSString stringWithUTF8String:(const char *)type_c];
            NSString *tbl_name = [NSString stringWithUTF8String:(const char *)tbl_name_c];
            if (type && [type isEqualToString:@"table"]) {
                [tableNameArray addObject:tbl_name];
            }
        }
    }
    return tableNameArray;
}

// 获取每一张表中的所有数据
- (NSArray *)dataAtTable
{
    sqlite3 *db = [self openDB];
    if (db == nil) {
        return @[];
    }
    //查询sqlite_master表
    NSString *sql = [NSString stringWithFormat:@"select * from %@",self.tableName];
    //执行sql
    char *errmsg = nil;
    sqlite3_exec(db, [sql UTF8String], selectCallback, nil, &errmsg);
    
    //处理数据
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.dataArray];
    [self.dataArray removeAllObjects];
    
    return arrayM;
}

// 查询回调
int selectCallback(void *firstValue,int columnCount, char **columnValues, char **columnNames)
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int i = 0; i < columnCount; i++) {
        //获取当前的列表（字段名）
        char *columnName = columnNames[i];
        NSString *nameStr = nil;
        if (columnName == NULL) {
            nameStr = nil;
        }else{
            nameStr = [NSString stringWithUTF8String:columnName];
        }
        
        //获取当前字段的值
        char *columnValue = columnValues[i];
        NSString *valueStr = nil;
        if (columnValue == NULL) {
            valueStr = nil;
        }else{
            valueStr = [NSString stringWithUTF8String:columnValue];
        }
        
        if (nameStr.length>0) {
            [dict setValue:valueStr forKey:nameStr];
        }
    }
    [[[DKSanboxDBManager shareManager] dataArray] addObject:dict];
    return 0;
}

#pragma mark - Getter -

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
