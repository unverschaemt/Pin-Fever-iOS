//
//  RegisterViewController.h
//  PinFever
//
//  Created by David Ehlen on 11.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView *logoImageView;
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *rePasswordField;
    IBOutlet UIButton *signupButton;
}

-(IBAction)signUp:(id)sender;
@end
