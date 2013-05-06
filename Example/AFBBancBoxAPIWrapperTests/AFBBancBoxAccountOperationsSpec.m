//
//  AFBBancBoxAccountOperationsSpec.m
//  AFBBancBoxAPIWrapper
//
//  Created by Adam Block on 5/5/13.
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
#import "AFBBancBoxExternalAccountCardCredit.h"
#import "AFBBancBoxExternalAccountPaypal.h"

// Note that in order for these tests to run you need to create a header file called "AFBBancBoxPrivateExternalAccountData.h"
// containing account details for linked external accounts.

SPEC_BEGIN(AccountOperationsSpec)

describe(@"The BancBox API wrapper", ^{
    registerMatchers(@"AFB");
    
    AFBBancBoxConnection *conn = [AFBBancBoxConnection new];
    NSString *subscriberReferenceId = [NSString stringWithFormat:@"BancBoxTestClient-%i", (int)[[NSDate date] timeIntervalSince1970]];
    
    AFBBancBoxClient *client = [AFBBancBoxClient new];
    client.clientIdSubscriberReferenceId = subscriberReferenceId;
    client.firstName = @"Bilbo";
    client.lastName = @"Baggins";
    client.dob = [[client birthdateDateFormatter] dateFromString:@"1972-01-04"];
    client.ssn = @"555-55-5555";
    
    // first create a new client we can work with
    __block BOOL addClientDone = NO;
    
    [conn createClient:client.dictionaryForCreate success:^(AFBBancBoxResponse *response, id obj) {
        addClientDone = YES;
    } failure:^(AFBBancBoxResponse *response, id obj) {
        addClientDone = YES;
    }];
    
    POLL(addClientDone);
    
    // Account ID for newly created account, to be tested later
    __block uint64_t newAccountBancBoxId;
    
// ---- Open account
    context(@"when adding an account for the client", ^{
        __block BOOL openAccountDone = NO;
        
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        __block AFBBancBoxResponse *apiResponse;
        __block AFBBancBoxInternalAccount *account;
        
        [conn openAccount:params success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            account = (AFBBancBoxInternalAccount *)obj;
            newAccountBancBoxId = account.bancBoxId;
            openAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            openAccountDone = YES;
        }];
        
        it(@"should be successful", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:BancBoxResponseStatusDescriptionPass];
        });
        
        it(@"should return an open account", ^{
            [[expectFutureValue(account.accountStatus) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:BancBoxAccountStatusOpen];
        });
        
        it(@"should return a general account", ^{
            [[expectFutureValue(account.accountType) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:BancBoxAccountTypeGeneral];
        });
        
        it(@"should return a new BancBox ID", ^{
            [[expectFutureValue(theValue(account.bancBoxId)) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] beGreaterThan:theValue(0)];
        });
        
        it(@"should return a routing number of the correct length", ^{
            [[expectFutureValue(account.routingNumber) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] haveLengthOf:9];
        });
        
        POLL(openAccountDone);
        
    });
    
// ---- Get client accounts
    context(@"when getting the accounts for a client using a dictionary", ^{
        __block BOOL getClientAccountsUsingDictionaryDone = NO;
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        __block AFBBancBoxResponse *apiResponse;
        __block NSArray *accounts;
        __block AFBBancBoxInternalAccount *account;
        
        [conn getClientAccounts:params success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            accounts = (NSArray *)obj;
            account = accounts[0];
            getClientAccountsUsingDictionaryDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            getClientAccountsUsingDictionaryDone = YES;
        }];
        
        it(@"should be successful", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:BancBoxResponseStatusDescriptionPass];
        });
        
        it(@"should return an account", ^{
            [[expectFutureValue(accounts) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] haveCountOf:1];
        });
        
        it(@"should return the account just created", ^{
            [[expectFutureValue(theValue(account.bancBoxId)) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:theValue(newAccountBancBoxId)];
        });
        
        POLL(getClientAccountsUsingDictionaryDone);
    });
    
    context(@"when getting the accounts for a client using a convenience method", ^{
        __block BOOL getClientAccountsUsingConvenienceMethodDone = NO;
        __block AFBBancBoxResponse *apiResponse;
        __block NSArray *accounts;
        __block AFBBancBoxInternalAccount *account;
        
        [conn getClientAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            accounts = (NSArray *)obj;
            account = accounts[0];
            getClientAccountsUsingConvenienceMethodDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            getClientAccountsUsingConvenienceMethodDone = YES;
        }];
        
        it(@"should be successful", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:BancBoxResponseStatusDescriptionPass];
        });
        
        it(@"should return an account", ^{
            [[expectFutureValue(accounts) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] haveCountOf:1];
        });
        
        it(@"should return the account just created", ^{
            [[expectFutureValue(theValue(account.bancBoxId)) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:theValue(newAccountBancBoxId)];
        });
        
        POLL(getClientAccountsUsingConvenienceMethodDone);
    });
    
