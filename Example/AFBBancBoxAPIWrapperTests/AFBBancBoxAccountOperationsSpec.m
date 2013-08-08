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
#import "AFBBancBoxMerchantData.h"
#import "AFBBancBoxPerson.h"

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
    client.dob = [[AFBBancBoxPerson birthdateDateFormatter] dateFromString:@"1972-01-04"];
    client.ssn = @"555-55-5555";
    
    // first create a new client we can work with
    __block BOOL addClientDone = NO;
    __block AFBBancBoxClient *createdClient;
    
    [conn createClient:client.dictionaryForCreate success:^(AFBBancBoxResponse *response, id obj) {
        createdClient = obj;
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
        __block AFBBancBoxInternalAccount *account;
        
        [conn openAccount:params success:^(AFBBancBoxResponse *response, id obj) {
            account = (AFBBancBoxInternalAccount *)obj;
            newAccountBancBoxId = account.bancBoxId;
            
            it(@"should be successful", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            
            it(@"should return an open account", ^{
                [[account.accountStatus should] equal:BancBoxAccountStatusOpen];
            });
            
            it(@"should return a general account", ^{
                [[account.accountType should] equal:BancBoxAccountTypeGeneral];
            });
            
            it(@"should return a new BancBox ID", ^{
                [[theValue(account.bancBoxId) should] beGreaterThan:theValue(0)];
            });
            
            it(@"should return a routing number of the correct length", ^{
                [[account.routingNumber should] haveLengthOf:9];
            });
            
            openAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            openAccountDone = YES;
        }];        
        POLL(openAccountDone);
    });
    
// ---- Get client accounts
    context(@"when getting the accounts for a client using a dictionary", ^{
        __block BOOL getClientAccountsUsingDictionaryDone = NO;
        NSDictionary *params = @{ @"clientId": @{ @"subscriberReferenceId": subscriberReferenceId } };
        __block NSArray *accounts;
        __block AFBBancBoxInternalAccount *account;
        
        [conn getClientAccounts:params success:^(AFBBancBoxResponse *response, id obj) {
            accounts = (NSArray *)obj;
            account = accounts[0];
            
            it(@"should be successful", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            
            it(@"should return an account", ^{
                [[accounts should] haveCountOf:1];
            });
            
            it(@"should return the account just created", ^{
                [[theValue(account.bancBoxId) should] equal:theValue(newAccountBancBoxId)];
            });
            
            getClientAccountsUsingDictionaryDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            getClientAccountsUsingDictionaryDone = YES;
        }];
        POLL(getClientAccountsUsingDictionaryDone);
    });
    
    context(@"when getting the accounts for a client using a convenience method", ^{
        __block BOOL getClientAccountsUsingConvenienceMethodDone = NO;
        __block NSArray *accounts;
        __block AFBBancBoxInternalAccount *account;
        
        [conn getClientAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            accounts = (NSArray *)obj;
            account = accounts[0];
            
            it(@"should be successful", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            
            it(@"should return an account", ^{
                [[accounts should] haveCountOf:1];
            });
            
            it(@"should return the account just created", ^{
                [[theValue(account.bancBoxId) should] equal:theValue(newAccountBancBoxId)];
            });
            
            getClientAccountsUsingConvenienceMethodDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            getClientAccountsUsingConvenienceMethodDone = YES;
        }];        
        POLL(getClientAccountsUsingConvenienceMethodDone);
    });
    
// ---- Update account
    __block NSString *testAccountTitle = @"Test Account";
    
    context(@"when updating an account", ^{
        __block BOOL updateAccountDone = NO;
        NSDictionary *params = @{ @"accountId": @{ @"bancBoxId": [NSNumber numberWithLongLong:newAccountBancBoxId] }, @"title": testAccountTitle };
        
        [conn updateAccount:params success:^(AFBBancBoxResponse *response, id obj) {
            it(@"should be successful", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            updateAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            updateAccountDone = YES;
        }];
        POLL(updateAccountDone);
        
        /* the following spec will not pass because BancBox is not including the "title" key in accounts returned by getClientAccounts
         
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
            [[account.title should] equal:testAccountTitle];
        });
        
        POLL(getClientAccountsUsingConvenienceMethodDone);
         */
    });
    
// ---- Assign Merchant ID
    /*
    context(@"when assigning a merchant ID", ^{
        __block BOOL assignMerchantIdDone = NO;
        
        AFBBancBoxExternalAccountBank *merchantBankAccount = [[AFBBancBoxExternalAccountBank alloc] initWithRoutingNumber:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ROUTING_NUMBER
                                                                                                            accountNumber:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ACCOUNT_NUMBER
                                                                                                               holderName:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_HOLDER_NAME
                                                                                                          bankAccountType:BancBoxExternalAccountBankTypeChecking];
        
        AFBBancBoxMerchantData *merchantData = [AFBBancBoxMerchantData new];
        merchantData.clientIdSubscriberReferenceId = subscriberReferenceId;
        merchantData.bankBusinessAccount = merchantBankAccount;
        merchantData.merchantCategoryCode = BANCBOX_ASSIGN_MERCHANT_ID_MERCHANT_CATEGORY_CODE;
        merchantData.maxTransactionAmount = BANCBOX_ASSIGN_MERCHANT_ID_MAX_TRANSACTION_AMOUNT;
        merchantData.customerServiceNumber = BANCBOX_ASSIGN_MERCHANT_ID_CUSTOMER_SERVICE_NUMBER;
        merchantData.softDescriptor = BANCBOX_ASSIGN_MERCHANT_ID_SOFTDESCRIPTOR;
        merchantData.primaryContactFirstName = BANCBOX_ASSIGN_MERCHANT_ID_PRIMARY_CONTACT_FIRST_NAME;
        merchantData.primaryContactLastName = BANCBOX_ASSIGN_MERCHANT_ID_PRIMARY_CONTACT_LAST_NAME;
        merchantData.primaryContactPhone = BANCBOX_ASSIGN_MERCHANT_ID_PRIMARY_CONTACT_PHONE;
        merchantData.primaryContactEmailAddress = BANCBOX_ASSIGN_MERCHANT_ID_PRIMARY_CONTACT_EMAIL_ADDRESS;
        merchantData.createCredentials = YES;
        merchantData.hasAcceptedCreditCards = NO;
        merchantData.visaAnnualSalesVolume = BANCBOX_ASSIGN_MERCHANT_ID_VISA_ANNUAL_SALES_VOLUME;
        merchantData.organizationType = BANCBOX_ASSIGN_MERCHANT_ID_ORGANIZATION_TYPE;
        
        NSDictionary *params = [merchantData dictionary];
        
        [conn assignMerchantId:params success:^(AFBBancBoxResponse *response, id obj) {
            it(@"should be successful", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            assignMerchantIdDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            assignMerchantIdDone = YES;
        }];
        
        POLL(assignMerchantIdDone);
    });
     */
    
// ---- Link external accounts
    context(@"when linking an external PayPal account", ^{
        __block BOOL linkExternalAccountDone = NO;
        AFBBancBoxExternalAccountPaypal *ppAccount = [[AFBBancBoxExternalAccountPaypal alloc] initWithId:BANCBOX_LINK_EXTERNAL_ACCOUNT_PAYPAL_ID];
        NSString *paypalExternalAccountId = [NSString stringWithFormat:@"BancBoxTestExternalAccountPaypal-%i", (int)[[NSDate date] timeIntervalSince1970]];
        
        [conn linkExternalAccount:ppAccount accountReferenceId:paypalExternalAccountId forClient:createdClient success:^(AFBBancBoxResponse *response, id obj) {
            it(@"should be successful", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            linkExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            linkExternalAccountDone = YES;
        }];        
        POLL(linkExternalAccountDone);
        
        __block BOOL retrieveLinkedExternalAccountDone = NO;
        __block NSArray *retrievedAccounts;
        __block AFBBancBoxExternalAccount *account;
        
        [conn getClientLinkedExternalAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            retrievedAccounts = obj;
            account = retrievedAccounts.lastObject;
            
            it(@"should add the linked account", ^{
                [[retrievedAccounts should] haveCountOf:1];
            });
            
            it(@"should add a PayPal account", ^{
                [[theValue([account isKindOfClass:[AFBBancBoxExternalAccountPaypal class]]) should] beYes];
            });
            
            it(@"should create an active account", ^{
                [[account.externalAccountStatus should] equal:@"ACTIVE"];
            });
            
            it(@"should create an account with the correct subscriber reference id", ^{
                [[account.subscriberReferenceId should] equal:paypalExternalAccountId];
            });
            
            retrieveLinkedExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            retrieveLinkedExternalAccountDone = YES;
        }];        
        POLL(retrieveLinkedExternalAccountDone);
    });

    context(@"when linking an external bank account", ^{
        __block BOOL linkExternalAccountDone = NO;
        AFBBancBoxExternalAccountBank *bankAccount = [[AFBBancBoxExternalAccountBank alloc] initWithRoutingNumber:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ROUTING_NUMBER accountNumber:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_ACCOUNT_NUMBER holderName:BANCBOX_LINK_EXTERNAL_ACCOUNT_BANK_HOLDER_NAME bankAccountType:BancBoxExternalAccountBankTypeChecking];
        NSString *bankExternalAccountId = [NSString stringWithFormat:@"BancBoxTestExternalAccountBank-%i", (int)[[NSDate date] timeIntervalSince1970]];
        
        [conn linkExternalAccount:bankAccount accountReferenceId:bankExternalAccountId forClient:createdClient success:^(AFBBancBoxResponse *response, id obj) {
            it(@"should be successful", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            linkExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            linkExternalAccountDone = YES;
        }];
        POLL(linkExternalAccountDone);
        
        __block BOOL retrieveLinkedExternalAccountDone = NO;
        __block NSArray *retrievedAccounts;
        __block AFBBancBoxExternalAccount *account;
        
        [conn getClientLinkedExternalAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            retrievedAccounts = obj;
            account = retrievedAccounts[0];
            
            it(@"should add the linked account", ^{
                [[retrievedAccounts should] haveCountOf:2];
            });
            
            it(@"should add a bank account", ^{
                [[theValue([account isKindOfClass:[AFBBancBoxExternalAccountBank class]]) should] beTrue];
            });
            
            it(@"should create an active account", ^{
                [[account.externalAccountStatus should] equal:@"ACTIVE"];
            });
            
            it(@"should create an account with the correct subscriber reference id", ^{
                [[account.subscriberReferenceId should] equal:bankExternalAccountId];
            });
            
            retrieveLinkedExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            retrieveLinkedExternalAccountDone = YES;
        }];
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
        
        [conn linkExternalAccount:ccAccount accountReferenceId:ccExternalAccountId forClient:createdClient success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            it(@"should be successful", ^{
                [[apiResponse.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            linkExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            linkExternalAccountDone = YES;
        }];
        POLL(linkExternalAccountDone);
        
        __block BOOL retrieveLinkedExternalAccountDone = NO;
        __block NSArray *retrievedAccounts;
        __block AFBBancBoxExternalAccount *account;
        
        [conn getClientLinkedExternalAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            retrievedAccounts = obj;
            account = retrievedAccounts[0];
            
            it(@"should add the linked account", ^{
                [[retrievedAccounts should] haveCountOf:3];
            });
            
            it(@"should add a bank account", ^{
                [[theValue([account isKindOfClass:[AFBBancBoxExternalAccountCardCredit class]]) should] beTrue];
            });
            
            it(@"should create an active account", ^{
                [[account.externalAccountStatus should] equal:@"ACTIVE"];
            });
            
            it(@"should create an account with the correct subscriber reference id", ^{
                [[account.subscriberReferenceId should] equal:ccExternalAccountId];
            });
            
            retrieveLinkedExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            retrieveLinkedExternalAccountDone = YES;
        }];
        POLL(retrieveLinkedExternalAccountDone);
    });
    
// ---- Update linked external account
    context(@"when updating a linked external PayPal account", ^{
        __block AFBBancBoxResponse *apiResponse;
        __block BOOL retrieveLinkedExternalAccountDone = NO;
        __block NSArray *retrievedAccounts;
        __block AFBBancBoxExternalAccountPaypal *account;
        
        // get existing account for its subscriber ID
        [conn getClientLinkedExternalAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            retrievedAccounts = obj;
            account = retrievedAccounts[2];
            retrieveLinkedExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            retrieveLinkedExternalAccountDone = YES;
        }];
        POLL(retrieveLinkedExternalAccountDone);
        
        __block BOOL updateLinkedExternalAccountDone = NO;
        AFBBancBoxExternalAccountPaypal *ppAccount = [[AFBBancBoxExternalAccountPaypal alloc] initWithId:BANCBOX_LINK_EXTERNAL_ACCOUNT_PAYPAL_ID_2];
        
        // update account
        [conn updateLinkedExternalAccount:ppAccount bancBoxId:@"" subscriberReferenceId:account.subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            apiResponse = response;
            it(@"should be successful", ^{
                [[apiResponse.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            updateLinkedExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            updateLinkedExternalAccountDone = YES;
        }];
        POLL(updateLinkedExternalAccountDone);
        
        
        __block BOOL retrieveLinkedExternalAccountAgainDone = NO;
        // get account again to confirm update was successful
        [conn getClientLinkedExternalAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            retrievedAccounts = obj;
            account = retrievedAccounts.lastObject;
            
            // BancBox does not return the full PayPal ID in a query, so we just test the first four characters. Of course this means that the test accounts
            // have to vary in the first four characters.
            it(@"should update the linked account", ^{
                [[[account.paypalId substringToIndex:4] should] equal:[BANCBOX_LINK_EXTERNAL_ACCOUNT_PAYPAL_ID_2 substringToIndex:4]];
            });
            retrieveLinkedExternalAccountAgainDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            retrieveLinkedExternalAccountAgainDone = YES;
        }];
        POLL(retrieveLinkedExternalAccountAgainDone);
    });
    
// ---- Delete linked external accounts
    context(@"when deleting linked external accounts", ^{
        __block BOOL retrieveLinkedExternalAccountDone = NO;
        __block NSArray *retrievedAccounts;
        
        // get existing linked accounts
        [conn getClientLinkedExternalAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            retrievedAccounts = obj;
            retrieveLinkedExternalAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            retrieveLinkedExternalAccountDone = YES;
        }];
        
        POLL(retrieveLinkedExternalAccountDone);
        
        __block NSMutableArray *deleteAccountsDoneBools = [NSMutableArray arrayWithArray:@[ [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO] ]];
        [retrievedAccounts enumerateObjectsUsingBlock:^(AFBBancBoxExternalAccount *account, NSUInteger idx, BOOL *stop) {
            [conn deleteLinkedExternalAccountForAccount:account success:^(AFBBancBoxResponse *response, id obj) {
                it(@"should be successful", ^{
                    [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
                });
                deleteAccountsDoneBools[idx] = [NSNumber numberWithBool:YES];
            } failure:^(AFBBancBoxResponse *response, id obj) {
                deleteAccountsDoneBools[idx] = [NSNumber numberWithBool:YES];
            }];
            POLL([deleteAccountsDoneBools[idx] boolValue]);
        }];
        
        __block BOOL retrieveLinkedExternalAccountAgainDone = NO;
        
        // get account again to confirm update was successful
        [conn getClientLinkedExternalAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            retrievedAccounts = obj;
            it(@"the linked external accounts should actually be deleted", ^{
                [[retrievedAccounts should] haveCountOf:0];
            });
            retrieveLinkedExternalAccountAgainDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            retrieveLinkedExternalAccountAgainDone = YES;
        }];    
        POLL(retrieveLinkedExternalAccountAgainDone);
    });
    

// ---- Canceling a client with existing accounts
    context(@"when canceling a client with an existing account", ^{
        __block BOOL cancelClientDone = NO;
        
        [conn cancelClientWithSubscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            it(@"should have a success status", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            
            NSArray *openAccounts = obj;
            it(@"the open account(s) should be returned", ^{
                [[openAccounts should] haveCountOf:1];
            });
            
            cancelClientDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            cancelClientDone = YES;
        }];
        POLL(cancelClientDone);
    });

// ---- Closing accounts
    context(@"when closing an internal account", ^{
        __block BOOL closeAccountDone = NO;
        
        NSDictionary *params = @{ @"accountId": @{ @"bancBoxId": [NSNumber numberWithLongLong:newAccountBancBoxId] } };
        [conn closeAccount:params success:^(AFBBancBoxResponse *response, id obj) {
            it(@"closing the account should be successful", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            closeAccountDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            closeAccountDone = YES;
        }];
        POLL(closeAccountDone);
        
        __block BOOL getClientAccountsDone = NO;
        __block NSArray *accounts;
        __block AFBBancBoxInternalAccount *account;
        
        [conn getClientAccountsForBancBoxId:@"" subscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            accounts = (NSArray *)obj;
            account = accounts[0];
            it(@"the account's status should change to CLOSED", ^{
                [[account.accountStatus should] equal:BancBoxAccountStatusClosed];
            });
            getClientAccountsDone = YES;
        } failure:^(AFBBancBoxResponse *response, id obj) {
            getClientAccountsDone = YES;
        }];
        POLL(getClientAccountsDone);
    });
    
// ---- Canceling a client with no open accounts
    context(@"when canceling a client with no open accounts", ^{
        __block BOOL cancelClientDone = NO;
        
        [conn cancelClientWithSubscriberReferenceId:subscriberReferenceId success:^(AFBBancBoxResponse *response, id obj) {
            it(@"should have a success status", ^{
                [[response.statusDescription should] equal:BancBoxResponseStatusDescriptionPass];
            });
            
            /* the following spec will fail due to a bug in BancBox that incorrectly returns a non-empty array
            NSArray *openAccounts = obj;
            it(@"should return no accounts", ^{
                [[openAccounts should] haveCountOf:0];      
            });
            */
             
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