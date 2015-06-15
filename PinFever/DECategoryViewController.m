//
//  DECategoryViewController.m
//  PinFever
//
//  Created by David Ehlen on 22.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DECategoryViewController.h"
#import "DECategory.h"
#import "DEGameViewController.h"

@interface DECategoryViewController ()

@end

@implementation DECategoryViewController

#define kCategoryAmount 3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    apiWrapper = [DEAPIWrapper new];
    self.categories = [NSMutableArray new];
    [self setupButtonTags];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadRandomCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupButtonTags {
    self.categoryButton1.tag = 0;
    self.categoryButton2.tag = 1;
    self.categoryButton3.tag = 2;
}

-(IBAction)startGame:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(self.categories.count-1 >= button.tag) {
        DEGameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"gameViewController"];
        gameViewController.game = self.game;
        gameViewController.category = self.categories[(NSUInteger) button.tag];
        [self.navigationController pushViewController:gameViewController animated:YES];
    }
}

-(void)loadRandomCategories {
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [apiWrapper request:[NSURL URLWithString:[NSString stringWithFormat:@"%@?amount=%i&language=%@",kAPIRandomCategories,kCategoryAmount,language]] httpMethod:@"GET" optionalJSONData:nil optionalContentType:nil completed:^(NSDictionary *headers, NSString *body) {
        [self parseCategories:body];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    } failed:^(NSError *error){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"loadCategoriesError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];

    }];
}

-(void)parseCategories:(NSString *)body {
    NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    NSArray *response = dict[kDataKey][kCategoriesKey];
    for (NSDictionary *responseDict in response) {
        DECategory *category = [DECategory new];
        category.categoryId = responseDict[kIdKey];
        category.name = responseDict[kNameKey];
        [self.categories addObject:category];
    }
    [self updateCategoryButtons];
}

-(void)updateCategoryButtons {
    [self.categoryButton1 setTitle:((DECategory *)self.categories[0]).name forState:UIControlStateNormal];
    [self.categoryButton2 setTitle:((DECategory *)self.categories[1]).name forState:UIControlStateNormal];
    [self.categoryButton3 setTitle:((DECategory *)self.categories[2]).name forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
