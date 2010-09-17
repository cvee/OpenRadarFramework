//
//  ORServiceClient.m
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

#import "ORServiceClient.h"
#import "LPServiceRequest.h"
#import "NSString+SBJSON.h"
#import "ORComment.h"
#import "ORConstants.h"
#import "ORRadar.h"
#import "ORServiceError.h"
#import <Foundation/NSArray.h>
#import <Foundation/NSError.h>
#import <Foundation/NSData.h>
#import <Foundation/NSDate.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSURLConnection.h>
#import <Foundation/NSURLError.h>
#import <Foundation/NSURLRequest.h>
#import <Foundation/NSURLResponse.h>


#pragma mark -
#pragma mark Constants
#pragma mark -

@interface ORServiceClient (Private)

// Web Service Callbacks
- (void)addRadarDidFinishWithResult:(NSDictionary *)result;
- (void)commentsForPageDidFinishWithResult:(NSArray *)result;
- (void)radarForNumberDidFinishWithResult:(NSDictionary *)result;
- (void)radarsForPageDidFinishWithResult:(NSArray *)result;
- (void)radarNumbersForPageDidFinishWithResult:(NSArray *)result;
- (void)testDidFinishWithResult:(NSDictionary *)result;

// NSURLConnection Delegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end

@implementation ORServiceClient (Private)

#pragma mark -
#pragma mark Web Service Callbacks

- (void)addRadarDidFinishWithResult:(NSDictionary *)aResult
{
    NSNumber *radarNumber = nil;

    NSLocale *locale = [[[NSLocale alloc]
        initWithLocaleIdentifier:ORWebServiceLocaleIdentifier] autorelease];
    NSNumberFormatter *numberFormatter =
        [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setLocale:locale];

    id aNumber = [aResult objectForKey:@"number"];
    if ([aNumber isKindOfClass:[NSNumber class]])
    {
        radarNumber = (NSNumber *)aNumber;
    }
    else if ([aNumber isKindOfClass:[NSString class]])
    {
        radarNumber = [[numberFormatter numberFromString:(NSString *)aNumber] retain];
    }

    if ([delegate respondsToSelector:@selector(serviceClient:addRadarDidFinishWithRadarNumber:)])
    {
        //[delegate serviceClient:self addRadarDidFinishWithRadarNumber:radarNumber];
    }
}

- (void)commentsForPageDidFinishWithResult:(NSArray *)result
{
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:[result count]];
    for (NSDictionary *commentDictionary in result)
    {
        ORComment *comment = [[[ORComment alloc] initWithDictionary:commentDictionary] autorelease];
        [comments addObject:comment];
    }

    if ([delegate respondsToSelector:@selector(serviceClient:commentsForPageDidFinishWithComments:)])
    {
        [delegate serviceClient:self commentsForPageDidFinishWithComments:comments];
    }
}

- (void)radarForNumberDidFinishWithResult:(NSDictionary *)result
{
    ORRadar *aRadar = nil;

    if ([result count] > 0)
    {
        aRadar = [[[ORRadar alloc] initWithDictionary:result] autorelease];
    }

    if ([delegate respondsToSelector:@selector(serviceClient:radarForNumberDidFinishWithRadar:)])
    {
        [delegate serviceClient:self radarForNumberDidFinishWithRadar:aRadar];
    }
}

- (void)radarsForPageDidFinishWithResult:(NSArray *)result
{
    NSMutableArray *radars = [NSMutableArray arrayWithCapacity:[result count]];
    for (NSDictionary *radarDictionary in result)
    {
        ORRadar *radar = [[[ORRadar alloc] initWithDictionary:radarDictionary] autorelease];
        [radars addObject:radar];
    }

    if ([delegate respondsToSelector:@selector(serviceClient:radarsForPageDidFinishWithRadars:)])
    {
        [delegate serviceClient:self radarsForPageDidFinishWithRadars:radars];
    }
}

- (void)radarNumbersForPageDidFinishWithResult:(NSArray *)result
{
    NSMutableArray *radarNumbers = [NSMutableArray arrayWithCapacity:[result count]];
    for (NSString *radarNumberString in result)
    {
        NSNumber *radarNumber = [NSDecimalNumber decimalNumberWithString:radarNumberString];
        [radarNumbers addObject:radarNumber];
    }

    if ([delegate respondsToSelector:@selector(serviceClient:radarNumbersForPageDidFinishWithRadarNumbers:)])
    {
        [delegate serviceClient:self radarNumbersForPageDidFinishWithRadarNumbers:radarNumbers];
    }
}

