//
//  DEFriendsViewController.m
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEFriendsViewController.h"
#import "DEAddFriendViewController.h"
#import "PlayerCollectionViewCell.h"
#import "DEPlayer.h"
#import "SQLiteManager.h"

@interface DEFriendsViewController ()

@end

@implementation DEFriendsViewController

#define kWiggleBounceY 2.0f
#define kWiggleBounceDuration 0.12
#define kWiggleBounceDurationVariance 0.025

#define kWiggleRotateAngle 0.08f
#define kWiggleRotateDuration 0.1
#define kWiggleRotateDurationVariance 0.025

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"friendsTitle", nil);
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(activateDeletionMode:)];
    longPress.minimumPressDuration = .5; //seconds
    [self.collectionView addGestureRecognizer:longPress];
    
    self.friends = [NSMutableArray new];
    sqliteManager = [self getSQLiteManager];
    [self loadFriends];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Delete

-(void)activateDeletionMode:(UIGestureRecognizer *)recognizer {
    
    CGPoint p = [recognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        PlayerCollectionViewCell* cell =
        (PlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if(recognizer.state == UIGestureRecognizerStateBegan) {
            cell.alpha = 0.7;
        }
    }
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        self.deleteModus = !self.deleteModus;
        if(self.deleteModus) {
            CGPoint p = [recognizer locationInView:self.collectionView];
            
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
            if (indexPath == nil){
                NSLog(@"couldn't find index path");
            } else {
                PlayerCollectionViewCell* cell =
                (PlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [cell.deleteButton setHidden:NO];
                [cell.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
                [self startShivering:cell];
                cell.alpha = 0.7;
                
            }
        }
        else {
            CGPoint p = [recognizer locationInView:self.collectionView];
            
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
            if (indexPath == nil){
                NSLog(@"couldn't find index path");
            } else {
                PlayerCollectionViewCell* cell =
                (PlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [cell.deleteButton setHidden:YES];
                [cell.deleteButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                [self stopShivering:cell];
                cell.alpha = 1.0;
            }
        }
    }
}

-(void)delete:(id)sender {
    UIView *parent = [sender superview];
    while (parent && ![parent isKindOfClass:[PlayerCollectionViewCell class]]) {
        parent = parent.superview;
    }
    
    PlayerCollectionViewCell *cell = (PlayerCollectionViewCell *)parent;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self deleteFriend:indexPath];
    [self.collectionView reloadData];
    
    [sender setHidden:YES];
    [sender removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self stopShivering:cell];
}

-(void)deleteFriend:(NSIndexPath *)indexPath {
    NSError *error = [sqliteManager doQuery:[NSString stringWithFormat:@"DELETE FROM Friends WHERE Friends.userId = '%li';",((DEPlayer *)self.friends[indexPath.row]).userId]];
    if(error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"deleteFriendMsg", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [self.friends removeObjectAtIndex:indexPath.row];
    }
}

#pragma mark -
#pragma mark Delete Animations

-(CAAnimation*)rotationAnimation {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.values = @[@(-kWiggleRotateAngle), @(kWiggleRotateAngle)];
    
    animation.autoreverses = YES;
    animation.duration = [self randomizeInterval:kWiggleRotateDuration
                                    withVariance:kWiggleRotateDurationVariance];
    animation.repeatCount = HUGE_VALF;
    
    return animation;
}

-(CAAnimation*)bounceAnimation {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.values = @[@(kWiggleBounceY), @(0.0)];
    
    animation.autoreverses = YES;
    animation.duration = [self randomizeInterval:kWiggleBounceDuration
                                    withVariance:kWiggleBounceDurationVariance];
    animation.repeatCount = HUGE_VALF;
    
    return animation;
}

-(NSTimeInterval)randomizeInterval:(NSTimeInterval)interval withVariance:(double)variance {
    double random = (arc4random_uniform(1000) - 500.0) / 500.0;
    return interval + variance * random;
}

-(void)startShivering:(PlayerCollectionViewCell *)cell {
    [UIView animateWithDuration:0
                     animations:^{
                         [cell.layer addAnimation:[self rotationAnimation] forKey:@"rotation"];
                         [cell.layer addAnimation:[self bounceAnimation] forKey:@"bounce"];
                         cell.transform = CGAffineTransformIdentity;
                     }];
}

-(void)stopShivering:(PlayerCollectionViewCell *)cell {
    [cell.layer removeAnimationForKey:@"rotation"];
    [cell.layer removeAnimationForKey:@"bounce"];
}

#pragma mark -
#pragma mark Database

-(SQLiteManager *)getSQLiteManager {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"pinfever_db.db"];
    return [[SQLiteManager alloc]initWithDatabaseNamed:writableDBPath];
}

-(void)loadFriends {
    [self.friends removeAllObjects];
    NSArray *friendResults = [sqliteManager getRowsForQuery:[NSString stringWithFormat:@"SELECT Users.name, Users.imageName,Users.userId from Friends JOIN Users ON Friends.userId = Users.userId;"]];
    
    for(NSDictionary *dict in friendResults) {
        DEPlayer *player = [[DEPlayer alloc]init];
        player.name = dict[@"name"];
        player.imageName = dict[@"imageName"];
        player.userId = [dict[@"userId"]integerValue];
        [self.friends addObject:player];
    }
    [self.collectionView reloadData];
}


#pragma mark -
#pragma mark Actions

-(IBAction)addFriend:(id)sender {
    DEAddFriendViewController *addFriendViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addFriendViewController"];
    addFriendViewController.delegate = self;
    [self.navigationController pushViewController:addFriendViewController animated:YES];
}

-(void)battleFriend:(DEPlayer *)player {
    NSLog(@"Battle with: %@",player.name);
}

#pragma mark -
#pragma mark DEAddFriendDelegate

-(void)addedFriend:(DEPlayer *)player {
    NSError *error = [sqliteManager doQuery:[NSString stringWithFormat:@"INSERT INTO Friends VALUES('%li');",player.userId]];
    if(error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"errorAddingFriend", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self loadFriends];
}

#pragma mark -
#pragma mark UICollectionViewDataSource & Delegate

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerCell" forIndexPath:indexPath];
    
    DEPlayer *player = self.friends[indexPath.row];
    cell.playerImageView.image = [UIImage imageNamed:player.imageName];
    cell.playerNameLabel.text = player.name;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DEPlayer *player = self.friends[indexPath.row];
    [self battleFriend:player];
}

@end
