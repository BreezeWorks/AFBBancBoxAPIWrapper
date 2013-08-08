//
//  AFBBancBoxConnection.h
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//
//  Version 0.2 for BancBox API Version 1

#import <Foundation/Foundation.h>
#import "AFBBancBox.h"

#define BANCBOX_BASE_URL_PRODUCTION @"https://api.bancbox.com/v3/BBXPortRest/"
#define BANCBOX_BASE_URL_SANDBOX @"https://sandbox-api.bancbox.com/v3/BBXPortRest/"

// Set the following as appropriate for sandbox or production use
#define BANCBOX_USE_PRODUCTION 0

#if BANCBOX_USE_PRODUCTION
#define BANCBOX_SELECTED_SERVER_BASE_URL BANCBOX_BASE_URL_PRODUCTION
#else
#define BANCBOX_SELECTED_SERVER_BASE_URL BANCBOX_BASE_URL_SANDBOX
#endif

extern NSString * const BancBoxCollectPaymentMethodBook;
extern NSString * const BancBoxCollectPaymentMethodAch;
extern NSString * const BancBoxCollectPaymentMethodCreditCard;

typedef void(^ BancBoxResponseBlock)(AFBBancBoxResponse *response, id obj);


@interface AFBBancBoxConnection : NSObject

+ (AFBBancBoxConnection *)sharedConnection;

/*
Use the createClient method to register a user (Client) onto the BancBox platform. Creating the client is the first step to tokenizing external account information, such as a credit card number, or for opening a bank account for your user, collecting money into the account, and sending money to billers or other users. It is important to note, for the purposes of tokenizing payment information, such as external bank account for ACH collections, or credit card information, you do not need to provide DOB or SSN information. However, when creating a bank account under the client, the following four fields are required:
 
    1. First Name
    2. Last Name
    3. DOB
    4. SSN
 
While createClient will not fail if you do not provide the DOB and SSN, you will not be able to execute openAccount for that client until you provide correct information for these fields, and subsequently, use the verifyClient API to perform identity verification necessary for opening a bank account.
*/

- (void)createClient:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)createClientWithObject:(AFBBancBoxClient *)client success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use the updateClient API to change the details of an already existing client.
- (void)updateClient:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use to update the status of a client. The status can be ACTIVE, INACTIVE, SUSPENDED or DELETED.
- (void)updateClientStatus:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)updateClientStatusWithStatus:(NSString *)status bancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use the linkFile API to attach a file to a client.
- (void)linkFile:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use searchClients to lookup clients registered in BancBox. You can use a BancBox issued ID, your own reference identifier, or even date range on when the client was created or updated. Search by status is also available, so you can lookup all clients, for example, that have a status of "INACTIVE".
- (void)searchClients:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use getClient to get information on one specific client
- (void)getClient:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)getClientWithSubscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)getClientWithBancBoxId:(NSInteger)bancBoxId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Give instruction to Bancbox to cancel a client. This will change the status of the client to CANCELLED if all accounts under this client are closed.Otherwise API response will show details of accounts open under the client.
- (void)cancelClient:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)cancelClientWithSubscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)cancelClientWithBancBoxId:(NSInteger)bancBoxId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use the getSchedules API to get a list of transactions that are scheduled or in process. Create a list of transactions for a single client, a single account, according to type, or when it was modified or scheduled.
- (void)getSchedules:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// The cancelSchedules method allows you to cancel any scheduled transaction items that have not yet been executed. This method gives you the ability to cancel one or more items in a single request by passing in either the BancBox schedule id (issued when the scheduled item was created) or the reference identifier you assigned to the item when you scheduled it.
- (void)cancelSchedules:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// If your service or application requiries transactional or service fees from your users, you can schedule fee collection directly against your client's BancBox account using the collectFees method. Any fees collected will be sent to your subscriber fee and revenue account (F&R Account) determined when you first subscribe to BancBox.
- (void)collectFees:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)collectFees:(NSArray *)paymentItems bancBoxId:(NSInteger)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use the linkPayee API to link a new payee to a client.
- (void)linkPayee:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)linkPayee:(AFBBancBoxPayee *)payee bancBoxId:(NSInteger)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

//Use the search internal payees API to search for a specific payee associated to BancBox.
- (void)searchBancBoxPayees:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use the get client linked payees API to get a list of payess linked to a specified client.
- (void)getClientLinkedPayees:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use updateLinkedPayee to change the details of an already linked payee.
- (void)updateLinkedPayee:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)updateLinkedPayeeWithPayeeObject:(AFBBancBoxPayee *)payee success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use deleteLinkedPayee to delete a already linked payee
- (void)deleteLinkedPayee:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

