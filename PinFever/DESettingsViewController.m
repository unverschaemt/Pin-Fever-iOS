//
//  DESettingsViewController.m
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DESettingsViewController.h"
#import "DESettingsForm.h"
#import "DEImageUtility.h"

@interface DESettingsViewController ()

@end

@implementation DESettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"settingsTitle", nil);
    self.formController = [[FXFormController alloc] init];
    self.formController.delegate = self;
    self.formController.tableView = self.tableView;
    self.formController.form = [[DESettingsForm alloc] init];
    
    profileManager = [DEProfileManager sharedManager];
    apiWrapper = [DEAPIWrapper new];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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

-(void)changeAvatar:(UITableViewCell<FXFormFieldCell> *)cell {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)setNewImage:(UIImage *)image {
    [[profileManager me]setAvatarImg:image];
    UIImage *compressedImage = [DEImageUtility cropToJPEG:image size:CGSizeMake(200, 200) quality:0.7];

    NSURL *uploadURL = [NSURL URLWithString:kAPIUploadAvatarEndpoint];
    [apiWrapper request:uploadURL httpMethod:@"POST" optionalFormData:UIImageJPEGRepresentation(compressedImage, 1.0) completed:^(NSDictionary *headers, NSString *body) {
        
    } failed:^(NSError *error){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"uploadAvatarError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }];

}

-(void)displayNameChanged:(UITableViewCell<FXFormFieldCell> *)cell {
    DESettingsForm *form = cell.field.form;
    NSString *newDisplayName = form.displayName;
    NSURL *setPlayerURL = [NSURL URLWithString:kAPISetPlayerEndpoint];
    
    NSDictionary *postDict = @{ @"displayName":newDisplayName};
    
    NSError *err = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&err];
    if(err) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"setPlayerInfoError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    [apiWrapper request:setPlayerURL httpMethod:@"POST" optionalJSONData:postData optionalContentType:@"application/json" completed:^(NSDictionary *headers, NSString *body) {
        [[profileManager me]setDisplayName:newDisplayName];
    } failed:^(NSError *error){
        if(error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"setPlayerInfoError", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
}

#pragma mark -
#pragma mark UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self setNewImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
