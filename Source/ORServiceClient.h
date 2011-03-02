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
 * @brief Client for initiating requests to the Open Radar web service.
 */
@interface ORServiceClient : LPServiceClient {
@private
    NSString *authorizationToken;
}

/**
 * @brief An authenticated user's authorization token.
 */
@property (nonatomic, copy) NSString *authorizationToken;

/**
 * @brief Requests the total number of available comment.
 */
- (void)commentCount;

/**
 * @brief Requests a list of comments for the specified page.
 *
 * @param aPage The page number.
 */
- (void)commentsForPage:(NSUInteger)aPage;

/**
 * @brief Submits a radar.
 *
 * Use of this method requires authentication and write privileges.
 *
 * @param aRadar The radar.
 */
- (void)postRadar:(ORRadar *)aRadar;

/**
 * @brief Requests the total number of available radars.
 */
- (void)radarCount;

/**
 * @brief Requests the radar matching for the specified number.
 *
 * @param aNumber The radar number.
 */
- (void)radarForNumber:(NSUInteger)aNumber;

/**
 * @brief Requests a list of radar numbers for the specified page.
 *
 * @param aPage The page number.
 */
- (void)radarNumbersForPage:(NSUInteger)aPage;

/**
 * @brief Requests a list of radars for the specified page.
 *
 * @param aPage The page number.
 */
- (void)radarsForPage:(NSUInteger)aPage;

/**
 * @brief Requests a list of radars for the specified user.
 *
 * @param anUserName The user name.
 * @param aPage The page number.
 */
- (void)radarsForUserName:(NSString *)anUserName page:(NSUInteger)aPage;

/**
 * @brief Requests a list of radars whose contents contain the specified string.
 *
 * @param aString The text to search for.
 * @param aPage The page number.
 */
- (void)searchForString:(NSString *)aString page:(NSUInteger)aPage;

@end

/**
 * @brief Allows an object to process responses from requests made using an ORServiceClient object.
 */
@protocol ORServiceClientDelegate <LPServiceClientDelegate>

@optional

/**
 * @brief Sent when a client request has failed.
 *
 * @param serviceClient The client instance that initiated the request.
 * @param error An error object containing details of why the client request failed.
 */
- (void)serviceClient:(LPServiceClient *)serviceClient didFailWithError:(NSError *)error;

/**
 * @brief Sent when a client request has successfully finished.
 *
 * @param serviceClient The client instance that initiated the request.
 * @param aComments An NSArray of ORComment objects.
 */
- (void)serviceClient:(ORServiceClient *)serviceClient didFinishWithComments:(NSArray *)aComments;

/**
 * @brief Sent when a client request has successfully finished.
 *
 * @param serviceClient The client instance that initiated the request.
 * @param aNumber An NSNumber.
 */
- (void)serviceClient:(ORServiceClient *)serviceClient didFinishWithNumber:(NSNumber *)aNumber;

/**
 * @brief Sent when a client request has successfully finished.
 *
 * @param serviceClient The client instance that initiated the request.
 * @param aRadars An NSArray of ORRadar objects.
 */
- (void)serviceClient:(ORServiceClient *)serviceClient didFinishWithRadars:(NSArray *)aRadars;

/**
 * @brief Sent when a client request has successfully finished.
 *
 * @param serviceClient The client instance that initiated the request.
 * @param aRadarNumbers An NSArray of NSNumber objects.
 */
- (void)serviceClient:(ORServiceClient *)serviceClient didFinishWithRadarNumbers:(NSArray *)aRadarNumbers;

@end

#endif
