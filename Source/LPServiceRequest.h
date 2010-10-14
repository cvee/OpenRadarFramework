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

#ifndef LPSERVICEREQUEST_H
#define LPSERVICEREQUEST_H

#import <Foundation/NSDate.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSURLRequest.h>


@class NSMutableData;
@class NSMutableURLRequest;
@class NSNumber;
@class NSURL;
@class NSURLRequest;

@interface LPServiceRequest : NSObject {
@private
    NSNumber *currentContentLength;
    NSNumber *expectedContentLength;
    NSMutableData *receivedData;
    NSMutableURLRequest *request;
    SEL selector;
    id target;
}

// Properties
@property (nonatomic, retain) NSNumber *currentContentLength;
@property (nonatomic, retain) NSNumber *expectedContentLength;
@property (nonatomic, readonly) NSMutableData *receivedData;
@property (nonatomic, readonly) NSMutableURLRequest *request;
@property (nonatomic, readonly) SEL selector;
@property (nonatomic, readonly) id target;

// Accessors
- (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy;
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;

// Initialization
- (id)initWithURL:(NSURL *)anURL target:(id)aTarget selector:(SEL)aSelector;
- (id)initWithURLRequest:(NSURLRequest *)anURLRequest target:(id)aTarget selector:(SEL)aSelector;

// NSCopying Protocol
- (id)copyWithZone:(NSZone *)zone;

@end

#endif
