//
//  DERoundDetailViewController.h
//  PinFever
//
//  Created by David Ehlen on 06.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKSTableView/SKSTableView.h>

@interface DERoundDetailViewController : UIViewController <SKSTableViewDelegate>

@property (nonatomic, weak) IBOutlet SKSTableView *tableView;
@property (nonatomic, strong) NSMutableArray *rounds;

@end
