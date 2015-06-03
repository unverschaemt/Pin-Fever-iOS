//
//  DECategoryViewController.h
//  PinFever
//
//  Created by David Ehlen on 22.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEGame.h"
#import "DEAPIWrapper.h"

@interface DECategoryViewController : UIViewController {
    DEAPIWrapper *apiWrapper;
}

@property (nonatomic,strong) IBOutlet UIButton *categoryButton1;
@property (nonatomic,strong) IBOutlet UIButton *categoryButton2;
@property (nonatomic,strong) IBOutlet UIButton *categoryButton3;

@property (nonatomic, strong) DEGame *game;
@property (nonatomic, strong) NSMutableArray *categories;
-(IBAction)startGame:(id)sender;

@end
