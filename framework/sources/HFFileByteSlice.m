//
//  HFFileByteSlice.m
//  HexFiend_2
//
//  Created by Peter Ammon on 1/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <HexFiend/HFByteSlice_Private.h>
#import <HexFiend/HFFileByteSlice.h>
#import <HexFiend/HFFileReference.h>

@implementation HFFileByteSlice

- initWithFile:(HFFileReference *)file {
    REQUIRE_NOT_NULL(file);
    return [self initWithFile:file offset:0 length:[file length]];
}

- initWithFile:(HFFileReference *)file offset:(unsigned long long)off length:(unsigned long long)len {
    HFASSERT(HFSum(off, len) <= [file length]);
    REQUIRE_NOT_NULL(file);
    [super init];
    fileReference = [file retain];
    offset = off;
    length = len;
    return self;
}

- (unsigned long long)length { return length; }

- (void)copyBytes:(unsigned char *)dst range:(HFRange)range {
    HFASSERT(dst != NULL || range.length == 0);
    HFASSERT(range.length <= NSUIntegerMax);
    HFASSERT(range.length <= length);
    [fileReference readBytes:dst length:ll2l(range.length) from:HFSum(range.location, offset)];
}

- (HFByteSlice *)subsliceWithRange:(HFRange)range {
    HFASSERT(offset + length >= offset);
    HFASSERT(range.length > 0);
    HFASSERT(range.location < [self length]);
    HFASSERT([self length] - range.location >= range.length);
    return [[[[self class] alloc] initWithFile:fileReference offset:range.location + offset length:range.length] autorelease];
}

- (void)dealloc {
    [fileReference release];
    [super dealloc];
}

@end