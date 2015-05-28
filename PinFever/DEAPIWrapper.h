//
//  DEAPIWrapper.h
//  PinFever
//
//  Created by David Ehlen on 28.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@interface DEAPIWrapper : NSObject {
    KeychainItemWrapper *keychainWrapper;
}

typedef void (^RequestCompletionBlock)(NSDictionary *headers, NSString *body);
typedef void (^RequestFailedBlock)(NSError *);

-(void)request:(NSURL *)url httpMethod:(NSString *)httpMethod optionalJSONData:(NSData *)jsonData optionalContentType:(NSString *)contentType completed:(RequestCompletionBlock)completionBlock failed:(RequestFailedBlock)failureBlock;

-(void)tryLogin:(NSString *)email andPassword:(NSString * )password completed:(RequestCompletionBlock)completionBlock failed:(RequestFailedBlock)failureBlock;

-(void)tryRegister:(NSString *)email andPassword:(NSString *)password andUsername:(NSString *)username completed:(RequestCompletionBlock)completionBlock failed:(RequestFailedBlock)failureBlock;

-(void)checkLogin;
@end
