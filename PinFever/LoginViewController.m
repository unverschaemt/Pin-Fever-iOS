//
//  ViewController.m
//  PinFever
//
//  Created by David Ehlen on 04.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "LoginViewController.h"
#import "DEHomeViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    logoImageView.clipsToBounds = YES;
    logoImageView.layer.cornerRadius = logoImageView.frame.size.width/2;
    logoImageView.layer.borderWidth = 2.0;
    logoImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;
    
    [self setupSignInButton];

    [GPGManager sharedInstance].statusDelegate = self;
    self.silentLogin = [[GPGManager sharedInstance] signInWithClientID:CLIENT_ID silently:YES];

    [self refreshInterfaceBasedOnSignIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupSignInButton {
    loginButton = [[GPPSignInButton alloc] init];
    [loginButton setStyle:kGPPSignInButtonStyleWide];
    loginButton.enabled = NO;
    [loginButton addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];

    // This is just the autolayout code to center our button.
    loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Center the button vertically.
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:loginButton
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeCenterY
                                      multiplier:1.0f
                                      constant:0.0f];
    [self.view addConstraint:constraint];
    
    // Center the button horizontally.
    constraint = [NSLayoutConstraint
                  constraintWithItem:loginButton
                  attribute:NSLayoutAttributeCenterX
                  relatedBy:NSLayoutRelationEqual
                  toItem:self.view
                  attribute:NSLayoutAttributeCenterX
                  multiplier:1.0f
                  constant:0.0f];
    [self.view addConstraint:constraint];
}

-(void)signIn:(id)sender {
    [[GPGManager sharedInstance] signInWithClientID:CLIENT_ID silently:NO];
    loginButton.enabled = NO;
}

- (void)didFinishGamesSignInWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received an error while signing in %@", [error localizedDescription]);
        loginButton.enabled = YES;
    } else {
        loginButton.enabled = NO;
        NSLog(@"Signed in!");
    }
    [self refreshInterfaceBasedOnSignIn];
}

-(void)didFinishGoogleAuthWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received an error while signing in %@", [error localizedDescription]);
        loginButton.enabled = YES;
    }
}

- (void)refreshInterfaceBasedOnSignIn {
    loginButton.enabled = !self.silentLogin;
    
    BOOL signedInToGameServices = [GPGManager sharedInstance].isSignedIn;
    if(signedInToGameServices) {
        DEHomeViewController *homeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateInitialViewController];
        homeViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        homeViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:homeViewController animated:YES completion:nil];
    }
}

@end
