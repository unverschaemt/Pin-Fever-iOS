//
//  DEHomeViewController.m
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEHomeViewController.h"
#import "ActiveGamesTableViewCell.h"
#import "DELaunchViewController.h"
#import "DEProfileViewController.h"
#import "DERoundDetailViewController.h"
#import "DECategoryViewController.h"

@interface DEHomeViewController ()
@end

@implementation DEHomeViewController

#define SECTION_HEADER_HEIGHT 22

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showProfile:)]];
    
    apiWrapper = [DEAPIWrapper new];

    self.waitingGames = [NSMutableArray new];
    self.activeGames = [NSMutableArray new];

    //TODO: Test data
    [self.waitingGames addObject:@"test"];
    [self.activeGames addObject:@"test"];
    
    self.title = NSLocalizedString(@"homeTitle", nil);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ActiveGamesTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"activeGamesCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    profileManager = [DEProfileManager sharedManager];
    [self loadPlayer];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadMatches];
    [self reloadAvatar];
    [self updateUI];
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
#pragma mark Player API Call

-(void)loadPlayer {

    NSURL *playerURL = [NSURL URLWithString:kAPIPlayerEndpoint];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [apiWrapper request:playerURL httpMethod:@"GET" optionalJSONData:nil optionalContentType:nil completed:^(NSDictionary *headers, NSString *body){
        [self parsePlayer:body];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    } failed:^(NSError *error){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
}

-(void)parsePlayer:(NSString *)body {
    NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
    if(response[kErrorKey] == (id)[NSNull null]) {
        NSDictionary *dict = [response[kDataKey] objectForKey:kPlayerKey];
        [profileManager me].playerId = dict[kIdKey];
        [profileManager me].displayName = dict[kDisplayName];
        if(dict[kEmailKey] != nil) {
              [profileManager me].email = dict[kEmailKey];
        }
        [profileManager me].level = @([dict[kLevelKey] integerValue]);
        [self refreshAvatar];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"playerParseError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)refreshAvatar {
    //Avatar refresh
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [apiWrapper dataRequest:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/img.jpeg",kAPISomePlayerEndpoint,[profileManager me].playerId]] httpMethod:@"GET" optionalJSONData:nil optionalContentType:nil completed:^(NSDictionary *headers, NSString *body, NSData *responseData){
        [[profileManager me]setAvatarImg:[UIImage imageWithData:responseData]];
        [self reloadAvatar];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    } failed:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


#pragma mark -
#pragma mark Actions

-(void)showProfile:(UIGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        DEProfileViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
}

-(void)newGame {
    DELaunchViewController *launchVc = [[self storyboard]instantiateViewControllerWithIdentifier:@"launchViewController"];
    launchVc.me = [profileManager me];
    [self.navigationController pushViewController:launchVc animated:YES];
}

-(void)reloadMatches {
    //TODO reloadArrays and afterwards TableView
    [self.tableView reloadData];
}

-(void)reloadAvatar {
    self.avatarImageView.image = [[profileManager me]avatarImg];
}

-(void)updateUI {
    [self.scoreLabel setText:[[[profileManager me]level]stringValue]];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return self.activeGames.count;
    }
    return self.waitingGames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, SECTION_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.893 alpha:1.000];
    
    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, SECTION_HEADER_HEIGHT)];
    sectionTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [headerView addSubview:sectionTitleLabel];
    
    if(section == 0)
    {
        sectionTitleLabel.text = NSLocalizedString(@"playStateActive", nil);
        int buttonYPosition = 1;
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-35, buttonYPosition, SECTION_HEADER_HEIGHT-(2*buttonYPosition), SECTION_HEADER_HEIGHT-(2*buttonYPosition))];
        addButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [addButton setImage:[UIImage imageNamed:@"newGame"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:addButton];
    }
    else {
        sectionTitleLabel.text = NSLocalizedString(@"playStateWaiting", nil);
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SECTION_HEADER_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}


#pragma mark -
#pragma mark UITableViewDatasource


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"activeGamesCell";
    
    ActiveGamesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ActiveGamesTableViewCell" owner:self options:nil];
        cell = topLevelObjects[0];
    }
    cell.titleLabel.text = @"Opponent";
    cell.playerImageView.image = [UIImage imageNamed:@"avatarPlaceholder"];
    cell.scoreLabel.text = @"0:0";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //TODO: Jeweils GameDetails mit übergeben
    if(indexPath.section == 0) {
        DECategoryViewController *categoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"categoryViewController"];
        [self.navigationController pushViewController:categoryViewController animated:YES];
        
    }
    else {
        DERoundDetailViewController *roundDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"roundDetailViewController"];
        [self.navigationController pushViewController:roundDetailViewController animated:YES];
    }
}

@end
