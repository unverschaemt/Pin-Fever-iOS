//
//  ViewController.m
//  PinFever
//
//  Created by David Ehlen on 04.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "LoginViewController.h"

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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)signIn:(id)sender {
    
}

@end
