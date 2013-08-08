//
//  AFBBancBoxConnection.m
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFNetworking.h"
#import "AFBBancBoxConnection.h"

NSString * const BancBoxCollectPaymentMethodBook = @"book";
NSString * const BancBoxCollectPaymentMethodAch = @"ach";
NSString * const BancBoxCollectPaymentMethodCreditCard = @"creditcard";

NSString * const BancBoxSendFundsMethodAch = @"ach";

@implementation AFBBancBoxConnection

/*
 
 AFBBancBoxConnection
 
 The general structure here is a pair of methods per BancBox API call. The first method, public, takes a parameters dictionary
 and a pair of blocks to run on success or failure.
 
 The second method, private, defines any optional object that may be returned on success (the AFBBancBoxResponse object, which
 contains a dictionary representing the JSON response from the BancBox API server is always returned). The optional object, if
 any, is simply a more structured version of the response dictionary, or a collection created from same.
 
 In some cases there are additional convenience methods for making the request -- generally we have added these when the request
 object takes only a few parameters. As a rule, because these convenience methods make a dictionary from the objects passed to
 them, any blank objects should be empty strings.
 
 */

+ (AFBBancBoxConnection *)sharedConnection {
    static AFBBancBoxConnection *_sharedConnection = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConnection = [AFBBancBoxConnection new];
    });
    
    return _sharedConnection;
}

#pragma mark - createClient
- (void)createClient:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"createClient" params:params success:successBlock failure:failureBlock];
}

- (void)createClientWithObject:(AFBBancBoxClient *)client success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = [client dictionaryForCreate];
    [self executeRequestForPath:@"createClient" params:params success:successBlock failure:failureBlock];
}

- (id)createClientObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    if (bbResponse.response[@"clientId"]) {
        NSDictionary *resp = bbResponse.response;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"clientId"] = [NSMutableDictionary dictionary];
        if (resp[@"clientId"][@"bancBoxId"]) dict[@"clientId"][@"bancBoxId"] = resp[@"clientId"][@"bancBoxId"];
        if (resp[@"clientId"][@"subscriberReferenceId"]) dict[@"clientId"][@"subscriberReferenceId"] = resp[@"clientId"][@"subscriberReferenceId"];
        if (resp[@"clientStatus"]) dict[@"clientStatus"] = resp[@"clientStatus"];
        if (resp[@"cipStatus"]) dict[@"cipStatus"] = resp[@"cipStatus"];
        if (resp[@"username"]) dict[@"username"] = resp[@"username"];
        AFBBancBoxClient *client = [[AFBBancBoxClient alloc] initWithClientFromDictionary:dict];
        return client;
    }
    return nil;
}

#pragma mark - updateClient
- (void)updateClient:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"updateClient" params:params success:successBlock failure:failureBlock];
}

- (id)updateClientObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma mark - updateClientStatus
- (void)updateClientStatus:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"updateClientStatus" params:params success:successBlock failure:failureBlock];
}

- (void)updateClientStatusWithStatus:(NSString *)status bancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    if ([AFBBancBoxClient clientStatusIsValid:status]) {
        NSDictionary *params = @{
                                 @"clientId": @{@"bancBoxId": bancBoxId, @"subscriberReferenceId": subscriberReferenceId},
                                 @"clientStatus": status
                                 };
        [self updateClientStatus:params success:successBlock failure:failureBlock];
    } else {
        AFBBancBoxResponse *bbResponse = [[AFBBancBoxResponse alloc] initWithErrorCode:kBancBoxErrorCodeBadClientStatus errorMessage:kBancBoxErrorMessageBadClientStatus];
        failureBlock(bbResponse, bbResponse.errors);
    }
}

- (id)updateClientStatusObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma mark - linkFile
- (void)linkFile:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"linkFile" params:params success:successBlock failure:failureBlock];
}

- (id)linkFileObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma mark - searchClients
- (void)searchClients:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"searchClients" params:params success:successBlock failure:failureBlock];
}

