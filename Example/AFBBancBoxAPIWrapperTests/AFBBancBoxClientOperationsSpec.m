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
#import "AFBBancBoxPerson.h"

SPEC_BEGIN(ClientOperationsSpec)

describe(@"The BancBox API wrapper", ^{    
    registerMatchers(@"AFB");
    
    AFBBancBoxConnection *conn = [AFBBancBoxConnection new];
    NSString *subscriberReferenceId = [NSString stringWithFormat:@"BancBoxTestClient-%i", (int)[[NSDate date] timeIntervalSince1970]];
    
#pragma mark - Add client
    context(@"when adding a new client", ^{
        AFBBancBoxClient *client = [AFBBancBoxClient new];
        client.clientIdSubscriberReferenceId = subscriberReferenceId;
        client.firstName = @"Bilbo";
        client.lastName = @"Baggins";
        client.dob = [[AFBBancBoxPerson birthdateDateFormatter] dateFromString:@"1972-01-04"];
        client.ssn = @"555-55-5555";
        
        __block BOOL addClientDone = NO;        
        
        [conn createClient:client.dictionaryForCreate success:^(AFBBancBoxResponse *response, id obj) {
            
            it(@"should get a result", ^{
                [response shouldNotBeNil];
            });
            
            it(@"should be successful", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            
            it(@"should return a BancBox ID", ^{
                [response.response[@"clientId"][@"bancBoxId"] shouldNotBeNil];
            });
            
            it(@"should return a subscriber reference ID equal to the one passed in" , ^{
                [[response.response[@"clientId"][@"subscriberReferenceId"] should] equal:subscriberReferenceId];
            });
            
            if (BANCBOX_USE_PRODUCTION) {
                it(@"should return a CIP status of UNVERIFIED", ^{
                    [[response.response[@"cipStatus"] should] equal:BancBoxClientCipStatusUnverified];
                });
            } else {
                it(@"should return a CIP status of IGNORED", ^{
                    [[response.response[@"cipStatus"] should] equal:BancBoxClientCipStatusIgnored];
                });
            }
            
            it(@"should return a valid client status", ^{
                [[response.response[@"clientStatus"] should] beValidClientStatus];
            });
            
            addClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            addClientDone = YES;
        }];
        POLL(addClientDone);
    });
    
#pragma mark - Update client
    context(@"when updating a client", ^{
        AFBBancBoxClient *client = [AFBBancBoxClient new];
        client.clientIdSubscriberReferenceId = subscriberReferenceId;
        NSString *newFirstName = @"Frodo";
        client.firstName = newFirstName;
        
        __block BOOL updateClientDone = NO;
        
        [conn updateClient:client.dictionaryForUpdate success:^(AFBBancBoxResponse *response, id obj) {
            it(@"should be successful", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            updateClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            updateClientDone = YES;
        }];
        POLL(updateClientDone);
        
        __block BOOL getClientDone = NO;
        
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        __block AFBBancBoxClient *updatedClient;
        
        [conn getClient:params success:^(AFBBancBoxResponse *response, id obj) {
            updatedClient = (AFBBancBoxClient *)obj;
            it(@"should actually update the client", ^{
                [[updatedClient.firstName should] equal:newFirstName];
            });
            getClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            getClientDone = YES;
        }];
        POLL(getClientDone);
    });

#pragma mark - Verify client
    // The following spec will only pass in production. A new client in the Sandbox environment should have a CIP status of 'IGNORED', which will allow account creation without verification.
    
    if (BANCBOX_USE_PRODUCTION) {
        context(@"when verifying a client", ^{
            NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
            
            __block BOOL verifyClientDone = NO;
            
            [conn verifyClient:params success:^(AFBBancBoxResponse *response, id obj) {
                it(@"should have a success status", ^{
                    [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
                });
                verifyClientDone = YES;
            } failure:^(AFBBancBoxResponse *response, id obj) {
                verifyClientDone = YES;
            }];
            POLL(verifyClientDone);
            
            __block BOOL getClientDone = NO;
            __block AFBBancBoxClient *updatedClient;
            
            [conn getClient:params success:^(AFBBancBoxResponse *response, id obj) {
                updatedClient = (AFBBancBoxClient *)obj;
                it(@"should update the client's status to VERIFIED", ^{
                    [[updatedClient.cipStatus should] equal:BancBoxClientCipStatusVerified];      // this will only pass in production
                });
                getClientDone = YES;
            } failure:^(AFBBancBoxResponse *response, id obj) {
                getClientDone = YES;
            }];
            POLL(getClientDone);
        });
    }
    
#pragma mark - Update client status
    context(@"when updating the client's status", ^{
        NSString *newStatus = BancBoxClientStatusSuspended;
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId }, @"clientStatus": newStatus };
        
        __block BOOL updateClientStatusDone = NO;
        
        [conn updateClientStatus:params success:^(AFBBancBoxResponse *response, id obj) {
            it(@"should have a success status", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            updateClientStatusDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            updateClientStatusDone = YES;
        }];
        POLL(updateClientStatusDone);
        
        __block BOOL getClientDone = NO;
        
        NSDictionary *nextParams = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        __block AFBBancBoxClient *updatedClient;
        
        [conn getClient:nextParams success:^(AFBBancBoxResponse *response, id obj) {
            updatedClient = (AFBBancBoxClient *)obj;
            it(@"should actually update the client", ^{
                [[updatedClient.clientStatus should] equal:newStatus];
            });
            getClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            getClientDone = YES;
        }];
        POLL(getClientDone);
    });

#pragma mark - Search for client    
    context(@"when searching for a client by status", ^{
        NSString *searchStatus = BancBoxClientStatusSuspended;
        NSDictionary *params = @{ @"clientStatus": searchStatus };
        
        __block BOOL searchClientDone = NO;
        __block NSArray *clients;
        
        [conn searchClients:params success:^(AFBBancBoxResponse *response, id obj) {
            clients = (NSArray *)obj;
            it(@"should find a client", ^{
                [[clients should] haveCountOf:1];
            });
            searchClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            searchClientDone = YES;
        }];
        POLL(searchClientDone);
    });
    
    context(@"when searching for a client by ID", ^{
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        
        __block BOOL searchClientDone = NO;
        __block NSArray *clients;
        
        [conn searchClients:params success:^(AFBBancBoxResponse *response, id obj) {
            clients = (NSArray *)obj;
            it(@"should find a client", ^{
                [[clients should] haveCountOf:1];
            });
            searchClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            searchClientDone = YES;
        }];
        POLL(searchClientDone);
    });
    
#pragma mark - Cancel client
    context(@"when canceling a client", ^{
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        
        __block BOOL cancelClientDone = NO;
        
        [conn cancelClient:params success:^(AFBBancBoxResponse *response, id obj) {
            it(@"should have a success status", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            cancelClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            cancelClientDone = YES;
        }];
        POLL(cancelClientDone);
        
        __block BOOL getClientDone = NO;
        
        NSDictionary *nextParams = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        __block AFBBancBoxClient *updatedClient;
        
        [conn getClient:nextParams success:^(AFBBancBoxResponse *response, id obj) {
            updatedClient = (AFBBancBoxClient *)obj;
            it(@"should set the client's status to CANCELLED", ^{
                [[updatedClient.clientStatus should] equal:BancBoxClientStatusCancelled];
            });
            getClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            getClientDone = YES;
        }];
        POLL(getClientDone);
    });
});

SPEC_END