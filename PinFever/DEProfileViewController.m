//
//  DEProfileViewController.m
//  PinFever
//
//  Created by David Ehlen on 18.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEProfileViewController.h"
#import "KeychainItemWrapper.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface DEProfileViewController ()

@end

@implementation DEProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"profileViewTitle", nil);
    
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.borderWidth = 2.0;
    self.avatarImageView.layer.borderColor = [UIColor colorWithWhite:0.97 alpha:1.0].CGColor;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    fileManager = [DEFileManager new];
    profileManager = [DEProfileManager sharedManager];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
#pragma mark Methods

-(void)updateUI {
    //TODO: Show Player information on UI
    self.avatarImageView.image = [[profileManager me]avatarImg];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark -
#pragma mark UITableViewDatasource


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"profileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = NSLocalizedString(@"logout", nil);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0) {
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kKeychainKey accessGroup:nil];
        [keychainItem resetKeychainItem];
        [fileManager deleteAllFiles];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]]instantiateInitialViewController];
        app.window.rootViewController = loginViewController;

    }
}


@end
