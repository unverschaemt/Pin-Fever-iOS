//
//  RegisterViewController.h
//  PinFever
//
//  Created by David Ehlen on 11.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEAPIWrapper.h"
#import "DERoundImageView.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate> {
    DEAPIWrapper *apiWrapper;
}
-(IBAction)signUp:(id)sender;

@property (nonatomic, weak) IBOutlet DERoundImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UITextField *rePasswordField;
@property (nonatomic, weak) IBOutlet UIButton *signupButton;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingView;

@end
