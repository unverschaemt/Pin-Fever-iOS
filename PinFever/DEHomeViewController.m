//
//  DEHomeViewController.m
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEHomeViewController.h"
#import "ActiveGamesTableViewCell.h"

@interface DEHomeViewController ()

@end

@implementation DEHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    avatarImageView.clipsToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2;
    avatarImageView.layer.borderWidth = 2.0;
    avatarImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;

    [self.tableView registerNib:[UINib nibWithNibName:@"ActiveGamesTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"activeGamesCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showProfile:)]];
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

-(IBAction)showSettings:(id)sender {
    NSLog(@"Show Settings");
}

-(void)showProfile:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Show Profile");
}

-(IBAction)newGame:(id)sender {
    NSLog(@"New Game");
}


#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ActiveGamesTableHeader" owner:self options:nil];
    UIView *headerView = [topLevelObjects objectAtIndex:0];
    
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
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.titleLabel.text = @"Nils";
    cell.detailLabel.text = NSLocalizedString(@"playStateWaiting",nil);
    
    cell.playerImageView.image = [UIImage imageNamed:@"avatarPlaceholder"];
    cell.scoreLabel.text = @"5:3";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
