//
//  ViewController.m
//  PhotoPermissions
//
//  Created by Thaddeus Ternes on 9/29/17.
//  Copyright © 2017 Thaddeus Ternes. All rights reserved.
//

@import Photos;
#import "ViewController.h"

@implementation ViewController

#pragma mark - Actions

- (IBAction)checkPermissions:(id)sender
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch(status)
    {
        case PHAuthorizationStatusDenied:
            [self showAlertTitle:@"Permissions" message:@"Denied"];
            break;
        case PHAuthorizationStatusAuthorized:
            [self showAlertTitle:@"Permissions" message:@"Authorized"];
            break;
        case PHAuthorizationStatusRestricted:
            [self showAlertTitle:@"Permissions" message:@"Restricted"];
            break;
        case PHAuthorizationStatusNotDetermined:
            [self showAlertTitle:@"Permissions" message:@"NotDetermined"];
            break;
    }
}

- (IBAction)writeImageToPhotos:(id)sender
{
    // Generates a random image and saves it to the Photos Library.
    // If this is the first time the application has attempted this routine,
    // the system will promped for Write-Only permissions when UIImageWriteToSavedPhotosAlbum is called.
    NSString *dateString = [[NSDate date] description];
    
    CGRect r = CGRectMake(0, 0, 500, 500);
    UIGraphicsBeginImageContext(r.size);

    [[UIColor blackColor] setFill];
    [[UIBezierPath bezierPathWithRect:r] fill];
    [dateString drawInRect:r withAttributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:16],
        NSForegroundColorAttributeName : [UIColor whiteColor],
    }];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(image ,
                                   self,
                                   @selector(savedImage:withError:usingContext:),
                                   NULL);
    UIGraphicsEndImageContext();
}


- (IBAction)openSettings:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                       options:@{}
                             completionHandler:nil];
}


#pragma mark - Helpers

- (void)showAlertTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)savedImage:(UIImage *)image withError:(NSError *)error usingContext:(void *)context
{
    if(error == nil)
    {
        [self showAlertTitle:@"Save Successful" message:@"Image saved to Photo Library"];
    }
    else
    {
        [self showAlertTitle:@"Save Failed" message:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
    }
}

@end
