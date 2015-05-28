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

@interface DELaunchViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,TLTagsControlDelegate> {
    DEFileManager *fileManager;
}

@property(nonatomic,weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet TLTagsControl *tagControl;
@property (nonatomic, strong) NSMutableArray *friendsAndRecent;
@end