- (id)searchClientsObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"clients"] objectClass:[AFBBancBoxClient class] selector:@selector(clientFromDictionary:)];
}

#pragma mark - getClient
- (void)getClient:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"getClient" params:params success:successBlock failure:failureBlock];
}

- (void)getClientWithSubscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = @{ @"clientId": @{@"subscriberReferenceId": subscriberReferenceId} };
    [self getClient:params success:successBlock failure:failureBlock];
}

- (void)getClientWithBancBoxId:(NSInteger)bancBoxId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = @{ @"clientId": @{@"bancBoxId": [NSNumber numberWithInteger:bancBoxId]} };
    [self getClient:params success:successBlock failure:failureBlock];
}

- (id)getClientObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    if (bbResponse.response[@"client"]) {
        AFBBancBoxClient *client = [[AFBBancBoxClient alloc] initWithClientFromDictionary:bbResponse.response[@"client"]];
        return client;
    }
    return nil;
}

#pragma mark - cancelClient
- (void)cancelClient:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"cancelClient" params:params success:successBlock failure:failureBlock];
}

- (void)cancelClientWithSubscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = @{ @"clientId": @{@"subscriberReferenceId": subscriberReferenceId} };
    [self cancelClient:params success:successBlock failure:failureBlock];
}

- (void)cancelClientWithBancBoxId:(NSInteger)bancBoxId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = @{ @"clientId": @{@"bancBoxId": [NSNumber numberWithInteger:bancBoxId]} };
    [self cancelClient:params success:successBlock failure:failureBlock];
}

- (id)cancelClientObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"openAccounts"] objectClass:[AFBBancBoxInternalAccount class] selector:@selector(accountFromDictionary:)];
}

#pragma mark - getSchedules
- (void)getSchedules:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"getSchedules" params:params success:successBlock failure:failureBlock];
}

- (id)getSchedulesObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"schedules"] objectClass:[AFBBancBoxSchedule class] selector:@selector(scheduleFromDictionary:)];
}

#pragma mark - getSchedules
- (void)cancelSchedules:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"cancelSchedules" params:params success:successBlock failure:failureBlock];
}

- (id)cancelSchedulesObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"schedules"] objectClass:[AFBBancBoxSchedule class] selector:@selector(scheduleFromDictionary:)];
}

#pragma mark - collectFees
- (void)collectFees:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"collectFees" params:params success:successBlock failure:failureBlock];
}

// This next convenience method takes an array of AFBBancBoxPaymentItems
- (void)collectFees:(NSArray *)paymentItems bancBoxId:(NSInteger)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSMutableArray *items = [NSMutableArray array];
    [paymentItems enumerateObjectsUsingBlock:^(AFBBancBoxPaymentItem *paymentItem, NSUInteger idx, BOOL *stop) {
        [items addObject:paymentItem.dictionary];
    }];
    
    NSDictionary *params = @{
                             @"account": @{@"bancBoxId": [NSNumber numberWithInteger:bancBoxId], @"subscriberReferenceId": subscriberReferenceId},
                             @"items": items
                             };
    [self collectFees:params success:successBlock failure:failureBlock];
}

- (id)collectFeesObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma mark - linkPayee
- (void)linkPayee:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"linkPayee" params:params success:successBlock failure:failureBlock];
}

- (void)linkPayee:(AFBBancBoxPayee *)payee bancBoxId:(NSInteger)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                        @"account": @{@"bancBoxId": [NSNumber numberWithInteger:bancBoxId], @"subscriberReferenceId": subscriberReferenceId}
                                   }];
    [params addEntriesFromDictionary:payee.dictionary];
    [self linkPayee:params success:successBlock failure:failureBlock];
}

- (id)linkPayeeObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma mark - searchBancBoxPayees

- (void)searchBancBoxPayees:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"searchBancBoxPayees" params:params success:successBlock failure:failureBlock];
}

- (id)searchBancBoxPayeesObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma mark - getClientLinkedPayees
- (void)getClientLinkedPayees:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"getClientLinkedPayees" params:params success:successBlock failure:failureBlock];
}

