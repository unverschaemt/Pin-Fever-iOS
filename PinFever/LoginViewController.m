//
//  ViewController.m
//  PinFever
//
//  Created by David Ehlen on 04.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "LoginViewController.h"
#import "DEHomeViewController.h"
#import "AppDelegate.h"
#import <STHTTPRequest/STHTTPRequest.h>
#import "KeychainItemWrapper.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.width/2;
    self.logoImageView.layer.borderWidth = 2.0;
    self.logoImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;
    
    [self setupTextFields];
    
    [self checkAlreadyLoggedIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Orientation

-(NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown);
}

-(BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark -
#pragma mark Methods

-(void)setupTextFields {
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    [self.emailField becomeFirstResponder];
}

-(void)saveAuthToken:(NSString *)token {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kKeychainKey accessGroup:nil];
    [keychainItem setObject:token forKey:(__bridge id)(kSecValueData)];
    
}

-(void)pushToHomeController {
    DEHomeViewController *homeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateInitialViewController];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = homeViewController;
}


-(void)checkAlreadyLoggedIn {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kKeychainKey accessGroup:nil];

    NSString *token = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    if(token.length != 0) {
        [self pushToHomeController];
    }
}

-(void)showLoading:(BOOL)showIndicators {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:showIndicators];
    if(showIndicators) {
        [self.loadingView startAnimating];
    }
    else {
        [self.loadingView stopAnimating];
    }
}

-(void)tryLogin:(NSString *)body {
    [self showLoading:NO];
    
    NSLog(@"Body: %@",body);
    NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
    if(response[kErrorKey] == (id)[NSNull null]) {
        //Login Success
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

}

-(void)loginFailed:(NSError *)error {
    [self showLoading:NO];

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Error" message:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"loginFailedWith", nil),[error localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -
#pragma mark IBAction's
-(IBAction)login:(id)sender {
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    if(email.length <= 0 || password.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Error" message:NSLocalizedString(@"loginErrorMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSURL *loginURL = [NSURL URLWithString:kLoginEndpoint];
    NSLog(@"%@",loginURL.description);
    STHTTPRequest *r = [STHTTPRequest requestWithURL:loginURL];

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
        [self tryLogin:body];
    };
    
    r.errorBlock = ^(NSError *error) {
        [self loginFailed:error];
    };
    [self showLoading:YES];
    [r startAsynchronous];
}


-(IBAction)forgotPassword:(id)sender {
    
}

#pragma mark -
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
    return NO;
}


@end
