//
//  DEGameViewController.m
//  PinFever
//
//  Created by David Ehlen on 22.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEGameViewController.h"
#import "DETileOverlay.h"
#import "MBXRasterTileRenderer.h"

@interface DEGameViewController ()

@end

@implementation DEGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"gameTitle", nil);
    
    self.mapView.delegate = self;
    NSString *template = @"http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg";
    DETileOverlay *overlay = [[DETileOverlay alloc] initWithURLTemplate:template];
    overlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    return [[MBXRasterTileRenderer alloc] initWithTileOverlay:overlay];
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

@end