- (id)getClientLinkedPayeesObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"linkedPayees"] objectClass:[AFBBancBoxPayee class] selector:@selector(payeeFromDictionary:)];
}

#pragma mark - updateLinkedPayee
- (void)updateLinkedPayee:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"updateLinkedPayee" params:params success:successBlock failure:failureBlock];
}

- (void)updateLinkedPayeeWithPayeeObject:(AFBBancBoxPayee *)payee success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = payee.dictionary;
    [self linkPayee:params success:successBlock failure:failureBlock];
}

- (id)updateLinkedPayeeObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    AFBBancBoxPayee *payee = [AFBBancBoxPayee payeeFromDictionary:bbResponse.response];
    return payee;
}

#pragma mark - deleteLinkedPayee
- (void)deleteLinkedPayee:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"deleteLinkedPayee" params:params success:successBlock failure:failureBlock];
}

- (id)deleteLinkedPayeeObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma mark - verifyClient
- (void)verifyClient:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"verifyClient" params:params success:successBlock failure:failureBlock];
}

- (void)verifyClientWithBancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId generateQuestions:(BOOL)generateQuestions success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = @{ @"clientId": @{ @"bancBoxId": bancBoxId, @"subscriberReferenceId": subscriberReferenceId }, @"generateQuestions": [NSNumber numberWithBool:generateQuestions] };
    [self verifyClient:params success:successBlock failure:failureBlock];
}

- (id)verifyClientObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    NSMutableDictionary *response = [NSMutableDictionary dictionary];
    response[@"cipStatus"] = bbResponse.response[@"cipStatus"];
    response[@"questions"] = [self objectsFromResponseDictionaries:bbResponse.response[@"questions"] objectClass:[AFBBancBoxVerificationQuestion class] selector:@selector(questionFromDictionary:)];
    return response;
}

#pragma mark - submitVerificationAnswers
- (void)submitVerificationAnswers:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"submitVerificationAnswers" params:params success:successBlock failure:failureBlock];
}

- (void)submitVerificationAnswers:(NSArray *)answers idNumber:(NSString *)idNumber bancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSMutableArray *answerDicts = [NSMutableArray array];
    [answers enumerateObjectsUsingBlock:^(AFBBancBoxVerificationAnswer *answer, NSUInteger idx, BOOL *stop) {
        [answerDicts addObject:answer.dictionary];
    }];
    NSDictionary *params = @{ @"clientId": @{ @"bancBoxId": bancBoxId, @"subscriberReferenceId": subscriberReferenceId }, @"idNumber": idNumber, @"answers": answerDicts };
    [self submitVerificationAnswers:params success:successBlock failure:failureBlock];
}

- (id)submitVerificationAnswersObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma mark - collectFunds
- (void)collectFunds:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"collectFunds" params:params success:successBlock failure:failureBlock];
}

- (NSArray *)itemDictionariesFromItems:(NSArray *)items
{
    NSMutableArray *itemDictionaries = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(AFBBancBoxPaymentItem *item, NSUInteger idx, BOOL *stop) {
        [itemDictionaries addObject:item.dictionary];
    }];
    return itemDictionaries;
}

- (void)collectFundsFromSource:(AFBBancBoxAccount *)source destination:(AFBBancBoxInternalAccount *)destination method:(NSString *)method items:(NSArray *)items success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"method"] = method;
    
    if ([source isKindOfClass:[AFBBancBoxInternalAccount class]]) {
        params[@"source"] = @{ @"account": ((AFBBancBoxInternalAccount *)source).idDictionary };
    } else if ([source isKindOfClass:[AFBBancBoxLinkedExternalAccount class]]) {
        params[@"source"] = @{ @"linkedExternalAccount": ((AFBBancBoxLinkedExternalAccount *)source).dictionary };
    } else {
        params[@"source"] = @{ @"newExternalAccount": ((AFBBancBoxExternalAccount *)source).accountDetailsDictionary };
    }
    
    params[@"destinationAccount"] = destination.idDictionary;
    params[@"items"] = [self itemDictionariesFromItems:items];
    
    [self collectFunds:params success:successBlock failure:failureBlock];
}

