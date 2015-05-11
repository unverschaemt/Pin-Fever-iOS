//
//  PlayerCollectionViewCell.m
//  PinFever
//
//  Created by David Ehlen on 09.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "PlayerCollectionViewCell.h"

@implementation PlayerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.playerImageView.clipsToBounds = YES;
    self.playerImageView.layer.cornerRadius = self.playerImageView.frame.size.width/2;
    self.playerImageView.layer.borderWidth = 1.0;
    self.playerImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;
    /*
    UIImage *overlayImage = [UIImage imageNamed:@"selectedPlayerCell"];
    overlayImageView = [[UIImageView alloc] initWithImage:overlayImage];
    overlayImageView.hidden = YES;
    overlayImageView.contentMode = UIViewContentModeScaleAspectFill;
    overlayImageView.frame = CGRectMake(0, 0, self.playerImageView.frame.size.width, self.playerImageView.frame.size.height);
    overlayImageView.clipsToBounds = YES;
    overlayImageView.layer.cornerRadius = overlayImageView.frame.size.width/2;
    overlayImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;

    [self.playerImageView addSubview:overlayImageView];
     */
}
/*
-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    overlayImageView.hidden = !overlayImageView.hidden;
    
    
    if(!selected) {
        overlayImageView.hidden = YES;
    }
}
 */

@end
