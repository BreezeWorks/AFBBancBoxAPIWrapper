//
//  AFBBancBoxTransactionOperationsSpec.m
//  AFBBancBoxAPIWrapper
//
//  Created by Adam Block on 8/6/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import <Kiwi.h>
#import "AFBBancBoxSpecValidEnumerationMatcher.h"
#import "AFBAsyncSpecPoller.h"
#import "AFBBancBoxPrivateExternalAccountData.h"
#import "AFBBancBoxConnection.h"
#import "AFBBancBoxClient.h"
#import "AFBBancBoxResponse.h"
#import "AFBBancBoxInternalAccount.h"
#import "AFBBancBoxExternalAccountBank.h"
#import "AFBBancBoxLinkedExternalAccount.h"
#import "AFBBancBoxPerson.h"
#import "AFBBancBoxPaymentItem.h"
#import "AFBBancBoxPaymentItemStatus.h"

// Note that in order for these tests to run you need to create a header file called "AFBBancBoxPrivateExternalAccountData.h"
// containing account details for linked external accounts.

SPEC_BEGIN(TransactionOperationsSpec)

describe(@"The BancBox API wrapper", ^{
    registerMatchers(@"AFB");
    
    AFBBancBoxConnection *conn = [AFBBancBoxConnection new];
    NSString *subscriberReferenceId = [NSString stringWithFormat:@"BancBoxTestClient-%i", (int)[[NSDate date] timeIntervalSince1970]];
    
    AFBBancBoxClient *client = [AFBBancBoxClient new];
    client.clientIdSubscriberReferenceId = subscriberReferenceId;
    client.firstName = @"Bilbo";
    client.lastName = @"Baggins";
    client.dob = [[AFBBancBoxPerson birthdateDateFormatter] dateFromString:@"1972-01-04"];
    client.ssn = @"555-55-5555";
    
    // first create a new client we can work with
    __block BOOL addClientDone = NO;
    
    [conn createClient:client.dictionaryForCreate success:^(AFBBancBoxResponse *response, id obj) {
        addClientDone = YES;
    } failure:^(AFBBancBoxResponse *response, id obj) {
        addClientDone = YES;
    }];
    
    POLL(addClientDone);
    
    // Open account
    __block BOOL openAccountDone = NO;
    
    NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
    
    [conn openAccount:params success:^(AFBBancBoxResponse *response, id obj) {
        openAccountDone = YES;
    } failure:^(AFBBancBoxResponse *response, id obj) {
        openAccountDone = YES;
    }];
    
    POLL(openAccountDone);
    
    // Link external bank account
    
    __block BOOL linkExternalAccountDone = NO;
    AFBBancBoxExternalAccountBank *bankAccount = [[AFBBancBoxExternalAccountBank alloc] initWithRoutingNumber:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ROUTING_NUMBER accountNumber:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ACCOUNT_NUMBER holderName:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_HOLDER_NAME bankAccountType:BancBoxExternalAccountBankTypeChecking];
    NSString *bankExternalAccountId = [NSString stringWithFormat:@"ExAcctBk-%i", (int)[[NSDate date] timeIntervalSince1970]];
    
    __block AFBBancBoxLinkedExternalAccount *linkedAccount;
    
    [conn linkExternalAccount:bankAccount accountReferenceId:bankExternalAccountId bancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
        linkedAccount = obj;
        linkExternalAccountDone = YES;
    } failure:^(AFBBancBoxResponse *response, id obj) {
        linkExternalAccountDone = YES;
    }];
    POLL(linkExternalAccountDone);
    
    // Collect a credit card payment
    context(@"when collecting an ACH payment", ^{
    
        __block BOOL collectPaymentDone = NO;
        AFBBancBoxExternalAccountBank *sourceAccount = [[AFBBancBoxExternalAccountBank alloc] initWithRoutingNumber:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ROUTING_NUMBER_2 accountNumber:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ACCOUNT_NUMBER_2 holderName:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_HOLDER_NAME_2 bankAccountType:BancBoxExternalAccountBankTypeChecking];
        
        AFBBancBoxPaymentItem *item = [[AFBBancBoxPaymentItem alloc] initWithPaymentAmount:100.0 scheduleDate:nil referenceId:@"123" memo:@"Untitled job"];
        AFBBancBoxLinkedExternalAccount *destination = [[AFBBancBoxLinkedExternalAccount alloc] initWithAccountFromDictionary:@{ @"subscriberReferenceId": linkedAccount.subscriberReferenceId }];
        [conn collectFundsFromSource:sourceAccount destination:destination method:BancBoxCollectPaymentMethodAch items:@[ item ] success:^(AFBBancBoxResponse *response, id obj) {
            __block NSArray *paymentItemStatuses = (NSArray *)obj;
            
            it(@"should be successful", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            
            it(@"should return an array of PaymentItemStatuses", ^{
                [[paymentItemStatuses should] haveCountOf:1];
            });
            
            collectPaymentDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            collectPaymentDone = YES;
        }];
                                       
        POLL(collectPaymentDone);
    });
});

SPEC_END
