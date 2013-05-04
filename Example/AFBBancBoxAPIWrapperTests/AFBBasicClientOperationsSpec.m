//
//  AFBBasicClientOperationsSpec.m
//  AFBBancBoxAPIWrapper
//
//  Created by Adam Block on 5/3/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

// 

#import <Kiwi.h>
#import "AFBBancBoxSpecValidEnumerationMatcher.h"
#import "AFBAsyncSpecPoller.h"
#import "AFBBancBoxConnection.h"
#import "AFBBancBoxClient.h"
#import "AFBBancBoxResponse.h"

SPEC_BEGIN(TestSpec)

describe(@"The BancBox wrapper", ^{    
    registerMatchers(@"AFB");
    
    AFBBancBoxConnection *conn = [AFBBancBoxConnection new];
    NSString *subscriberReferenceId = [NSString stringWithFormat:@"BancBoxTestClient-%i", (int)[[NSDate date] timeIntervalSince1970]];
    
    context(@"when adding a new client", ^{        
        AFBBancBoxClient *client = [AFBBancBoxClient new];
        client.clientIdSubscriberReferenceId = subscriberReferenceId;
        client.firstName = @"Bilbo";
        client.lastName = @"Baggins";
        client.dob = [[client birthdateDateFormatter] dateFromString:@"1972-01-04"];
        client.ssn = @"555-55-5555";
        
        __block BOOL addClientDone = NO;        
        __block AFBBancBoxResponse *apiResponse;
        
        [conn createClient:client.dictionaryForCreate success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            addClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            addClientDone = YES;
        }];
        
        it(@"should get a result", ^{
            [[expectFutureValue(apiResponse) shouldEventuallyBeforeTimingOutAfter(2.0)] beNonNil];
        });
        
        it(@"should be successful", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:BancBoxResponseStatusDescriptionPass];
        });
        
        it(@"should return a BancBox ID", ^{
            [[expectFutureValue(apiResponse.response[@"clientId"][@"bancBoxId"]) shouldEventuallyBeforeTimingOutAfter(2.0)] beNonNil];
        });
        
        it(@"should return a subscriber reference ID equal to the one passed in" , ^{
            [[expectFutureValue(apiResponse.response[@"clientId"][@"subscriberReferenceId"]) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:subscriberReferenceId];
        });
        
        it(@"should return a valid CIP status", ^{
            [[expectFutureValue(apiResponse.response[@"cipStatus"]) shouldEventuallyBeforeTimingOutAfter(2.0)] beValidCipStatus];
        });
        
        it(@"should return a valid client status", ^{
            [[expectFutureValue(apiResponse.response[@"clientStatus"]) shouldEventuallyBeforeTimingOutAfter(2.0)] beValidClientStatus];
        });
        
        POLL(addClientDone);
    });
    
    context(@"when updating a client", ^{
        AFBBancBoxClient *client = [AFBBancBoxClient new];
        client.clientIdSubscriberReferenceId = subscriberReferenceId;
        NSString *newFirstName = @"Frodo";
        client.firstName = newFirstName;
        
        __block BOOL updateClientDone = NO;
        __block AFBBancBoxResponse *apiResponse;
        
        [conn updateClient:client.dictionaryForUpdate success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            updateClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            updateClientDone = YES;
        }];
        
        it(@"should be successful", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:BancBoxResponseStatusDescriptionPass];
        });

        POLL(updateClientDone);
        
        __block BOOL getClientDone = NO;
        
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        __block AFBBancBoxClient *updatedClient;
        
        [conn getClient:params success:^(AFBBancBoxResponse *response, id obj) {
            updatedClient = (AFBBancBoxClient *)obj;
            getClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            getClientDone = YES;
        }];
        
        it(@"should actually update the client", ^{
            [[expectFutureValue(updatedClient.firstName) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:newFirstName];
        });
        
        POLL(getClientDone);
    });
    
    context(@"when verifying a client", ^{
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        
        __block BOOL verifyClientDone = NO;
        __block AFBBancBoxResponse *apiResponse;
        
        [conn verifyClient:params success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            verifyClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            verifyClientDone = YES;
        }];
        
        it(@"should have a success status", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:BancBoxResponseStatusDescriptionPass];
        });
        
        POLL(verifyClientDone);
        
        __block BOOL getClientDone = NO;
        __block AFBBancBoxClient *updatedClient;
        
        [conn getClient:params success:^(AFBBancBoxResponse *response, id obj) {
            updatedClient = (AFBBancBoxClient *)obj;
            getClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            getClientDone = YES;
        }];
        
        it(@"should update the client's status to VERIFIED", ^{
            [[expectFutureValue(updatedClient.cipStatus) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:BancBoxClientCipStatusVerified];      // this will only pass in production
        });
        
        POLL(getClientDone);
    });
    
    context(@"when updating the client's status", ^{
        NSString *newStatus = BancBoxClientStatusSuspended;
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId }, @"clientStatus": newStatus };
        
        __block BOOL updateClientStatusDone = NO;
        __block AFBBancBoxResponse *apiResponse;
        
        [conn updateClientStatus:params success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            updateClientStatusDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            updateClientStatusDone = YES;
        }];
        
        it(@"should have a success status", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:BancBoxResponseStatusDescriptionPass];
        });
        
        POLL(updateClientStatusDone);
        
        __block BOOL getClientDone = NO;
        
        NSDictionary *nextParams = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        __block AFBBancBoxClient *updatedClient;
        
        [conn getClient:nextParams success:^(AFBBancBoxResponse *response, id obj) {
            updatedClient = (AFBBancBoxClient *)obj;
            getClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            getClientDone = YES;
        }];
        
        it(@"should actually update the client", ^{
            [[expectFutureValue(updatedClient.clientStatus) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:newStatus];
        });
        
        POLL(getClientDone);
    });
    
    context(@"when searching for a client by status", ^{
        NSString *searchStatus = BancBoxClientStatusSuspended;
        NSDictionary *params = @{ @"clientStatus": searchStatus };
        
        __block BOOL searchClientDone = NO;
        __block NSArray *clients;
        
        [conn searchClients:params success:^(AFBBancBoxResponse *response, id obj) {
            clients = (NSArray *)obj;
            searchClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            searchClientDone = YES;
        }];
        
        it(@"should find a client", ^{
            [[expectFutureValue(clients) shouldEventuallyBeforeTimingOutAfter(2.0)] haveCountOfAtLeast:1];      // this will allow the test to pass even if the BancBox account isn't cleared of data first, but it's not deterministic
        });
        
        POLL(searchClientDone);
    });
    
    context(@"when searching for a client by ID", ^{
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        
        __block BOOL searchClientDone = NO;
        __block NSArray *clients;
        
        [conn searchClients:params success:^(AFBBancBoxResponse *response, id obj) {
            clients = (NSArray *)obj;
            searchClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            searchClientDone = YES;
        }];
        
        it(@"should find a client", ^{
            [[expectFutureValue(clients) shouldEventuallyBeforeTimingOutAfter(2.0)] haveCountOf:1];
        });
        
        POLL(searchClientDone);
    });
    
    context(@"when canceling a client", ^{
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        
        __block BOOL cancelClientDone = NO;
        __block AFBBancBoxResponse *apiResponse;
        
        [conn cancelClient:params success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            cancelClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            cancelClientDone = YES;
        }];
        
        it(@"should have a success status", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:BancBoxResponseStatusDescriptionPass];
        });
        
        POLL(cancelClientDone);
        
        __block BOOL getClientDone = NO;
        
        NSDictionary *nextParams = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        __block AFBBancBoxClient *updatedClient;
        
        [conn getClient:nextParams success:^(AFBBancBoxResponse *response, id obj) {
            updatedClient = (AFBBancBoxClient *)obj;
            getClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            getClientDone = YES;
        }];
        
        it(@"should set the client's status to CANCELLED", ^{
            [[expectFutureValue(updatedClient.clientStatus) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:BancBoxClientStatusCancelled];
        });
        
        POLL(getClientDone);
    });
});

SPEC_END