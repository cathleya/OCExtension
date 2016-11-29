//
//  NSData+GZip.m
//  SHComm
//
//  Created by SH on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSData+GZip.h"
//#import <zlib.h>

@implementation NSData(GZip)


+(NSData *)dataUncompressGZipData:(NSData *)gzipData
{
    /*
	if ([gzipData length] == 0){
		return gzipData; 
	}
	
    unsigned full_length = [gzipData length];  
    unsigned half_length = [gzipData length] / 2;  
	
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];  
    BOOL done = NO;  
    int status;  
    z_stream strm;  
    strm.next_in = (Bytef *)[gzipData bytes];  
    strm.avail_in = [gzipData length];  
    strm.total_out = 0;  
    strm.zalloc = Z_NULL;  
    strm.zfree = Z_NULL;  
    if (inflateInit2(&strm, (15+32)) != Z_OK) 
		return nil;  
    while (!done) {  
        // Make sure we have enough room and reset the lengths.  
        if (strm.total_out >= [decompressed length]) {  
            [decompressed increaseLengthBy: half_length];  
        }  
        strm.next_out = [decompressed mutableBytes] + strm.total_out;  
        strm.avail_out = [decompressed length] - strm.total_out;  
        // Inflate another chunk.  
        status = inflate (&strm, Z_SYNC_FLUSH);  
        if (status == Z_STREAM_END) {  
            done = YES;  
        } else if (status != Z_OK) {  
            break;  
        }  
		
    }  
    if (inflateEnd (&strm) != Z_OK) 
		return nil;  
    // Set real length.  
    if (done) {  
        [decompressed setLength: strm.total_out];  
        return [NSData dataWithData: decompressed];  
    } else {  
        return nil;  
    }
     */
    return nil;
}

+( NSData *)compressData:(NSData *)uncompressedData
{
    /*
    if (!uncompressedData || [uncompressedData length ] == 0 )  {
        
        NSLog ( @"%s: Error: Can't compress an empty or null NSData object." , __func__);
        
        return nil ;
        
    }
    
    z_stream zlibStreamStruct;
    
    zlibStreamStruct. zalloc     = Z_NULL ; // Set zalloc, zfree, and opaque to Z_NULL so
    
    zlibStreamStruct. zfree     = Z_NULL ; // that when we call deflateInit2 they will be
    
    zlibStreamStruct. opaque     = Z_NULL ; // updated to use default allocation functions.
    
    zlibStreamStruct. total_out = 0 ; // Total number of output bytes produced so far
    
    zlibStreamStruct. next_in   = ( Bytef *)[uncompressedData bytes ]; // Pointer to input bytes
    
    zlibStreamStruct. avail_in   = [uncompressedData length ]; // Number of input bytes left to process
    
    
    int initError = deflateInit2 (&zlibStreamStruct, Z_DEFAULT_COMPRESSION , Z_DEFLATED , ( 15 + 16 ), 8 , Z_DEFAULT_STRATEGY );
    
    if (initError != Z_OK )
    {
        NSString *errorMsg = nil ;
        switch (initError)
        {
            case Z_STREAM_ERROR :
                
                errorMsg = @"Invalid parameter passed in to function." ;
                
                break ;
                
            case Z_MEM_ERROR :
                
                errorMsg = @"Insufficient memory." ;
                
                break ;
                
            case Z_VERSION_ERROR :
                
                errorMsg = @"The version of zlib.h and the version of the library linked do not match." ;
                
                break ;
                
            default :
                
                errorMsg = @"Unknown error code." ;
                
                break ;
                
        }
        
        NSLog ( @"%s: deflateInit2() Error: \"%@\" Message: \"%s\"" , __func__, errorMsg, zlibStreamStruct. msg );
        return nil ;
    }
    
    // Create output memory buffer for compressed data. The zlib documentation states that
    
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    
    NSMutableData *compressedData = [ NSMutableData dataWithLength :[uncompressedData length] * 1.01 + 12 ];
    
    int deflateStatus;
    do
    {
        // Store location where next byte should be put in next_out
        
        zlibStreamStruct. next_out = [compressedData mutableBytes ] + zlibStreamStruct. total_out ;
        
        
        // Calculate the amount of remaining free space in the output buffer
        
        // by subtracting the number of bytes that have been written so far
        
        // from the buffer's total capacity
        
        zlibStreamStruct. avail_out = [compressedData length ] - zlibStreamStruct. total_out ;
        
        
        
        /* deflate() compresses as much data as possible, and stops/returns when
         
         the input buffer becomes empty or the output buffer becomes full. If
         
         deflate() returns Z_OK, it means that there are more bytes left to
         
         compress in the input buffer but the output buffer is full; the output
         
         buffer should be expanded and deflate should be called again (i.e., the
         
         loop should continue to rune). If deflate() returns Z_STREAM_END, the
         
         end of the input stream was reached (i.e.g, all of the data has been
         
         compressed) and the loop should stop. */

/*
        
        deflateStatus = deflate (&zlibStreamStruct, Z_FINISH );
        
        
        
    } while ( deflateStatus == Z_OK );
    
    // Check for zlib error and convert code to usable error message if appropriate
    
    if (deflateStatus != Z_STREAM_END )
    {
        NSString *errorMsg = nil ;
        switch (deflateStatus)
        {
            case Z_ERRNO :
                
                errorMsg = @"Error occured while reading file." ;
                
                break ;
                
            case Z_STREAM_ERROR :
                
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL)." ;
                
                break ;
                
            case Z_DATA_ERROR :
                
                errorMsg = @"The deflate data was invalid or incomplete." ;
                
                break ;
                
            case Z_MEM_ERROR :
                
                errorMsg = @"Memory could not be allocated for processing." ;
                
                break ;
                
            case Z_BUF_ERROR :
                
                errorMsg = @"Ran out of output buffer for writing compressed bytes." ;  
                
                break ;  
                
            case Z_VERSION_ERROR :  
                
                errorMsg = @"The version of zlib.h and the version of the library linked do not match." ;  
                
                break ;  
                
            default :  
                
                errorMsg = @"Unknown error code." ;  
                
                break ;  
                
        }  
        
        NSLog ( @"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"" , __func__, errorMsg, zlibStreamStruct. msg );  
        
        // Free data structures that were dynamically created for the stream.
        
        deflateEnd (&zlibStreamStruct);  
        
        return nil ;  
    }
    
    // Free data structures that were dynamically created for the stream.  
    
    deflateEnd (&zlibStreamStruct);  
    
    [compressedData setLength:zlibStreamStruct.total_out];
    
    return compressedData;
 */
    return nil;
}



@end
