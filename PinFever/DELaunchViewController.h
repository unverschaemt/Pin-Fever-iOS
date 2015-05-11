//
//  DELaunchViewController.h
//  PinFever
//
//  Created by David Ehlen on 09.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"

@interface DELaunchViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,TLTagsControlDelegate>

@property(nonatomic,weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet TLTagsControl *tagControl;

@end
