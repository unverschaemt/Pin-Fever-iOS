//
//  DEFriendsViewController.h
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;

-(IBAction)addFriend:(id)sender;

@end
