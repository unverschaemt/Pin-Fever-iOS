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
#import "AppDelegate.h"

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
    r.POSTDictionary = @{ @"email":email, @"password":password};
    r.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSLog(@"Body: %@",body);
        NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];

        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
        if([response objectForKey:kErrorKey] == (id)[NSNull null]) {
            //Login Success
            NSString *token = [[response objectForKey:kDataKey]objectForKey:kTokenKey];
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

    };
    
    r.errorBlock = ^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Error" message:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"loginFailedWith", nil),[error localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    };
    
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
