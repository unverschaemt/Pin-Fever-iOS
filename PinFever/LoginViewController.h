//
//  ViewController.h
//  PinFever
//
//  Created by David Ehlen on 04.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    IBOutlet UIImageView *logoImageView;
}

-(IBAction)login:(id)sender;
-(IBAction)signUp:(id)sender;
-(IBAction)forgotPassword:(id)sender;

@end

