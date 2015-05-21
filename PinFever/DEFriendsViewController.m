//
//  DEFriendsViewController.m
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEFriendsViewController.h"
#import "FriendsTableViewCell.h"
#import "DEAddFriendViewController.h"
#import "PlayerCollectionViewCell.h"
#import "DEPlayer.h"
#import "SQLiteManager.h"

@interface DEFriendsViewController ()

@end

@implementation DEFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"friendsTitle", nil);
    
    self.friends = [NSMutableArray new];
    sqliteManager = [self getSQLiteManager];
    [self loadFriends];
    //TODO: implement delete like app icon (long press, shivering animation, delete button in corner)
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark Actions

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

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayerCollectionViewCell *cell = (PlayerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGAffineTransform expandTransform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.4 initialSpringVelocity:.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell.transform = expandTransform;
    } completion:^(BOOL finished) {
    }];
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayerCollectionViewCell *cell = (PlayerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGAffineTransform normalTransform = CGAffineTransformMakeScale(1.0, 1.0);
    cell.transform = CGAffineTransformInvert(normalTransform);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    DEPlayer *player = self.friends[indexPath.row];
    [self battleFriend:player];
}


@end
