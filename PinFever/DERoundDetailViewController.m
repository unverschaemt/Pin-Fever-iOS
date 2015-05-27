//
//  DERoundDetailViewController.m
//  PinFever
//
//  Created by David Ehlen on 06.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DERoundDetailViewController.h"
#import "DERoundTableViewCell.h"

@interface DERoundDetailViewController ()
@end

@implementation DERoundDetailViewController

-(void)fillRoundsPlaceholder {
    self.rounds = [NSMutableArray new];
    for(int i = 0;i<6;i++) {
        NSMutableArray *questions = [NSMutableArray new];
        for(int j = 0;j<3;j++) {
            [questions addObject:@"QuestionPlaceholder"];
        }
        [self.rounds addObject:questions];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"roundDetailTitle", nil);
    [self fillRoundsPlaceholder];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"DERoundTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RoundCell"];
    self.tableView.SKSTableViewDelegate = self;
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.rounds.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return ((NSMutableArray*)self.rounds[(NSUInteger) indexPath.section]).count;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RoundCell";
    
    DERoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DERoundTableViewCell" owner:self options:nil];
        cell = topLevelObjects[0];

    }
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ #%li",NSLocalizedString(@"round", nil),(long)indexPath.section+1];

    cell.scoreLabel.text = @"0:0";
    cell.expandable = YES;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ #%li",NSLocalizedString(@"question", nil),(long)indexPath.subRow];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.subRow % 2 == 0) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else {
        cell.textLabel.textColor = [UIColor greenColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Question angeklickt");
}



@end
