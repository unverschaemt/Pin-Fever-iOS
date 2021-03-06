//
//  DEAddFriendViewController.h
//  PinFever
//
//  Created by David Ehlen on 21.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEPlayer.h"
#import "DEAPIWrapper.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@protocol DEAddFriendDelegate <NSObject>

@required
- (void)addedFriend:(DEPlayer *)player;
@end

@interface DEAddFriendViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    DEAPIWrapper *apiWrapper;
}

@property(nonatomic,weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, weak) IBOutlet UISearchBar *searchBar;

@property(nonatomic, assign) id <DEAddFriendDelegate> delegate;
@property(nonatomic, strong) NSMutableArray *searchResults;

@end
