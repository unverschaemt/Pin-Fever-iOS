//
//  DEFriendsViewController.m
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEFriendsViewController.h"
#import "PlayerCollectionViewCell.h"
#import "AppDelegate.h"

@interface DEFriendsViewController ()

@end

@implementation DEFriendsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"friendsTitle", nil);
    
    apiWrapper = [DEAPIWrapper new];
    animator = [DEAnimator new];
    fileManager = [DEFileManager new];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(activateDeletionMode:)];
    longPress.minimumPressDuration = .5; //seconds
    [self.collectionView addGestureRecognizer:longPress];
    
    self.friends = [NSMutableArray new];
    [self loadFriendsFromDisk];
    [self loadFriends];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;
    [self.collectionView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    self.collectionView.emptyDataSetDelegate = nil;
    self.collectionView.emptyDataSetSource = nil;
    
    [self saveFriends];
}

-(void)showLoading:(BOOL)showIndicators {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:showIndicators];
}


#pragma mark -
#pragma mark Delete

-(void)activateDeletionMode:(UIGestureRecognizer *)recognizer {
    
    CGPoint p = [recognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
        return;
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
            if (indexPath == nil){
                return;
            } else {
                PlayerCollectionViewCell* cell =
                (PlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [cell.deleteButton setHidden:NO];
                [cell.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
                [animator startShivering:cell];
                cell.alpha = 0.7;
                
            }
        }
        else {
            if (indexPath == nil){
                return;
            } else {
                PlayerCollectionViewCell* cell =
                (PlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [cell.deleteButton setHidden:YES];
                [cell.deleteButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                [animator stopShivering:cell];
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
    
    [sender setHidden:YES];
    [sender removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [animator stopShivering:cell];
}

-(void)deleteFriend:(NSIndexPath *)indexPath {

    DEPlayer *player = [self.friends objectAtIndex:(NSUInteger)indexPath.row];
    NSURL *deleteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIDeleteFriendsEndpoint,player.playerId]];
    [self showLoading:YES];
    [apiWrapper request:deleteURL httpMethod:@"POST" optionalJSONData:nil optionalContentType:@"application/json"
              completed:^(NSDictionary *headers, NSString *body) {
                  [self.friends removeObjectAtIndex:(NSUInteger) indexPath.row];
                  [self.collectionView reloadData];
                  [self showLoading:NO];
              }
              failed:^(NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"deleteFriendError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                  [self showLoading:NO];
    }];
    
    
}

#pragma mark -
#pragma mark Load Friends

-(void)loadFriends {
    NSURL *friendsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kAPIFriendsEndpoint]];
    [self showLoading:YES];

    [apiWrapper request:friendsURL httpMethod:@"GET" optionalJSONData:nil optionalContentType:nil
              completed:^(NSDictionary *headers, NSString *body) {
                  [self parseFriends:body];
                  [self showLoading:NO];

              }
                 failed:^(NSError *error) {
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"getFriendsError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                     [self showLoading:NO];
                 }];

}

- (void)parseFriends:(NSString *)body {
        NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
        if(response[kErrorKey] == (id)[NSNull null]) {
            [self.friends removeAllObjects];
            NSArray *friends = [response[kDataKey] objectForKey:kFriendKey];
            if(friends.count != 0) {
                for(NSDictionary *dict in friends) {
                    DEPlayer *player = [DEPlayer new];
                    player.playerId = dict[kIdKey];
                    player.displayName = dict[kDisplayName];
                    if(dict[kEmailKey] != nil) {
                        player.email = dict[kEmailKey];
                    }
                    player.level = [NSNumber numberWithInteger:[dict[kLevelKey]integerValue]];
                    [self.friends addObject:player];
                }
            }
            [self.collectionView reloadData];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"friendsParseError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
}


#pragma mark -
#pragma mark Actions

-(IBAction)addFriend:(id)sender {
    DEAddFriendViewController *addFriendViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addFriendViewController"];
    addFriendViewController.delegate = self;
    [self.navigationController pushViewController:addFriendViewController animated:YES];
}

-(void)battleFriend:(DEPlayer *)player {
    NSLog(@"Battle with: %@",player.displayName);
}


#pragma mark -
#pragma mark DEAddFriendDelegate

-(void)addedFriend:(DEPlayer *)player {
    [self showLoading:YES];
    NSURL *addURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIAddFriendsEndpoint,player.playerId]];
    [apiWrapper request:addURL httpMethod:@"POST" optionalJSONData:nil optionalContentType:@"application/json"
              completed:^(NSDictionary *headers, NSString *body) {
                  [self.friends addObject:player];
                  [self.collectionView reloadData];
                  [self showLoading:NO];

              }
                 failed:^(NSError *error) {
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"addFriendError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                     [self showLoading:NO];

                 }];
}

-(void)saveFriends {
    [fileManager saveMutableArray:self.friends withFilename:kFriendsFilename];
}

-(void)loadFriendsFromDisk {
    self.friends = [fileManager loadMutableArray:kFriendsFilename];
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
    
    DEPlayer *player = self.friends[(NSUInteger) indexPath.row];
    cell.playerImageView.image = [UIImage imageNamed:@"avatarPlaceholder"];
    cell.playerNameLabel.text = player.displayName;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DEPlayer *player = self.friends[(NSUInteger) indexPath.row];
    [self battleFriend:player];
}

#pragma mark -
#pragma mark EmptySetDelegate & Datasource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedString(@"noFriends", nil);
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedString(@"noFriendsDetail", nil);
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"friends"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return NO;
}

@end
