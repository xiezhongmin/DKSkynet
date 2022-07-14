//
//  DKNetworkTransaction.h
//  DKSkynet
//
//  Created by admin on 2022/6/17.
//

#import <Foundation/Foundation.h>
#import "DKURLSessionTaskMetrics.h"

typedef NS_ENUM(NSInteger, DKNetworkTransactionState) {
    DKNetworkTransactionStateUnstarted,
    DKNetworkTransactionStateAwaitingResponse,
    DKNetworkTransactionStateReceivingData,
    DKNetworkTransactionStateFinished,
    DKNetworkTransactionStateFailed
};

typedef NS_ENUM(NSInteger, DKNetworkResponseMIMEType) {
    DKNetworkResponseMIMETypeJSON,
    DKNetworkResponseMIMETypeXML,
    DKNetworkResponseMIMETypeHTML,
    DKNetworkResponseMIMETypeText,
    DKNetworkResponseMIMETypeOther,
    DKNetworkResponseMIMETypeNULL
};


@interface DKNetworkTransaction : NSObject

@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, assign) NSInteger requestLength;
@property (nonatomic, assign) NSInteger responseLength;
@property (nonatomic, copy) NSString *requestMechanism;
@property (atomic, assign) DKNetworkTransactionState transactionState;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, copy) NSDate *startTime;
@property (nonatomic, assign) NSTimeInterval latency;
@property (nonatomic, assign) NSTimeInterval duration;

/// iOS10 开始, 使用 NSURLSessionTaskMetrics 来管理网络请求记录, 设置 taskMetrics 时开启
@property (nonatomic, assign, readonly) BOOL useURLSessionTaskMetrics;
@property (nonatomic, strong) DKURLSessionTaskMetrics *taskMetrics API_AVAILABLE(ios(10.0));

@property (atomic, assign) int64_t receivedDataLength;

/// Only applicable for image downloads. A small thumbnail to preview the full response.
@property (nonatomic, strong) UIImage *responseThumbnail;

/// Populated lazily. Handles both normal HTTPBody data and HTTPBodyStreams.
@property (nonatomic, copy, readonly) NSData *cachedRequestBody;

@property (nonatomic, copy) NSData *responseBody;

@property (nonatomic, assign) DKNetworkResponseMIMEType responseContentType;

@property (nonatomic, assign) BOOL repeated; // 是否为重复的网络请求

/// 用 dictionary 创建出一个 transaction
/// @param dictionary 包含所有关键属性的 dictionary
/// return 创建出来的 dictionary, 如果创建失败则返回 nil
+ (instancetype)transactionFromPropertyDictionary:(NSDictionary *)dictionary;

/// 生成包含 transaction 中关键 property 的 dictionary
/// discussion 可以用生成的 dictionary 创建出这个 transaction
- (NSDictionary *)dictionaryFromAllProperty;

+ (NSString *)readableStringFromTransactionState:(DKNetworkTransactionState)state;

@end

