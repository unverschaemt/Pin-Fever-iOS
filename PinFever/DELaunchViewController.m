//
//  DELaunchViewController.m
//  PinFever
//
//  Created by David Ehlen on 09.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DELaunchViewController.h"
#import "PlayerCollectionViewCell.h"

@interface DELaunchViewController ()
@property (nonatomic,strong) UIView *footerView;
@end

@implementation DELaunchViewController

#define FOOTER_HEIGHT 50
#define STARTBUTTON_HEIGHT 30
#define STARTBUTTON_WIDTH 60
#define STARTLABEL_HEIGHT 30
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tagControl.tagPlaceholder = NSLocalizedString(@"tagPlaceholder", nil);
    self.tagControl.mode = TLTagsControlModeEdit;
    self.tagControl.tagDelegate = self;
    self.tagControl.maxTags = @1;
    [self setupFooterView];
}

-(void)setupFooterView {
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, FOOTER_HEIGHT)];
    self.footerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin);
    self.footerView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.7];
    self.footerView.alpha = 0.0;
    
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(self.footerView.frame.size.width-STARTBUTTON_WIDTH-15, (FOOTER_HEIGHT-STARTBUTTON_HEIGHT)/2, STARTBUTTON_WIDTH, STARTBUTTON_HEIGHT)];
    UIColor *darkGrayColor = [UIColor colorWithRed:23.0/255.0 green:27.0/255.0 blue:34.0/255.0 alpha:1.0];
    startButton.backgroundColor = [UIColor clearColor];
    startButton.layer.borderColor = darkGrayColor.CGColor;
    startButton.layer.borderWidth = 1.0f;
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton setTitleColor:darkGrayColor forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    startButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    startButton.layer.cornerRadius = 5;
    [self.footerView addSubview:startButton];
    
    UILabel *footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (FOOTER_HEIGHT-STARTLABEL_HEIGHT)/2, 150, STARTLABEL_HEIGHT)];
    footerLabel.text = NSLocalizedString(@"pinFeverGame", nil);
    footerLabel.textColor = darkGrayColor;
    footerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [self.footerView addSubview:footerLabel];
    
    [self.view insertSubview:self.footerView aboveSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startGame {
    //Only 1 opponent is allowed therefore always tags[0]
    NSString *opponentName = [self.tagControl stringForTagIndex:0];
    NSLog(@"%@",opponentName);
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
#pragma mark UICollectionViewDataSource & Delegate

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerCell" forIndexPath:indexPath];
    if(indexPath.row == 0) {
        cell.playerImageView.image = [UIImage imageNamed:@"avatarPlaceholder"];
        cell.playerNameLabel.text = NSLocalizedString(@"autoMatch", nil);
    }
    
    cell.playerImageView.image = [UIImage imageNamed:@"avatarPlaceholder"];
    cell.playerNameLabel.text = @"nils_hirsekorn";
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
    PlayerCollectionViewCell *cell = (PlayerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.tagControl addTag:cell.playerNameLabel.text];
    [self.tagControl reloadTagSubviews];
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

-(void)showFooter {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.footerView.alpha = 1.0;
        CGRect footerFrame = self.footerView.frame;
        footerFrame.origin.y = footerFrame.origin.y-FOOTER_HEIGHT;
        self.footerView.frame = footerFrame;

    } completion:nil];
}

-(void)hideFooter {
    
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.footerView.alpha = 0.0;
        CGRect footerFrame = self.footerView.frame;
        footerFrame.origin.y = footerFrame.origin.y+FOOTER_HEIGHT;
        self.footerView.frame = footerFrame;
        
    } completion:nil];
}


@end
