//
//  DEAPIWrapper.m
//  PinFever
//
//  Created by David Ehlen on 28.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEAPIWrapper.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "DEHomeViewController.h"
#import <STHTTPRequest/STHTTPRequest.h>

@implementation DEAPIWrapper

-(id)init {
    self = [super init];
    if(self) {
        keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kKeychainKey accessGroup:nil];

    }
    return self;
}

-(void)request:(NSURL *)url httpMethod:(NSString *)httpMethod optionalJSONData:(NSData *)jsonData optionalContentType:(NSString *)contentType completed:(RequestCompletionBlock)completionBlock failed:(RequestFailedBlock)failureBlock {
    
    STHTTPRequest *r = [STHTTPRequest requestWithURL:url];
    [r setHTTPMethod:httpMethod];
    if([httpMethod isEqualToString:@"POST"] && jsonData != nil) {
        r.rawPOSTData = jsonData;
    }
    if(contentType != nil) {
        [r setHeaderWithName:@"content-type" value:contentType];
    }
    [r setHeaderWithName:kAPIAuthToken value:[keychainWrapper objectForKey:(__bridge id)(kSecAttrAccount)]];
    __weak typeof(r) wr = r;
    
    r.completionBlock = ^(NSDictionary *headers, NSString *body) {
        completionBlock(headers, body);
    };
    
    r.errorBlock = ^(NSError *error) {
        if(![self checkUnauthorized:wr.responseStatus]) {
            failureBlock(error);
        }
    };
    [r startAsynchronous];

}

-(BOOL)checkUnauthorized:(NSInteger)responseStatus {
    if(responseStatus == 401) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"unauthorizedError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [keychainWrapper resetKeychainItem];
        LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]]instantiateInitialViewController];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app setRootViewController:loginViewController];
        return YES;
    }
    return NO;
}

-(void)tryLogin:(NSString *)email andPassword:(NSString * )password completed:(RequestCompletionBlock)completionBlock failed:(RequestFailedBlock)failureBlock {
    NSURL *loginURL = [NSURL URLWithString:kAPILoginEndpoint];

    STHTTPRequest *r = [STHTTPRequest requestWithURL:loginURL];
    [r setHTTPMethod:@"POST"];
    
    NSDictionary *postDict = @{ @"email":email, @"password":password };
    
    NSError *err = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&err];
    if(err) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Error" message:NSLocalizedString(@"loginGenericMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [r setHeaderWithName:@"content-type" value:@"application/json"];
    r.rawPOSTData = postData;
    
    r.completionBlock = ^(NSDictionary *headers, NSString *body) {
        
        NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
        if(response[kErrorKey] == (id)[NSNull null]) {
            NSString *token = [response[kDataKey] objectForKey:kTokenKey];
            if(token.length != 0) {
                [self saveAuthToken:token];
                [self pushToHomeController];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Error" message:NSLocalizedString(@"loginGenericMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Error" message:NSLocalizedString(@"loginCredentialsMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }

        completionBlock(headers,body);
    };
    
    r.errorBlock = ^(NSError *error) {
        failureBlock(error);
    };
    [r startAsynchronous];

}

-(void)tryRegister:(NSString *)email andPassword:(NSString *)password andUsername:(NSString *)username completed:(RequestCompletionBlock)completionBlock failed:(RequestFailedBlock)failureBlock {
    NSURL *registerURL = [NSURL URLWithString:kAPIRegisterEndpoint];
    STHTTPRequest *r = [STHTTPRequest requestWithURL:registerURL];
    [r setHTTPMethod:@"POST"];
    
    NSDictionary *postDict = @{ @"email":email, @"password":password, @"displayName":username};
    
    NSError *err = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&err];
    if(err) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"registerError", nil) message:NSLocalizedString(@"registerGenericMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [r setHeaderWithName:@"content-type" value:@"application/json"];
    r.rawPOSTData = postData;
    
    r.completionBlock = ^(NSDictionary *headers, NSString *body) {

        NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
        if(response[kErrorKey] == (id)[NSNull null]) {
            NSString *token = [response[kDataKey] objectForKey:kTokenKey];
            if(token.length != 0) {
                [self saveAuthToken:token];
                [self pushToHomeController];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"registerError", nil)message:NSLocalizedString(@"registerGenericMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"registerError", nil) message:NSLocalizedString(@"registerGenericMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }

        
        completionBlock(headers,body);
    };
    
    r.errorBlock = ^(NSError *error) {
        failureBlock(error);
    };
    
    [r startAsynchronous];
}

-(void)request:(NSURL *)url httpMethod:(NSString *)httpMethod optionalFormData:(NSData *)formData completed:(RequestCompletionBlock)completionBlock failed:(RequestFailedBlock)failureBlock {
    NSLog(@"%@",[url description]);
    STHTTPRequest *r = [STHTTPRequest requestWithURL:url];
    [r setHTTPMethod:httpMethod];
    [r setHeaderWithName:kAPIAuthToken value:[keychainWrapper objectForKey:(__bridge id)(kSecAttrAccount)]];
    [r addDataToUpload:formData parameterName:@"Datei" mimeType:@"image/jpeg" fileName:@"img.jpeg"];

    __weak typeof(r) wr = r;
    
    r.completionBlock = ^(NSDictionary *headers, NSString *body) {
        completionBlock(headers, body);
    };
    
    r.errorBlock = ^(NSError *error) {
        if(![self checkUnauthorized:wr.responseStatus]) {
            failureBlock(error);
        }
    };
    [r startAsynchronous];
    
}


#pragma mark -
#pragma mark Helper methods

-(void)saveAuthToken:(NSString *)token {
    [keychainWrapper setObject:token forKey:(__bridge id)(kSecAttrAccount)];
}

-(void)pushToHomeController {
    DEHomeViewController *homeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateInitialViewController];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = homeViewController;
}

-(void)checkLogin {
    NSString *token = [keychainWrapper objectForKey:(__bridge id)(kSecAttrAccount)];
    if(token.length != 0) {
        [self pushToHomeController];
    }
}

@end