- (void)testDidFinishWithResult:(NSDictionary *)result
{
    if ([delegate respondsToSelector:@selector(serviceClient:didFinishWithResult:)])
    {
        [delegate serviceClient:self didFinishWithResult:result];
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
#ifdef CONFIGURATION_DEBUG
    NSLog(@"[%@ connectionDidFinishLoading:]", [self className]);
#endif

    LPServiceRequest *serviceRequest = [self requestForConnection:connection];
    if (serviceRequest != nil)
    {
        NSString *responseDataString =
            [[[NSString alloc] initWithData:[serviceRequest receivedData]
                                   encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *responseDictionary = [responseDataString JSONValue];

        // Check for error
        id errorObject = [responseDictionary objectForKey:@"error"];
        if (errorObject && [errorObject isKindOfClass:[NSString class]])
        {
            NSString *errorDescription = (NSString *)errorObject;
            NSError *error =
                [NSError errorWithDomain:ORServiceClientErrorDomain
                                    code:ORServiceClientErrorCodeUnknown
                                userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
            if ([delegate respondsToSelector:@selector(serviceClient:didFailWithError:)])
            {
                [delegate serviceClient:self didFailWithError:error];
            }
        }

        // Check for result
        id result = [responseDictionary objectForKey:@"result"];
        if(result == [NSNull null])
        {
            result = nil;
        }

        id target = [serviceRequest target];
        SEL selector = [serviceRequest selector];
        [target performSelector:selector withObject:result withObject:nil];
    }

    [super connectionDidFinishLoading:connection];
}

#pragma mark -

@end

@implementation ORServiceClient

@synthesize authorizationToken;

#pragma mark -
#pragma mark Initialization

- (id)init
{
    if (!(self = [super init]))
    {
        return nil;
    }

    return self;
}

#pragma mark -
#pragma mark Deallocation

- (void)dealloc
{
    [authorizationToken release];
    authorizationToken = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark Web Services

/**
 * @brief Submits a new radar.
 *
 * Use of this method requires authentication and write privileges.
 *
 * @param aRadar The radar.
 */
- (void)addRadar:(ORRadar *)aRadar
{
    NSString *encodedParameters = [NSString stringWithFormat:
        @"classification=%@&description=%@&number=%@&originated=%@&product=%@&product_version=%@&reproducible=%@&status=%@&title=%@",
        [[aRadar classification] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        [[aRadar details] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        [[[aRadar number] stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        [[aRadar originated] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        [[aRadar product] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        [[aRadar productVersion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        [[aRadar reproducible] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        [[aRadar status] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        [[aRadar title] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
    ];

    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/radars/add?auth=%@", ORBaseURLString, [self authorizationToken]];
    NSMutableURLRequest *aRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
    [aRequest setHTTPBody:[encodedParameters dataUsingEncoding:NSUTF8StringEncoding]];
    [aRequest setHTTPMethod:@"POST"];
    [self createConnectionWithURLRequest:aRequest
                                  target:self
                                selector:@selector(addRadarDidFinishWithResult:)];
}

- (void)commentsForPage:(NSUInteger)page
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/comments?page=%lu", ORBaseURLString, page];
    [self createConnectionWithURL:[NSURL URLWithString:requestURLString]
                           target:self
                         selector:@selector(commentsForPageDidFinishWithResult:)];
}

- (void)radarForNumber:(NSUInteger)aNumber
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/radar?number=%lu", ORBaseURLString, aNumber];
    [self createConnectionWithURL:[NSURL URLWithString:requestURLString]
                           target:self
                         selector:@selector(radarForNumberDidFinishWithResult:)];
}

- (void)radarsForPage:(NSUInteger)page
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/radars?page=%lu", ORBaseURLString, page];
    [self createConnectionWithURL:[NSURL URLWithString:requestURLString]
                           target:self
                         selector:@selector(radarsForPageDidFinishWithResult:)];
}

- (void)radarNumbersForPage:(NSUInteger)page
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/radars/numbers?page=%lu", ORBaseURLString, page];
    [self createConnectionWithURL:[NSURL URLWithString:requestURLString]
                           target:self
                         selector:@selector(radarNumbersForPageDidFinishWithResult:)];
}

- (void)test
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/test", ORBaseURLString];
    [self createConnectionWithURL:[NSURL URLWithString:requestURLString]
                           target:self
                         selector:@selector(testDidFinishWithResult:)];
}

@end
