//
//  DEHomeViewController.h
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEHomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *activeGames;
@property (nonatomic,strong) NSMutableArray *waitingGames;

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@end