// ---- Update account
    __block NSString *testAccountTitle = @"Test Account";
    
    context(@"when updating an account", ^{
        __block BOOL updateAccountDone = NO;
        NSDictionary *params = @{ @"accountId": @{ @"bancBoxId": [NSNumber numberWithLongLong:newAccountBancBoxId] }, @"title": testAccountTitle };
        __block AFBBancBoxResponse *apiResponse;
        
        [conn updateAccount:params success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            updateAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            updateAccountDone = YES;
        }];
        
        it(@"should be successful", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:BancBoxResponseStatusDescriptionPass];
        });
        
        POLL(updateAccountDone);
        
        /* the following test will not pass because BancBox is not including the "title" key in accounts returned by getClientAccounts
         
        __block BOOL getClientAccountsUsingConvenienceMethodDone = NO;
        __block NSArray *accounts;
        __block AFBBancBoxInternalAccount *account;
        
        [conn getClientAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            accounts = (NSArray *)obj;
            account = accounts[0];
            getClientAccountsUsingConvenienceMethodDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            getClientAccountsUsingConvenienceMethodDone = YES;
        }];
        
        it(@"should actually change the title", ^{
            [[expectFutureValue(account.title) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:testAccountTitle];
        });
        
        POLL(getClientAccountsUsingConvenienceMethodDone);
         */
    });
    
