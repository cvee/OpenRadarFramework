//
//  ORServiceClient.h
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

#ifndef ORSERVICECLIENT_H
#define ORSERVICECLIENT_H

#import "LPServiceClient.h"


@class NSArray;
@class ORRadar;
@protocol ORServiceClientDelegate;

/**
 * @brief Client for initiating web service requests.
 *
 *
 */
@interface ORServiceClient : LPServiceClient {}

- (void)addRadar:(ORRadar *)aRadar;

/**
 * @brief Retrieves a list of comments for the specified page.
 *
 * @param aPage the page number.
 */
- (void)commentsForPage:(NSUInteger)aPage;

/**
 * @brief Retrieves a list of radars for the specified page.
 *
 * @param aPage the page number.
 */
- (void)radarsForPage:(NSUInteger)aPage;

/**
 * @brief Retrieves a list of radar numbers for the specified page.
 *
 * @param aPage the page number.
 */
- (void)radarNumbersForPage:(NSUInteger)aPage;

/**
 * @brief
 *
 *
 */
- (void)test;

@end

/**
 * @brief Delegate for responding to web service responses.
 *
 *
 */
@protocol ORServiceClientDelegate <LPServiceClientDelegate>

@optional

/**
 * @method serviceClient:didFinishWithComments:
 * @brief
 *
 *
 *
 * @param serviceClient the ORServiceClient instance that initiated the request.
 * @param comments an NSArray of ORComment objects.
 */
- (void)serviceClient:(ORServiceClient *)serviceClient didFinishWithComments:(NSArray *)comments;

/**
 * @method serviceClient:didFinishWithRadars:
 * @brief
 *
 *
 *
 * @param serviceClient the ORServiceClient instance that initiated the request.
 * @param radars an NSArray of ORRadar objects.
 */
- (void)serviceClient:(ORServiceClient *)serviceClient didFinishWithRadars:(NSArray *)radars;

/**
 * @method serviceClient:didFinishWithRadarNumbers:
 * @brief
 *
 *
 *
 * @param serviceClient the ORServiceClient instance that initiated the request.
 * @param radarNumbers an NSArray of NSNumber objects.
 */
- (void)serviceClient:(ORServiceClient *)serviceClient didFinishWithRadarNumbers:(NSArray *)radarNumbers;

@end

#endif
