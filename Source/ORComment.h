//
//  ORComment.h
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

#ifndef ORCOMMENT_H
#define ORCOMMENT_H

#import <Foundation/NSObject.h>
#import <Foundation/NSZone.h>


@class NSCoder;
@class NSDictionary;
@class NSNumber;
@class NSString;

/**
 * @brief Class representation of a comment.
 *
 *
 */
@interface ORComment : NSObject <NSCoding, NSCopying> {
@private
    NSString *body;
    NSNumber *identifier;
    NSNumber *parentIdentifier;
    NSNumber *radarNumber;
    NSString *subject;
    NSString *userEmail;
}

// Properties
@property (nonatomic, copy) NSString *body;
@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSNumber *parentIdentifier;
@property (nonatomic, retain) NSNumber *radarNumber;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *userEmail;

// Initialization
- (id)initWithDictionary:(NSDictionary *)aDictionary;

// Protocol NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

// Protocol NSCopying
- (id)copyWithZone:(NSZone *)zone;

// Protocol NSObject
- (NSString *)description;

@end

#endif
