//
//  AFBBancBoxConnection.m
//  Breeze
//
//  Created by Adam Block on 4/26/13.
//  Copyright (c) 2013 Adam Block. All rights reserved.
//

#import "AFNetworking.h"
#import "AFBBancBoxConnection.h"
#import "AFBBancBoxResponse.h"
#import "AFBBancBoxClient.h"
#import "AFBBancBoxSchedule.h"
#import "AFBBancBoxPaymentItem.h"
#import "AFBBancBoxPaymentItemStatus.h"
#import "AFBBancBoxPayee.h"
#import "AFBBancBoxPayeeACH.h"
#import "AFBBancBoxPayeeBancBox.h"
#import "AFBBancBoxPayeeCheck.h"
#import "AFBBancBoxPayeePayPal.h"
#import "AFBBancBoxVerificationQuestion.h"
#import "AFBBancBoxVerificationAnswer.h"
#import "AFBBancBoxAccount.h"
#import "AFBBancBoxInternalAccount.h"
#import "AFBBancBoxLinkedExternalAccount.h"
#import "AFBBancBoxExternalAccountCard.h"
#import "AFBBancBoxAccountActivity.h"
#import "AFBBancBoxPrivateAuthenticationItems.h"

// Internal error responses
static NSString * const kBancBoxErrorCodeBadClientStatus = @"AFB-BB-001";
static NSString * const kBancBoxErrorMessageBadClientStatus = @"Client status is not one of: 'ACTIVE', 'INACTIVE', 'SUSPENDED','DELETED'";

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

#pragma mark - createClient
- (void)createClient:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"createClient" params:params success:successBlock failure:failureBlock];
}

- (id)createClientObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
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
    return [self objectsFromResponseDictionaries:bbResponse.response[@"clients"] objectClass:[AFBBancBoxClient class] selector:@selector(initWithClientFromDictionary:)];
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

- (id)cancelClientObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
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

#pragma mark - getSchedules
- (void)getSchedules:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"getSchedules" params:params success:successBlock failure:failureBlock];
}

- (id)getSchedulesObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"schedules"] objectClass:[AFBBancBoxSchedule class] selector:@selector(initWithScheduleFromDictionary:)];
}

#pragma mark - getSchedules
- (void)cancelSchedules:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"cancelSchedules" params:params success:successBlock failure:failureBlock];
}

- (id)cancelSchedulesObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"schedules"] objectClass:[AFBBancBoxSchedule class] selector:@selector(initWithScheduleFromDictionary:)];
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
    return [self objectsFromResponseDictionaries:bbResponse.response[@"linkedPayees"] objectClass:[AFBBancBoxPayee class] selector:@selector(initFactoryWithPayeeFromDictionary:)];
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
    AFBBancBoxPayee *payee = [[AFBBancBoxPayee alloc] initFactoryWithPayeeFromDictionary:bbResponse.response];
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
    return [self objectsFromResponseDictionaries:bbResponse.response[@"questions"] objectClass:[AFBBancBoxVerificationQuestion class] selector:@selector(initWithQuestionFromDictionary:)];
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

- (void)collectFundsFrom:(id)source method:(NSString *)method items:(NSArray *)items success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
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
    
    NSMutableArray *itemsDict = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(AFBBancBoxPaymentItem *item, NSUInteger idx, BOOL *stop) {
        [itemsDict addObject:item.dictionary];
    }];
    params[@"items"] = itemsDict;
    
    [self collectFunds:params success:successBlock failure:failureBlock];
}

- (id)collectFundsObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"itemStatuses"] objectClass:[AFBBancBoxPaymentItemStatus class] selector:@selector(initWithPaymentItemStatusFromDictionary:)];
}

#pragma mark - openAccount
- (void)openAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"openAccount" params:params success:successBlock failure:failureBlock];
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
    return [NSNull null];
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
    return [self objectsFromResponseDictionaries:bbResponse.response[@"accounts"] objectClass:[AFBBancBoxInternalAccount class] selector:@selector(initWithAccountFromDictionary:)];
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
    return [self objectsFromResponseDictionaries:bbResponse.response[@"linkedExternalAccounts"] objectClass:[AFBBancBoxExternalAccount class] selector:@selector(initFactoryWithExternalAccountFromDictionary:)];
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
                             @"accountId": @{
                                     @"bancBoxId": [NSNumber numberWithInteger:account.bancBoxId], @"subscriberReferenceId": account.subscriberReferenceId
                                     },
                             @"fromDate": [df stringFromDate:fromDate],
                             @"toDate": [df stringFromDate:toDate]
                             };
    [self getAccountActivity:params success:successBlock failure:failureBlock];
}

- (id)getAccountActivityForAccountObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"activities"] objectClass:[AFBBancBoxAccountActivity class] selector:@selector(initWithActivityFromDictionary:)];
}

#pragma  mark - updateLinkedExternalAccount
- (void)updateLinkedExternalAccount:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"updateLinkedExternalAccount" params:params success:successBlock failure:failureBlock];
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

- (id)deleteLinkedExternalAccountObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [NSNull null];
}

#pragma  mark - sendFunds
// The REST API here is confusing, so no convenience methods for the moment
- (void)sendFunds:(NSDictionary *)params success:(BancBoxResponseBlock)successBlock failure:(BancBoxResponseBlock)failureBlock
{
    [self executeRequestForPath:@"sendFunds" params:params success:successBlock failure:failureBlock];
}

- (id)sendFundsObjectFromResponse:(AFBBancBoxResponse *)bbResponse
{
    return [self objectsFromResponseDictionaries:bbResponse.response[@"itemStatuses"] objectClass:[AFBBancBoxPaymentItemStatus class] selector:@selector(initWithPaymentItemStatusFromDictionary:)];
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
    return [self objectsFromResponseDictionaries:bbResponse.response[@"itemStatuses"] objectClass:[AFBBancBoxPaymentItemStatus class] selector:@selector(initWithPaymentItemStatusFromDictionary:)];
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
        NSError *error;
        NSDictionary *responseDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        AFBBancBoxResponse *bbResponse = [[AFBBancBoxResponse alloc] initWithResponse:responseDictionary];
        if (bbResponse.status == BancBoxResponseStatusPass) {
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@ObjectFromResponse:", path]);
            id obj = [self performSelector:selector withObject:bbResponse];
            successBlock(bbResponse, obj);
        } else {
            NSLog(@"Error returned by BancBox for '%@': %@", path, bbResponse);
            failureBlock(bbResponse, bbResponse.errors);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
            id object = [objectClass alloc];
            [object performSelector:selector withObject:responseObject];
            [objects addObject:object];
        }];
    }
    
    return objects;
}

@end
