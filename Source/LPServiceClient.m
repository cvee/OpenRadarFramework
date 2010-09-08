//
//  LPServiceClient.m
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

#import "LPServiceClient.h"
#import "LPServiceRequest.h"
#import <Foundation/NSError.h>
#import <Foundation/NSData.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSURLConnection.h>
#import <Foundation/NSURLError.h>
#import <Foundation/NSURLRequest.h>
#import <Foundation/NSURLResponse.h>


#pragma mark -
#pragma mark Constants

NSString *kLPServiceClientCurrentContentLength = @"currentContentLength";
NSString *kLPServiceClientExpectedContentLength = @"expectedContentLength";
NSString *kLPServiceClientReceivedData = @"receivedData";
NSString *kLPServiceClientRequest = @"request";
NSString *kLPServiceClientSelector = @"selector";
NSString *kLPServiceClientTarget = @"target";

#pragma mark -

@interface LPServiceClient (Private)

- (void)closeConnection:(NSURLConnection *)connection;
- (NSURLConnection *)createConnectionWithRequest:(LPServiceRequest *)serviceRequest;
- (void)removeRequestForConnection:(NSURLConnection *)connection;
- (void)setRequest:(LPServiceRequest *)aRequest forConnection:(NSURLConnection *)connection;

// NSURLConnection Delegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end

@implementation LPServiceClient (Private)

- (void)closeConnection:(NSURLConnection *)connection
{
    LPServiceRequest *serviceRequest = [self requestForConnection:connection];
    if (serviceRequest == nil) { return; }
}

- (NSURLConnection *)createConnectionWithRequest:(LPServiceRequest *)request
{
#ifdef CONFIGURATION_DEBUG
    NSLog(@"[LPServiceClient createConnectionWithRequest:target:selector:]");
#endif

    NSURLConnection *connection = [[[NSURLConnection alloc]
        initWithRequest:[request request] delegate:self] autorelease];
    if (connection == nil)
    {
        NSError *error = nil;
        if ([delegate respondsToSelector:@selector(serviceClient:didFailWithError:)])
        {
            [delegate serviceClient:self didFailWithError:error];
        }

        return nil;
    }

    [self setRequest:request forConnection:connection];

    return connection;
}

- (void)removeRequestForConnection:(NSURLConnection *)connection
{
    [connectionDictionary removeObjectForKey:[NSString stringWithFormat:@"%lu", [connection hash]]];
}

- (void)setRequest:(LPServiceRequest *)aRequest forConnection:(NSURLConnection *)connection
{
    [connectionDictionary setObject:aRequest forKey:[NSString stringWithFormat:@"%lu", [connection hash]]];
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
#ifdef CONFIGURATION_DEBUG
    NSLog(@"[LPServiceClient didFailWithError:]");
#endif

    NSString *errorString = nil;

#if defined MAC_OS_X_VERSION_10_6 && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_6
    errorString = NSURLErrorFailingURLStringErrorKey;
#else
    errorString = NSErrorFailingURLStringKey;
#endif
    
    // Log the error
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:errorString]);

    LPServiceRequest *serviceRequest = [self requestForConnection:connection];
    if (serviceRequest != nil)
    {
        // Remove any partially retrieved data
        NSMutableData *receivedData = [serviceRequest receivedData];
        [receivedData setLength:0];
    }

    [self closeConnection:connection];

    // Remove the connection information
    [self removeRequestForConnection:connection];

    if ([delegate respondsToSelector:@selector(serviceClient:didFailWithError:)])
    {
        [delegate serviceClient:self didFailWithError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
#ifdef CONFIGURATION_DEBUG
    NSLog(@"[LPServiceClient didReceiveData:]");
#endif

    LPServiceRequest *serviceRequest = [self requestForConnection:connection];
    if (serviceRequest == nil) { return; }

    NSMutableData *receivedData = [serviceRequest receivedData];
    [receivedData appendData:data];

    NSNumber *currentContentLength =
        [NSNumber numberWithUnsignedInteger:[receivedData length]];
    [serviceRequest setCurrentContentLength:currentContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
#ifdef CONFIGURATION_DEBUG
    NSLog(@"[LPServiceClient didReceiveResponse:]");
#endif

    LPServiceRequest *serviceRequest = [self requestForConnection:connection];
    if (serviceRequest == nil) { return; }

    // Reset receivedData
    NSMutableData *receivedData = [serviceRequest receivedData];
    [receivedData setLength:0];

    // Reset currentContentLength
    NSNumber *currentContentLength =
        [NSNumber numberWithUnsignedInteger:[receivedData length]];
    [serviceRequest setCurrentContentLength:currentContentLength];

    // Reset expectedContentLength
    NSNumber *expectedContentLength =
        [NSNumber numberWithUnsignedInteger:[response expectedContentLength]];
    [serviceRequest setExpectedContentLength:expectedContentLength];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse;
{
#ifdef CONFIGURATION_DEBUG
    NSLog(@"[LPServiceClient connection:willSendRequest:redirectResponse:]");
#endif

    // If the response did not cause a redirect, return the original request.
    if (redirectResponse == nil)
    {
        return request;
    }

    // The response caused a redirect, cancel the current connection and create
    // a new one with the redirect request.
    LPServiceRequest *newServiceRequest = nil;
    LPServiceRequest *originalServiceRequest =
        [self requestForConnection:connection];
    if (originalServiceRequest != nil)
    {
        newServiceRequest = [[LPServiceRequest alloc]
            initWithURL:[request URL]
                 target:[originalServiceRequest target]
               selector:[originalServiceRequest selector]];
    }

    // Create a connection with the new request
    if (newServiceRequest)
    {
        [self createConnectionWithRequest:newServiceRequest];
    }

    // Cleanup and cancel the original connection
    [self removeRequestForConnection:connection];
    [connection cancel];

    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
#ifdef CONFIGURATION_DEBUG
    NSLog(@"[LPServiceClient connectionDidFinishLoading:]");
#endif

    [self closeConnection:connection];

    // Remove the connection information
    [self removeRequestForConnection:connection];
}

#pragma mark -

@end

@implementation LPServiceClient

#pragma mark -
#pragma mark Properties

@synthesize delegate;

#pragma mark -
#pragma mark Initialization

- (id)init
{
    if (!(self = [super init])) { return nil; }

    connectionDictionary = [[NSMutableDictionary alloc] init];

    return self;
}

- (NSURLConnection *)createConnectionWithURL:(NSURL *)requestURL target:(id)aTarget selector:(SEL)aSelector
{
#ifdef CONFIGURATION_DEBUG
    NSLog(@"[LPServiceClient createConnectionWithURL:target:selector:]");
#endif

    LPServiceRequest *serviceRequest = [[LPServiceRequest alloc]
        initWithURL:requestURL target:aTarget selector:aSelector];

    return [self createConnectionWithRequest:serviceRequest];
}

#pragma mark -
#pragma mark Deallocation

- (void)dealloc
{
    [connectionDictionary release];
    connectionDictionary = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (LPServiceRequest *)requestForConnection:(NSURLConnection *)connection
{
#ifdef CONFIGURATION_DEBUG
    NSLog(@"[LPServiceClient requestForConnection:]");
#endif

    id object = [connectionDictionary objectForKey:[NSString stringWithFormat:@"%lu", [connection hash]]];
    if ([object isKindOfClass:[LPServiceRequest class]])
    {
        return (LPServiceRequest *)object;
    }

    return nil;
}

@end
