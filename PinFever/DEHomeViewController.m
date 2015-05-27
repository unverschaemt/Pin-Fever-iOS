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
#import "AppDelegate.h"

@interface DEHomeViewController ()
@end

@implementation DEHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.borderWidth = 2.0;
    self.avatarImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;
    [self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showProfile:)]];
    
    self.waitingGames = [NSMutableArray new];
    self.activeGames = [NSMutableArray new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ActiveGamesTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"activeGamesCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadMatches];
    [self reloadAvatar];
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
#pragma mark Methods
-(void)reloadAvatar {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.avatarImageView.image = [app avatarImage];
}


#pragma mark -
#pragma mark Actions

-(void)showProfile:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Show Profile");
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        DEProfileViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
}

-(void)newGame {
    NSLog(@"New Game");
    DELaunchViewController *launchVc = [[self storyboard]instantiateViewControllerWithIdentifier:@"launchViewController"];
    [self.navigationController pushViewController:launchVc animated:YES];
}

-(void)reloadMatches {
    //TODO reloadArrays and afterwards TableView
    [self.tableView reloadData];
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
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 44)];
    sectionTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [headerView addSubview:sectionTitleLabel];
    
    if(section == 0)
    {
        sectionTitleLabel.text = NSLocalizedString(@"playStateActive", nil);
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-50, 7, 30, 30)];
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
    return 44.0;
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
    //TODO: Je nach Section Detail oder Game pushen
}

@end
