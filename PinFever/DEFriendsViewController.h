//
//  DEFriendsViewController.h
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEAddFriendViewController.h"
#import "DEAPIWrapper.h"
#import "DEAnimator.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "DEFileManager.h"

@interface DEFriendsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource,DEAddFriendDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource> {
    DEAPIWrapper *apiWrapper;
    DEAnimator *animator;
    DEFileManager *fileManager;
}

@property(nonatomic,weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic,assign) BOOL deleteModus;

-(IBAction)addFriend:(id)sender;

@end
