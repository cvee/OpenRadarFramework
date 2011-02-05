//
//  ORServiceClientTestCase.m
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

#import "ORServiceClientTestCase.h"
#import "ORServiceClient.h"
#import "ORConstants.h"
#import <Foundation/NSData.h>
#import <Foundation/NSError.h>
#import <Foundation/NSString.h>
#import <Foundation/NSThread.h>


NSString *const kORServiceClientTestCaseEmail = @"user@example.com";
NSString *const kORServiceClientTestCaseName = @"user";
NSString *const kORServiceClientTestCaseSigningKey = @"aoifwiejfeiwoij29309283";

@implementation ORServiceClientTestCase

- (BOOL)shouldRunOnMainThread
{
    return YES;
}

- (void)setUp
{
    serviceClient = [[ORServiceClient alloc] init];
    [serviceClient setDelegate:self];
}

- (void)tearDown
{
    [serviceClient release];
    serviceClient = nil;
}

- (void)testCreate
{
    GHAssertNotNil(serviceClient, @"%@ object was not created successfully.", [serviceClient className]);
}

- (void)testCommentsForPage
{
    [self prepare];

    [serviceClient commentsForPage:1];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testRadarForNumber
{
    [self prepare];

    [serviceClient radarForNumber:1];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testRadarNumbersForPage
{
    [self prepare];

    [serviceClient radarNumbersForPage:1];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testRadarsForPage
{
    [self prepare];

    [serviceClient radarsForPage:1];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testRadarsForUserName
{
    [self prepare];

    [serviceClient radarsForUserName:kORServiceClientTestCaseEmail page:1];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testSearch
{
    [self prepare];

    [serviceClient searchForString:kORServiceClientTestCaseEmail page:1];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

#pragma mark -
#pragma mark ORServiceClientDelegate

- (void)serviceClient:(LPServiceClient *)serviceClient didFailWithError:(NSError *)error;
{
    [self notify:kGHUnitWaitStatusFailure forSelector:NULL];
}

- (void)serviceClient:(ORServiceClient *)serviceClient didFinishWithComments:(NSArray *)aComments;
{
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testCommentsForPage)];
}

- (void)serviceClient:(ORServiceClient *)serviceClient didFinishWithRadars:(NSArray *)aRadars
{
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testRadarForNumber)];
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testRadarsForPage)];
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testRadarsForUserName)];
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testSearch)];
}

- (void)serviceClient:(ORServiceClient *)serviceClient didFinishWithRadarNumbers:(NSArray *)aRadarNumbers;
{
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testRadarNumbersForPage)];
}
 
@end
