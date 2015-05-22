//
//  DECategoryViewController.h
//  PinFever
//
//  Created by David Ehlen on 22.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DECategoryViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *categories;
@property (nonatomic,strong) IBOutlet UIButton *categoryButton1;
@property (nonatomic,strong) IBOutlet UIButton *categoryButton2;
@property (nonatomic,strong) IBOutlet UIButton *categoryButton3;

-(IBAction)startGame:(id)sender;

@end
