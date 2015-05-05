//
//  ActiveGamesTableViewCell.m
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "ActiveGamesTableViewCell.h"

@implementation ActiveGamesTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.playerImageView.clipsToBounds = YES;
    self.playerImageView.layer.cornerRadius = self.playerImageView.frame.size.width/2;
    self.playerImageView.layer.borderWidth = 1.0;
    self.playerImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
