//
//  DEFriendsViewController.h
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEAddFriendViewController.h"
#import "SQLiteManager.h"

@interface DEFriendsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource,DEAddFriendDelegate> {
    SQLiteManager *sqliteManager;
}

@property(nonatomic,weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *friends;

-(IBAction)addFriend:(id)sender;

@end
