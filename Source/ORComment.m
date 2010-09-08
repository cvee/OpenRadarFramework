//
//  ORComment.m
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

#import "ORComment.h"
#import "ORConstants.h"
#import <Foundation/NSDecimalNumber.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSLocale.h>
#import <Foundation/NSNumberFormatter.h>
#import <Foundation/NSString.h>


#pragma mark -
#pragma mark Constants

NSString *kORCommentBody = @"body";
NSString *kORCommentIdentifier = @"identifier";
NSString *kORCommentParentIdentifier = @"parentIdentifier";
NSString *kORCommentRadarNumber = @"radarNumber";
NSString *kORCommentSubject = @"subject";
NSString *kORCommentUserEmail = @"userEmail";

#pragma mark -

@implementation ORComment

#pragma mark -
#pragma mark Properties

@synthesize body;
@synthesize identifier;
@synthesize parentIdentifier;
@synthesize radarNumber;
@synthesize subject;
@synthesize userEmail;

#pragma mark -
#pragma mark Initialization

- (id)initWithDictionary:(NSDictionary *)aDictionary
{
    if (!(self = [super init])) { return nil; }

    NSLocale *locale = [[[NSLocale alloc]
        initWithLocaleIdentifier:ORWebServiceLocaleIdentifier] autorelease];
    NSNumberFormatter *numberFormatter =
        [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setLocale:locale];

    id aBody = [aDictionary objectForKey:@"body"];
    if ([aBody isKindOfClass:[NSString class]])
    {
        body = [(NSString *)aBody retain];
    }
    [self setBody:aBody];

    id anIdentifier = [aDictionary valueForKey:@"id"];
    if ([anIdentifier isKindOfClass:[NSNumber class]])
    {
        identifier = [(NSNumber *)anIdentifier retain];
    }
    else if ([anIdentifier isKindOfClass:[NSString class]])
    {
        identifier = [[numberFormatter numberFromString:(NSString *)anIdentifier] retain];
    }

    id aParentIdentifier = [aDictionary valueForKey:@"is_reply_to"];
    if ([aParentIdentifier isKindOfClass:[NSNumber class]])
    {
        parentIdentifier = [(NSNumber *)aParentIdentifier retain];
    }
    else if ([anIdentifier isKindOfClass:[NSString class]])
    {
        parentIdentifier = [[numberFormatter numberFromString:(NSString *)aParentIdentifier] retain];
    }

    id aRadarNumber = [aDictionary objectForKey:@"radar"];
    if ([aRadarNumber isKindOfClass:[NSNumber class]])
    {
        radarNumber = [(NSNumber *)aRadarNumber retain];
    }
    else if ([aRadarNumber isKindOfClass:[NSString class]])
    {
        radarNumber = [[numberFormatter numberFromString:(NSString *)aRadarNumber] retain];
    }

    id aSubject = [aDictionary objectForKey:@"subject"];
    if ([aSubject isKindOfClass:[NSString class]])
    {
        subject = [(NSString *)aSubject retain];
    }
    [self setSubject:aSubject];

    id anUserEmail = [aDictionary objectForKey:@"user"];
    if ([anUserEmail isKindOfClass:[NSString class]])
    {
        userEmail = [(NSString *)anUserEmail retain];
    }

    return self;
}

#pragma mark -
#pragma mark Deallocation

- (void)dealloc
{
    [body release];
    body = nil;
    [identifier release];
    identifier = nil;
    [identifier release];
    identifier = nil;
    [parentIdentifier release];
    parentIdentifier = nil;
    [radarNumber release];
    radarNumber = nil;
    [subject release];
    subject = nil;
    [userEmail release];
    userEmail = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark Protocol (NSCoding)

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:body forKey:kORCommentBody];
    [encoder encodeObject:identifier forKey:kORCommentIdentifier];
    [encoder encodeObject:parentIdentifier forKey:kORCommentParentIdentifier];
    [encoder encodeObject:radarNumber forKey:kORCommentRadarNumber];
    [encoder encodeObject:subject forKey:kORCommentSubject];
    [encoder encodeObject:userEmail forKey:kORCommentUserEmail];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (!(self = [self init])) { return nil; }

    body = [decoder decodeObjectForKey:kORCommentBody];
    identifier = [decoder decodeObjectForKey:kORCommentIdentifier];
    parentIdentifier = [decoder decodeObjectForKey:kORCommentParentIdentifier];
    radarNumber = [decoder decodeObjectForKey:kORCommentRadarNumber];
    subject = [decoder decodeObjectForKey:kORCommentSubject];
    userEmail = [decoder decodeObjectForKey:kORCommentUserEmail];

    return self;
}

#pragma mark -
#pragma mark Protocol (NSCopying)

- (id)copyWithZone:(NSZone *)zone
{
    ORComment *object = [[[self class] allocWithZone:zone] init];

    object->body = nil;
    [object setBody:[self body]];
    object->identifier = nil;
    [object setIdentifier:[self identifier]];
    object->parentIdentifier = nil;
    [object setParentIdentifier:[self parentIdentifier]];
    object->radarNumber = nil;
    [object setRadarNumber:[self radarNumber]];
    object->subject = nil;
    [object setSubject:[self subject]];
    object->userEmail = nil;
    [object setUserEmail:[self userEmail]];

    return object;
}

#pragma mark -
#pragma mark Protocol (NSObject)

- (NSString *)description
{
    return [[self identifier] stringValue];
}

@end