- (void)collectCreditCardFunds:(AFBBancBoxExternalAccountCard *)cardAccount destination:(AFBBancBoxAccount *)destination merchantId:(NSString *)merchantId items:(NSArray *)items success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"creditcard";
    params[@"merchantId"] = merchantId;
    params[@"source"] = @{ @"newExternalAccount": cardAccount.accountDetailsDictionary };
    params[@"destinationAccount"] = destination.dictionary;
    params[@"items"] = [self itemDictionariesFromItems:items];
    
    [self collectFunds:params success:successBlock failure:failureBlock];
}

- (id)collectFundsObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"itemStatuses"] objectClass:[AFBBancBoxPaymentItemStatus class] selector:@selector(paymentItemStatusFromDictionary:)];
}

#pragma mark - openAccount
- (void)openAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSMutableDictionary *mParams = [params mutableCopy];
    if (params[@"title"]) {
        NSMutableString *original = [params[@"title"] mutableCopy];
        [original replaceOccurrencesOfString:@"'" withString:@"" options:0 range:NSMakeRange(0, original.length)];
        if (original.length > 45) [original deleteCharactersInRange:NSMakeRange(45, original.length - 45)];
        mParams[@"title"] = original;
    }
    [self executeRequestForPath:@"openAccount" params:mParams success:successBlock failure:failureBlock];
}

- (void)openRoutableAccountForClient:(AFBBancBoxClient *)client title:(NSString *)title success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:client.clientIdDictionary];
    params[@"routable"] = @{ @"credits": @"YES", @"debits": @"YES" };
    params[@"title"] = title;
    
    [self openAccount:params success:successBlock failure:failureBlock];
}

- (id)openAccountObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    AFBBancBoxInternalAccount *account = [[AFBBancBoxInternalAccount alloc] initWithAccountFromDictionary:bbResponse.response[@"account"]];
    return account;
}

#pragma mark - linkExternalAccount
- (void)linkExternalAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"linkExternalAccount" params:params success:successBlock failure:failureBlock];
}

- (void)linkExternalAccount:(AFBBancBoxExternalAccount *)account accountReferenceId:(NSString *)accountReferenceId bancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = @{ @"clientId": @{ @"bancBoxId": bancBoxId, @"subscriberReferenceId": subscriberReferenceId }, @"referenceId": accountReferenceId, @"account": [account accountDetailsDictionary] };
    [self linkExternalAccount:params success:successBlock failure:failureBlock];
}

- (id)linkExternalAccountObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    AFBBancBoxLinkedExternalAccount *linkedAccount = [[AFBBancBoxLinkedExternalAccount alloc] initWithAccountFromDictionary:bbResponse.response[@"id"]];
    return linkedAccount;
}

#pragma mark - updateAccount
- (void)updateAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"updateAccount" params:params success:successBlock failure:failureBlock];
}

- (id)updateAccountObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma mark - getClientAccounts
- (void)getClientAccounts:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"getClientAccounts" params:params success:successBlock failure:failureBlock];
}

- (void)getClientAccountsForBancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = @{ @"clientId": @{ @"bancBoxId": bancBoxId, @"subscriberReferenceId": subscriberReferenceId } };
    [self getClientAccounts:params success:successBlock failure:failureBlock];
}

- (id)getClientAccountsObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"accounts"] objectClass:[AFBBancBoxInternalAccount class] selector:@selector(accountFromDictionary:)];
}

#pragma  mark - getClientLinkedExternalAccounts
- (void)getClientLinkedExternalAccounts:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"getClientLinkedExternalAccounts" params:params success:successBlock failure:failureBlock];
}

- (void)getClientLinkedExternalAccountsForBancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = @{ @"clientId": @{ @"bancBoxId": bancBoxId, @"subscriberReferenceId": subscriberReferenceId } };
    [self getClientLinkedExternalAccounts:params success:successBlock failure:failureBlock];
}

- (id)getClientLinkedExternalAccountsObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"linkedExternalAccounts"] objectClass:[AFBBancBoxExternalAccount class] selector:@selector(externalAccountFromDictionary:)];
}

#pragma  mark - getAccountActivity
- (void)getAccountActivity:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"getAccountActivity" params:params success:successBlock failure:failureBlock];
}

- (void)getAccountActivityForAccount:(AFBBancBoxInternalAccount *)account fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDateFormatter *df = [AFBBancBoxAccountActivity activityDateFormatter];
    NSDictionary *params = @{
                             @"accountId": [account idDictionary],
                             @"fromDate": [df stringFromDate:fromDate],
                             @"toDate": [df stringFromDate:toDate]
                             };
    [self getAccountActivity:params success:successBlock failure:failureBlock];
}

- (id)getAccountActivityObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"activities"] objectClass:[AFBBancBoxAccountActivity class] selector:@selector(activityFromDictionary:)];
}

#pragma  mark - updateLinkedExternalAccount
- (void)updateLinkedExternalAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"updateLinkedExternalAccount" params:params success:successBlock failure:failureBlock];
}

- (void)updateLinkedExternalAccount:(AFBBancBoxExternalAccount *)account bancBoxId:(NSString *)bancBoxId subscriberReferenceId:(NSString *)subscriberReferenceId success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = @{ @"linkedExternalAccountId": @{ @"bancBoxId": bancBoxId, @"subscriberReferenceId": subscriberReferenceId }, @"account": [account accountDetailsDictionary] };
    [self updateLinkedExternalAccount:params success:successBlock failure:failureBlock];
}

- (id)updateLinkedExternalAccountObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma  mark - closeAccount
- (void)closeAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"closeAccount" params:params success:successBlock failure:failureBlock];
}

- (id)closeAccountObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma  mark - deleteLinkedExternalAccount
- (void)deleteLinkedExternalAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"deleteLinkedExternalAccount" params:params success:successBlock failure:failureBlock];
}

- (void)deleteLinkedExternalAccountForAccount:(AFBBancBoxExternalAccount *)account success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *params = @{ @"linkedExternalAccountId": @{ @"bancBoxId": [NSNumber numberWithLongLong:account.bancBoxId], @"subscriberReferenceId": account.subscriberReferenceId } };
    [self deleteLinkedExternalAccount:params success:successBlock failure:failureBlock];
}

- (id)deleteLinkedExternalAccountObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"activities"] objectClass:[AFBBancBoxAccountActivity class] selector:@selector(activityFromDictionary:)];
}

#pragma mark - createMerchant
- (void)createMerchant:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"createMerchant" params:params success:successBlock failure:failureBlock];
}

- (void)createMerchantWithMerchantData:(AFBBancBoxMerchantData *)merchantData person:(AFBBancBoxPerson *)person success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:person.dictionary];
    [params addEntriesFromDictionary:merchantData.detailsDictionary];
    [self createMerchant:params success:successBlock failure:failureBlock];
}

- (id)createMerchantObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    NSString *merchantId = bbResponse.response[@"merchantId"];
    return merchantId;
}

#pragma  mark - sendFunds
- (void)sendFunds:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"sendFunds" params:params success:successBlock failure:failureBlock];
}

- (void)sendFundsViaAchFromAccount:(AFBBancBoxInternalAccount *)sourceAccount toDestination:(AFBBancBoxExternalAccountBank *)destinationAccount items:(NSArray *)items success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sourceAccount"] = sourceAccount.idDictionary;
    params[@"method"] = BancBoxSendFundsMethodAch;
    params[@"destinationAccount"] = @{ @"newExternalAccount": destinationAccount.accountDetailsDictionary };
    params[@"items"] = [self itemDictionariesFromItems:items];
    
    [self sendFunds:params success:successBlock failure:failureBlock];
}

