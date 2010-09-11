//
//  LPServiceClient.h
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

#ifndef LPSERVICECLIENT_H
#define LPSERVICECLIENT_H

#import <Foundation/NSObject.h>


@class NSError;
@class NSMutableDictionary;
@class NSURL;
@class NSURLConnection;
@class LPServiceRequest;
@protocol LPServiceClientDelegate;

/**
 * @brief Client for initiating requests to a web service.
 *
 *
 */
@interface LPServiceClient : NSObject {
    NSMutableDictionary *connectionDictionary;
    id delegate;
}

// Properties

/**
 *
 */
@property (nonatomic, assign) id delegate;

// Initialization

/**
 * @brief Creates a new connection.
 *
 * @param aRequestURL The request URL.
 * @param aTarget The target.
 * @param aSelector The selector.
 */
- (NSURLConnection *)createConnectionWithURL:(NSURL *)aRequestURL target:(id)aTarget selector:(SEL)aSelector;

// Accessors

/**
 * @brief Returns the service request instance associated with the specified connection instance.
 *
 * @param connection the connection.
 * @return the service request instance.
 */
- (LPServiceRequest *)requestForConnection:(NSURLConnection *)connection;

@end

/**
 * @brief Allows an object to process responses from requests made using a LPServiceClient object.
 */
@protocol LPServiceClientDelegate <NSObject>

@optional

/**
 * @brief Sent when a client request has successfully finished.
 *
 * @param serviceClient The client instance that initiated the request.
 * @param result The result of client request.
 */
- (void)serviceClient:(LPServiceClient *)serviceClient didFinishWithResult:(NSDictionary *)result;

/**
 * @brief Sent when a client request has failed.
 *
 * @param serviceClient The client instance that initiated the request.
 * @param error An error object containing details of why the client request failed.
 */
- (void)serviceClient:(LPServiceClient *)serviceClient didFailWithError:(NSError *)error;

@end

#endif
