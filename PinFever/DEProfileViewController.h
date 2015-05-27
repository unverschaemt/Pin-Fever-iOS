//
//  DEProfileViewController.h
//  PinFever
//
//  Created by David Ehlen on 18.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) IBOutlet UITableView *tableView;

@end
