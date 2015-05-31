//
//  DELaunchViewController.h
//  PinFever
//
//  Created by David Ehlen on 09.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"
#import "DEFileManager.h"
#import "DEAPIWrapper.h"
#import "DEGame.h"
#import "DEPlayer.h"

@interface DELaunchViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,TLTagsControlDelegate> {
    DEFileManager *fileManager;
    NSIndexPath *selectedIndexPath;
    DEAPIWrapper *apiWrapper;
}

@property(nonatomic,weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet TLTagsControl *tagControl;
@property (nonatomic, strong) NSMutableArray *friendsAndRecent;
@property (nonatomic, strong) DEGame *game;
@property (nonatomic, strong) DEPlayer *me;
@end
