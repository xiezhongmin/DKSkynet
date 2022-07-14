//
//  DKSkynetStorage+MMAP.m
//  DKSkynet
//
//  Created by admin on 2022/7/4.
//

#import "DKSkynetStorage+MMAP.h"

NSString * const kMmapPathExtension = @"mmap2";
NSString * const kFilePathExtension = @"log";

@implementation DKSkynetStorage (MMAP)

- (NSString *)loadMmapContentFromDirectory:(NSString *)directory fileName:(NSString *)fileName
{
    NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    NSString *mmapPath = [filePath stringByAppendingPathExtension:kMmapPathExtension];
    filePath = [filePath stringByAppendingPathExtension:kFilePathExtension];
    
    NSMutableString *results = [[NSMutableString alloc] init];
    NSString *fileString = [NSString stringWithContentsOfFile:filePath usedEncoding:NULL error:nil];
    if (fileString) {
        [results appendString:fileString];
    }
    
    NSString *mmapString = [NSString stringWithContentsOfFile:mmapPath usedEncoding:NULL error:nil];
    // mmap 被转储到日志文件后, mmap 第一个字可能会被直接标为 "\0"
    if (mmapString.length && [mmapString characterAtIndex:0] != '\0') {
        // mmap2 contains dirty data after \r line. see ptrbuffer.cc PtrBuffer::Write
        NSRange range = [mmapString rangeOfString:@"\r"];
        if (range.location != NSNotFound) {
            mmapString = [mmapString substringToIndex:range.location];
        }
        [results appendString:mmapString];
    }
    
    return results;
}


@end
