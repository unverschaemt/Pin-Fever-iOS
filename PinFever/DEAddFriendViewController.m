//
//  DEAddFriendViewController.m
//  PinFever
//
//  Created by David Ehlen on 21.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEAddFriendViewController.h"
#import "PlayerCollectionViewCell.h"
#import "SQLiteManager.h"

@interface DEAddFriendViewController ()

@end

@implementation DEAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"addFriendTitle", nil);
    self.searchResults = [NSMutableArray new];
    sqliteManager = [self getSQLiteManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
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

-(void)searchForName:(NSString *)searchString {
    [self.searchResults removeAllObjects];
    
    NSArray *sqlResults = [sqliteManager getRowsForQuery:[NSString stringWithFormat:@"SELECT Users.name, Users.imageName, Users.userId FROM Users WHERE Users.name LIKE '%@%%';",searchString]];
    for(NSDictionary *dict in sqlResults) {
        DEPlayer *player = [DEPlayer new];
        player.name = dict[@"name"];
        player.imageName = dict[@"imageName"];
        player.userId = [dict[@"userId"]integerValue];
        [self.searchResults addObject:player];
    }
    
    [self.collectionView reloadData];
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
    return self.searchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerCell" forIndexPath:indexPath];
    DEPlayer *player = self.searchResults[indexPath.row];
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
  
    if ([self.delegate respondsToSelector:@selector(addedFriend:)])
    {
        [self.delegate addedFriend:self.searchResults[indexPath.row]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length > 0) {
        [self searchForName:searchBar.text];
    }
    else {
        [self.searchResults removeAllObjects];
        [self.collectionView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}



@end
