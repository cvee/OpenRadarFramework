//
//  ORRadar.m
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

#import "ORRadar.h"
#import "ORConstants.h"
#import <Foundation/NSDecimalNumber.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSLocale.h>
#import <Foundation/NSNumberFormatter.h>
#import <Foundation/NSString.h>


#pragma mark -
#pragma mark Constants

NSString *kORRadarClassification = @"classification";
NSString *kORRadarDetails = @"details";
NSString *kORRadarIdentifier = @"identifier";
NSString *kORRadarNumber = @"number";
NSString *kORRadarProduct = @"product";
NSString *kORRadarProductVersion = @"productVersion";
NSString *kORRadarOriginated = @"originated";
NSString *kORRadarReproducible = @"reproducible";
NSString *kORRadarResolved = @"resolved";
NSString *kORRadarStatus = @"status";
NSString *kORRadarTitle = @"title";
NSString *kORRadarUserEmail = @"userEmail";

#pragma mark -

@implementation ORRadar

#pragma mark -
#pragma mark Properties

@synthesize classification;
@synthesize details;
@synthesize identifier;
@synthesize number;
@synthesize product;
@synthesize productVersion;
@synthesize originated;
@synthesize reproducible;
@synthesize resolved;
@synthesize status;
@synthesize title;
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

    id aClassification = [aDictionary objectForKey:@"classification"];
    if ([aClassification isKindOfClass:[NSString class]])
    {
        classification = [(NSString *)aClassification retain];
    }

    id aDetails = [aDictionary objectForKey:@"description"];
    if ([aDetails isKindOfClass:[NSString class]])
    {
        details = [(NSString *)aDetails retain];
    }

    id anIdentifier = [aDictionary valueForKey:@"id"];
    if ([anIdentifier isKindOfClass:[NSNumber class]])
    {
        identifier = [(NSNumber *)anIdentifier retain];
    }
    else if ([anIdentifier isKindOfClass:[NSString class]])
    {
        identifier = [[numberFormatter numberFromString:(NSString *)anIdentifier] retain];
    }

    id aNumber = [aDictionary objectForKey:@"number"];
    if ([aNumber isKindOfClass:[NSNumber class]])
    {
        number = [(NSNumber *)aNumber retain];
    }
    else if ([aNumber isKindOfClass:[NSString class]])
    {
        number = [[numberFormatter numberFromString:(NSString *)aNumber] retain];
    }

    id aProduct = [aDictionary objectForKey:@"product"];
    if ([aProduct isKindOfClass:[NSString class]])
    {
        product = [(NSString *)aProduct retain];
    }

    id aProductVersion = [aDictionary objectForKey:@"product_version"];
    if ([aProductVersion isKindOfClass:[NSString class]])
    {
        productVersion = [(NSString *)aProductVersion retain];
    }

    id anOriginatedDate = [aDictionary objectForKey:@"originated"];
    if ([anOriginatedDate isKindOfClass:[NSString class]])
    {
        originated = [(NSString *)anOriginatedDate retain];
    }

    id aReproducible = [aDictionary objectForKey:@"reproducible"];
    if ([aReproducible isKindOfClass:[NSString class]])
    {
        reproducible = [(NSString *)aReproducible retain];
    }

    id aResolved = [aDictionary objectForKey:@"resolved"];
    if ([aResolved isKindOfClass:[NSString class]])
    {
        resolved = [(NSString *)aResolved retain];
    }

    id aStatus = [aDictionary objectForKey:@"status"];
    if ([aStatus isKindOfClass:[NSString class]])
    {
        status = [(NSString *)aStatus retain];
    }

    id aTitle = [aDictionary objectForKey:@"title"];
    if ([aTitle isKindOfClass:[NSString class]])
    {
        title = [(NSString *)aTitle retain];
    }

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
    [classification release];
    classification = nil;
    [details release];
    details = nil;
    [identifier release];
    identifier = nil;
    [number release];
    number = nil;
    [product release];
    product = nil;
    [productVersion release];
    productVersion = nil;
    [originated release];
    originated = nil;
    [reproducible release];
    reproducible = nil;
    [resolved release];
    resolved = nil;
    [status release];
    status = nil;
    [title release];
    title = nil;
    [userEmail release];
    userEmail = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark Protocol (NSCoding)

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:classification forKey:kORRadarClassification];
    [encoder encodeObject:details forKey:kORRadarDetails];
    [encoder encodeObject:identifier forKey:kORRadarIdentifier];
    [encoder encodeObject:number forKey:kORRadarNumber];
    [encoder encodeObject:product forKey:kORRadarProduct];
    [encoder encodeObject:productVersion forKey:kORRadarProductVersion];
    [encoder encodeObject:originated forKey:kORRadarOriginated];
    [encoder encodeObject:reproducible forKey:kORRadarReproducible];
    [encoder encodeObject:resolved forKey:kORRadarResolved];
    [encoder encodeObject:status forKey:kORRadarStatus];
    [encoder encodeObject:title forKey:kORRadarTitle];
    [encoder encodeObject:userEmail forKey:kORRadarUserEmail];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (!(self = [self init])) { return nil; }

    classification = [decoder decodeObjectForKey:kORRadarClassification];
    details = [decoder decodeObjectForKey:kORRadarDetails];
    identifier = [decoder decodeObjectForKey:kORRadarIdentifier];
    number = [decoder decodeObjectForKey:kORRadarNumber];
    product = [decoder decodeObjectForKey:kORRadarProduct];
    productVersion = [decoder decodeObjectForKey:kORRadarProductVersion];
    originated = [decoder decodeObjectForKey:kORRadarOriginated];
    reproducible = [decoder decodeObjectForKey:kORRadarReproducible];
    resolved = [decoder decodeObjectForKey:kORRadarResolved];
    status = [decoder decodeObjectForKey:kORRadarStatus];
    title = [decoder decodeObjectForKey:kORRadarTitle];
    userEmail = [decoder decodeObjectForKey:kORRadarUserEmail];

    return self;
}

#pragma mark -
#pragma mark Protocol (NSCopying)

- (id)copyWithZone:(NSZone *)zone
{
    ORRadar *object = [[[self class] allocWithZone:zone] init];

    object->classification = nil;
    [object setClassification:[self classification]];
    object->details = nil;
    [object setDetails:[self details]];
    object->identifier = nil;
    [object setIdentifier:[self identifier]];
    object->number = nil;
    [object setNumber:[self number]];
    object->product = nil;
    [object setProduct:[self product]];
    object->productVersion = nil;
    [object setProductVersion:[self productVersion]];
    object->originated = nil;
    [object setOriginated:[self originated]];
    object->reproducible = nil;
    [object setReproducible:[self reproducible]];
    object->resolved = nil;
    [object setResolved:[self resolved]];
    object->status = nil;
    [object setStatus:[self status]];
    object->title = nil;
    [object setTitle:[self title]];
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
