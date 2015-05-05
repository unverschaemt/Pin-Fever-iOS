//
//  ViewController.h
//  PinFever
//
//  Created by David Ehlen on 04.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <google-plus-ios-sdk/GPPSignInButton.h>

@class GPPSignInButton;
@interface LoginViewController : UIViewController <GPGStatusDelegate> {
    IBOutlet UIImageView *logoImageView;
    GPPSignInButton *loginButton;
    
    MBProgressHUD *hud;
}

-(IBAction)signIn:(id)sender;

@property (nonatomic,assign) BOOL silentLogin;

@end

