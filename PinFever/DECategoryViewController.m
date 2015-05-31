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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.categories = [NSMutableArray new];
    //TODO: Categories Model mit einbinden
    DECategory *categorySport = [[DECategory alloc]initWithCategory:@"Sport"];
    DECategory *categoryMovies = [[DECategory alloc]initWithCategory:@"Movies"];
    DECategory *categoryTech = [[DECategory alloc]initWithCategory:@"Technology"];

    [self.categories addObject:categorySport];
    [self.categories addObject:categoryMovies];
    [self.categories addObject:categoryTech];
    
    [self.categoryButton1 setTitle:((DECategory *)self.categories[0]).categoryName forState:UIControlStateNormal];
    [self.categoryButton2 setTitle:((DECategory *)self.categories[1]).categoryName forState:UIControlStateNormal];
    [self.categoryButton3 setTitle:((DECategory *)self.categories[2]).categoryName forState:UIControlStateNormal];
    
    NSLog(@"%@",self.game);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startGame:(id)sender {
    //TODO: Ausgewählte Category mit übergeben
    DEGameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"gameViewController"];
    [self.navigationController pushViewController:gameViewController animated:YES];
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