- (void)sendFundsViaAchFromAccount:(AFBBancBoxInternalAccount *)sourceAccount toLinkedExternalAccount:(AFBBancBoxLinkedExternalAccount *)linkedAccount items:(NSArray *)items success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sourceAccount"] = sourceAccount.idDictionary;
    params[@"method"] = BancBoxSendFundsMethodAch;
    params[@"destinationAccount"] = @{ @"linkedExternalAccountId": linkedAccount.dictionary };
    params[@"items"] = [self itemDictionariesFromItems:items];
    
    [self sendFunds:params success:successBlock failure:failureBlock];
}

- (id)sendFundsObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"itemStatuses"] objectClass:[AFBBancBoxPaymentItemStatus class] selector:@selector(paymentItemStatusFromDictionary:)];
}

#pragma  mark - transferFunds
- (void)transferFunds:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"transferFunds" params:params success:successBlock failure:failureBlock];
}

- (void)transferFunds:(NSArray *)paymentItems fromAccount:(AFBBancBoxInternalAccount *)fromAccount toAccount:(AFBBancBoxInternalAccount *)toAccount success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sourceAccount"] = fromAccount.idDictionary;
    params[@"destinationAccount"] = toAccount.idDictionary;
    
    NSMutableArray *paymentItemDicts = [NSMutableArray array];
    [paymentItems enumerateObjectsUsingBlock:^(AFBBancBoxPaymentItem *item, NSUInteger idx, BOOL *stop) {
        [paymentItemDicts addObject:item.dictionary];
    }];
}

- (id)transferFundsObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"itemStatuses"] objectClass:[AFBBancBoxPaymentItemStatus class] selector:@selector(paymentItemStatusFromDictionary:)];
}

#
#
#pragma mark - Common methods

- (void)executeRequestForPath:(NSString *)path params:(NSDictionary *)params  success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    NSDictionary *authenticatedParams = [self authenticatedParams:params];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BANCBOX_SELECTED_SERVER_BASE_URL]];
    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:path parameters:authenticatedParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[self requestAndResponseLoggerForOperation:operation];
        NSError *error;
        NSDictionary *responseDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        AFBBancBoxResponse *bbResponse = [[AFBBancBoxResponse alloc] initWithResponse:responseDictionary];
        if (bbResponse.status == BancBoxResponseStatusPass) {
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@ObjectFromResponse:", path]);
            id obj = [self performSelector:selector withObject:bbResponse];
            successBlock(bbResponse, obj);
        } else {
            NSLog(@"Error returned by BancBox for '%@': %@. Params: %@", path, bbResponse, authenticatedParams);
            failureBlock(bbResponse, bbResponse.errors);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[self requestAndResponseLoggerForOperation:operation];
        NSLog(@"Error while requesting BancBox '%@': %@", path, error.localizedDescription);
    }];
}

- (NSDictionary *)authenticatedParams:(NSDictionary *)params
{
    NSMutableDictionary *authenticatedParams = [NSMutableDictionary dictionaryWithDictionary:@{
                                                    @"subscriberId": [NSNumber numberWithInt:BANCBOX_SUBSCRIBER_ID],
                                                    @"authentication": @{
                                                        @"apiKey": BANCBOX_API_KEY, @"secret": BANCBOX_API_SECRET
                                                    }
                                                }];
    [authenticatedParams addEntriesFromDictionary:params];
    return authenticatedParams;
}

- (NSArray *)objectsFromResponseDictionaries:(id)responseArray objectClass:(Class)objectClass selector:(SEL)selector
{
    NSMutableArray *objects = [NSMutableArray array];
    
    if ([responseArray isKindOfClass:[NSArray class]]) {
        [responseArray enumerateObjectsUsingBlock:^(NSDictionary *responseObject, NSUInteger idx, BOOL *stop) {
            id object = [objectClass performSelector:selector withObject:responseObject];
            [objects addObject:object];
        }];
    }
    
    return objects;
}

- (void)requestAndResponseLoggerForOperation:(AFHTTPRequestOperation *)operation
{
    NSLog(@"%@ request to URL: %@", operation.request.HTTPMethod, operation.request.URL);
    NSLog(@"Request body: %@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    NSLog(@"Response body: %@", operation.responseString);
}


@end