// ---- Link external accounts
    context(@"when linking an external PayPal account", ^{
        __block BOOL linkExternalAccountDone = NO;
        __block AFBBancBoxResponse *apiResponse;
        AFBBancBoxExternalAccountPaypal *ppAccount = [[AFBBancBoxExternalAccountPaypal alloc] initWithId:BANCBOX_LINK_EXTERNAL_ACCOUNT_PAYPAL_ID];
        NSString *paypalExternalAccountId = [NSString stringWithFormat:@"BancBoxTestExternalAccountPaypal-%i", (int)[[NSDate date] timeIntervalSince1970]];
        
        [conn linkExternalAccount:ppAccount accountReferenceId:paypalExternalAccountId bancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            linkExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            linkExternalAccountDone = YES;
        }];
        
        it(@"should be successful", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:BancBoxResponseStatusDescriptionPass];
        });
        
        POLL(linkExternalAccountDone);
        
        __block BOOL retrieveLinkedExternalAccountDone = NO;
        __block NSArray *retrievedAccounts;
        __block AFBBancBoxExternalAccount *account;
        
        [conn getClientLinkedExternalAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            retrievedAccounts = obj;
            account = retrievedAccounts.lastObject;
            retrieveLinkedExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            retrieveLinkedExternalAccountDone = YES;
        }];
        
        it(@"should add the linked account", ^{
            [[expectFutureValue(retrievedAccounts) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] haveCountOf:1];
        });
        
        it(@"should add a PayPal account", ^{
            [[expectFutureValue(theValue([account isKindOfClass:[AFBBancBoxExternalAccountPaypal class]])) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] beTrue];
        });
        
        it(@"should create an active account", ^{
            [[expectFutureValue(account.externalAccountStatus) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:@"ACTIVE"];
        });
        
        it(@"should create an account with the correct subscriber reference id", ^{
            [[expectFutureValue(account.subscriberReferenceId) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:paypalExternalAccountId];
        });
        
        POLL(retrieveLinkedExternalAccountDone);
    });

    context(@"when linking an external bank account", ^{
        __block BOOL linkExternalAccountDone = NO;
        __block AFBBancBoxResponse *apiResponse;
        AFBBancBoxExternalAccountBank *bankAccount = [[AFBBancBoxExternalAccountBank alloc] initWithRoutingNumber:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ROUTING_NUMBER accountNumber:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ACCOUNT_NUMBER holderName:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_HOLDER_NAME bankAccountType:BancBoxExternalAccountBankTypeChecking];
        NSString *bankExternalAccountId = [NSString stringWithFormat:@"BancBoxTestExternalAccountBank-%i", (int)[[NSDate date] timeIntervalSince1970]];
        
        [conn linkExternalAccount:bankAccount accountReferenceId:bankExternalAccountId bancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            linkExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            linkExternalAccountDone = YES;
        }];
        
        it(@"should be successful", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:BancBoxResponseStatusDescriptionPass];
        });
        
        POLL(linkExternalAccountDone);
        
        __block BOOL retrieveLinkedExternalAccountDone = NO;
        __block NSArray *retrievedAccounts;
        __block AFBBancBoxExternalAccount *account;
        
        [conn getClientLinkedExternalAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            retrievedAccounts = obj;
            account = retrievedAccounts.lastObject;
            retrieveLinkedExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            retrieveLinkedExternalAccountDone = YES;
        }];
        
        it(@"should add the linked account", ^{
            [[expectFutureValue(retrievedAccounts) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] haveCountOf:2];
        });
        
        it(@"should add a bank account", ^{
            [[expectFutureValue(theValue([account isKindOfClass:[AFBBancBoxExternalAccountBank class]])) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] beTrue];
        });
        
        it(@"should create an active account", ^{
            [[expectFutureValue(account.externalAccountStatus) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:@"ACTIVE"];
        });
        
        it(@"should create an account with the correct subscriber reference id", ^{
            [[expectFutureValue(account.subscriberReferenceId) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:bankExternalAccountId];
        });
        
        POLL(retrieveLinkedExternalAccountDone);
    });
    
    context(@"when linking an external credit card account", ^{
        __block BOOL linkExternalAccountDone = NO;
        __block AFBBancBoxResponse *apiResponse;
        
        AFBBancBoxExternalAccountCardCredit *ccAccount = [[AFBBancBoxExternalAccountCardCredit alloc] init];
        ccAccount.cardNumber = BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_NUMBER;
        ccAccount.expiryDate = BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_EXPIRY_DATE;
        ccAccount.creditCardType = BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_TYPE;
        ccAccount.name = BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_NAME;
        ccAccount.cvv = BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_CVV;
        ccAccount.addressLine1 = BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_ADDRESS_LINE1;
        ccAccount.addressCity = BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_ADDRESS_CITY;
        ccAccount.addressZipcode = BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_ZIPCODE;
        ccAccount.addressState = BANCBOX_LINK_EXTERNAL_ACCOUNT_CC_STATE;
        
        NSString *ccExternalAccountId = [NSString stringWithFormat:@"BancBoxTestExAcctCreditCard-%i", (int)[[NSDate date] timeIntervalSince1970]];
        
        [conn linkExternalAccount:ccAccount accountReferenceId:ccExternalAccountId bancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            linkExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            linkExternalAccountDone = YES;
        }];
        
        it(@"should be successful", ^{
            [[expectFutureValue(apiResponse.statusDescription) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:BancBoxResponseStatusDescriptionPass];
        });
        
        POLL(linkExternalAccountDone);
        
        __block BOOL retrieveLinkedExternalAccountDone = NO;
        __block NSArray *retrievedAccounts;
        __block AFBBancBoxExternalAccount *account;
        
        [conn getClientLinkedExternalAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            retrievedAccounts = obj;
            account = retrievedAccounts.lastObject;
            retrieveLinkedExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            retrieveLinkedExternalAccountDone = YES;
        }];
        
        it(@"should add the linked account", ^{
            [[expectFutureValue(retrievedAccounts) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] haveCountOf:3];
        });
        
        it(@"should add a bank account", ^{
            [[expectFutureValue(theValue([account isKindOfClass:[AFBBancBoxExternalAccountCardCredit class]])) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] beTrue];
        });
        
        it(@"should create an active account", ^{
            [[expectFutureValue(account.externalAccountStatus) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:@"ACTIVE"];
        });
        
        it(@"should create an account with the correct subscriber reference id", ^{
            [[expectFutureValue(account.subscriberReferenceId) shouldEventuallyBeforeTimingOutAfter(N_SEC_TO_POLL)] equal:ccExternalAccountId];
        });
        
        POLL(retrieveLinkedExternalAccountDone);
    });

/*
// ---- Canceling a client with existing accounts
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
 */
    
});

SPEC_END