/*
 Use the verifyClient API to perform KYC Validation on an existing client. It is important to note, the CIP status of the client must be "VERIFIED" before you can use OpenAccount to create an account under the client. verifyClient uses the information from the client to identify them uniquely. It relies on the following fields to be submitted correctly during the createClient call:
 
     1. First Name
     2. Last Name
     3. DOB
     4. SSN (NNN-NN-NNNN)
 
 If verifyClient results in a validation error, please make sure these four fields were submitted with the correct information. If incorrect information was passed in the original createClient call, please use the updateClient API to correct the information for a client before calling verifyClient API again. If your account is enabled for out of wallet questions (optional for some subscribers) and the client cannot be uniquely identified, the system will return challenge questions to try and confirm the user's identity.
 */
- (void)verifyClient:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)verifyClient:(AFBBancBoxClient *)client generateQuestions:(BOOL)generateQuestions success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use the submitVerificationAnswers API in conjunction with the verifyClient API to submit the answers for the challenge questions returned in the response for the verifyClient API in case the system was unable to uniquely identify the user based on the information available in the client record.
- (void)submitVerificationAnswers:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)submitVerificationAnswers:(NSArray *)answers idNumber:(NSString *)idNumber bancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// The collectFunds method allows you to bring funds into your client's BancBox account from an external source, another BancBox acount, or credit card . Possible methods include funding using ACH, Credit Card and internal Book transfers. You can schedule funds movement in the future by specifying a date, give multiple dates for recurring payments, or have BancBox execute immediately by not specifying a date.
- (void)collectFunds:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)collectFundsFromSource:(AFBBancBoxAccount *)source destination:(AFBBancBoxAccount *)destination method:(NSString *)method items:(NSArray *)items success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)collectCreditCardFunds:(AFBBancBoxExternalAccountCard *)cardAccount destination:(AFBBancBoxAccount *)destination merchantId:(NSString *)merchantId items:(NSArray *)items success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// This method allows a subscriber to open a BancBox account under a specified client.
- (void)openAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)openRoutableAccountForClient:(AFBBancBoxClient *)client title:(NSString *)title success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use the linkExternalAccount API to link an external bank, card, or paypal account to a client.
- (void)linkExternalAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)linkExternalAccount:(AFBBancBoxExternalAccount *)account accountReferenceId:(NSString *)accountReferenceId forClient:(AFBBancBoxClient *)client success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
// Use the updateAccount API to update the details of an already created BancBox account.
- (void)updateAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use the getClientAccounts method to get a list of all the BancBox accounts created under a specific client.
- (void)getClientAccounts:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)getClientAccountsForBancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use the getClientLinkedExternalAccounts method to get all the linked external accounts associated with a specified client.
- (void)getClientLinkedExternalAccounts:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)getClientLinkedExternalAccountsForBancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Get all transaction activity on a specified account.
- (void)getAccountActivity:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)getAccountActivityForAccount:(AFBBancBoxInternalAccount *)account fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use update linked external account API to change the details of a previously made linked external account.
- (void)updateLinkedExternalAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)updateLinkedExternalAccount:(AFBBancBoxExternalAccount *)account bancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// The closeAccount method allows you to close an account for a client. This method will not let you close an account that has a current balance. If you wish to close an account that has a current balance, you can sweep the account prior to invoking closeAccount using sendFunds, or you can specify a withdrawal method and destination in the request itself.
- (void)closeAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use the delete linked external account API to delete a linked external account.
- (void)deleteLinkedExternalAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)deleteLinkedExternalAccountForAccount:(AFBBancBoxExternalAccount *)account success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

//This method allows creating a Merchant ID for each merchant, which is used internally for all the Credit Card transactions done by the client. This Merchant ID is a unique numeric code that has been assigned to the Merchant for Credit Cards transaction processing. The API call creates two accounts - the Merchant Settlement account and the Merchant Reserve Account by default for the Merchant. These accounts are system purpose accounts used for future enhancements and chargeback handling scenarios. The API also creates a Legal entity ID with Litle.
- (void)createMerchant:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)createMerchantWithMerchantData:(AFBBancBoxMerchantData *)merchantData person:(AFBBancBoxPerson *)person success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use the sendFunds API to send funds out of a BancBox client's account.
- (void)sendFunds:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)sendFundsViaAchFromAccount:(AFBBancBoxInternalAccount *)sourceAccount toDestination:(AFBBancBoxExternalAccountBank *)destinationAccount items:(NSArray *)items success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)sendFundsViaAchFromAccount:(AFBBancBoxInternalAccount *)sourceAccount toLinkedExternalAccount:(AFBBancBoxLinkedExternalAccount *)linkedAccount items:(NSArray *)items success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

// Use to transfer funds from one BancBox account to another BancBox account.
- (void)transferFunds:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;
- (void)transferFunds:(NSArray *)paymentItems fromAccount:(AFBBancBoxInternalAccount *)fromAccount toAccount:(AFBBancBoxInternalAccount *)toAccount success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock;

@end
