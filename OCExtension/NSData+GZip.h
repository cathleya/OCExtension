//
//  NSData+GZip.h
//  SHComm
//
//  Created by SH on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData(GZip)

//解压缩GZip文件数据
+(NSData *)dataUncompressGZipData:(NSData *)gzipData;

//压缩
+( NSData *)compressData:(NSData *)uncompressedData;

@end
