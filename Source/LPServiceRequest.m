//
//  LPServiceRequest.m
//
//  Copyright (c) 2010, Luna Park
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without 
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, 
//    this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//  * Neither the name of the organization nor the names of its contributors
//    may be used to endorse or promote products derived from this software 
//    without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//  POSSIBILITY OF SUCH DAMAGE.
//

#import "LPServiceRequest.h"
#import <Foundation/NSDecimalNumber.h>
#import <Foundation/NSData.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSURLRequest.h>
#import <Foundation/NSURLResponse.h>


@implementation LPServiceRequest

#pragma mark -
#pragma mark Properties

@synthesize currentContentLength;
@synthesize expectedContentLength;
@synthesize receivedData;
@synthesize request;
@synthesize selector;
@synthesize target;


#pragma mark -
#pragma mark Initialization

- (id)init
{
    if (!(self = [super init]))
    {
        return nil;
    }

    currentContentLength = [[NSNumber alloc] initWithUnsignedInteger:0];
    expectedContentLength = [[NSNumber alloc] initWithLongLong:NSURLResponseUnknownLength];

    return self;
}

- (id)initWithURL:(NSURL *)anURL target:(id)aTarget selector:(SEL)aSelector
{
    if (!(self = [self initWithURLRequest:[NSMutableURLRequest requestWithURL:anURL] target:aTarget selector:aSelector]))
    {
        return nil;
    }

    return self;
}

- (id)initWithURLRequest:(NSURLRequest *)anURLRequest target:(id)aTarget selector:(SEL)aSelector;
{
    if (!(self = [self init]))
    {
        return nil;
    }

    receivedData = [[NSMutableData alloc] init];
    request = [anURLRequest mutableCopy];
    target = aTarget;
    selector = aSelector;

    return self;
}

#pragma mark -
#pragma mark Deallocation

- (void)dealloc
{
    [currentContentLength release];
    currentContentLength = nil;
    [expectedContentLength release];
    expectedContentLength = nil;
    [receivedData release];
    receivedData = nil;
    [request release];
    request = nil;
    target = nil;
    selector = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
    [request setCachePolicy:cachePolicy];
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    [request setTimeoutInterval:timeoutInterval];
}

#pragma mark -
#pragma mark Protocol (NSCopying)

- (id)copyWithZone:(NSZone *)zone
{
    LPServiceRequest *object = [[[self class] allocWithZone:zone] init];

    object->currentContentLength = nil;
    [object setCurrentContentLength:[self currentContentLength]];
    object->expectedContentLength = nil;
    [object setExpectedContentLength:[self expectedContentLength]];
    object->receivedData = nil;
    object->receivedData = [[self receivedData] mutableCopy];
    object->request = nil;
    object->request = [[self request] mutableCopy];
    object->target = nil;
    object->target = [self target];
    object->selector = nil;
    object->selector = [self selector];

    return object;
}

@end
