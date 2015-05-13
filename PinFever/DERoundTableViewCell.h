//
//  DERoundTableViewCell.h
//  PinFever
//
//  Created by David Ehlen on 06.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKSTableView/SKSTableViewCell.h>

@interface DERoundTableViewCell : SKSTableViewCell

@property(nonatomic,weak) IBOutlet UILabel *titleLabel;
@property(nonatomic,weak) IBOutlet UILabel *scoreLabel;

@end
