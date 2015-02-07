//
//  ViewController.m
//  LivePaperSample
//
//  Created by Steven Say on 2/6/15.
//  Copyright (c) 2015 Hewlett-Packard. All rights reserved.
//

#import "ViewController.h"
#import <LivePaperSDK/LivePaperSDK.h>

#define CLIENT_ID       @"YOUR_CLIENT_ID"
#define CLIENT_SECRET   @"YOUR_CLIENT_SECRET"

@interface ViewController ()

@property(nonatomic, retain) LivePaperSession *lpSession;
- (IBAction)onCreateShortURL:(id)sender;
- (IBAction)onCreateQrCode:(id)sender;
- (IBAction)onCreateWatermark:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _lpSession = [LivePaperSession createSessionWithClientID:CLIENT_ID secret:CLIENT_SECRET];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)showAlert:(NSString *)title image:(UIImage *)image
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    UIImageView *imageView= [[UIImageView alloc] initWithImage:image];
    // UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    // [imageView setImage:qrCodeImage];
    [alert setValue:imageView forKey:@"accessoryView"];
    [alert show];
}

- (IBAction)onCreateShortURL:(id)sender {
    NSString *name = @"Short URL from iOS";
    NSURL *url = [NSURL URLWithString:@"https://www.linkcreationstudio.com"];
    [_lpSession createShortUrl:name destination:url completionHandler:^(NSURL *shortUrl, NSError *error) {
        if (shortUrl) {
            [self showAlert:@"Created ShortURL" message:[shortUrl absoluteString]];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];
}

- (IBAction)onCreateQrCode:(id)sender {
    NSString *name = @"QrCode from iOS";
    NSURL *url = [NSURL URLWithString:@"https://www.linkcreationstudio.com"];
    [_lpSession createQrCode:name destination:url completionHandler:^(UIImage *image, NSError *error) {
        if (image) {
            [self showAlert:@"Created QrCode" image:image];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];
}

- (IBAction)onCreateWatermark:(id)sender {
    NSString *name = @"Watermark from iOS";
    NSURL *url = [NSURL URLWithString:@"https://www.linkcreationstudio.com"];
    NSURL *imageURL = [NSURL URLWithString:@"https://s3-us-west-1.amazonaws.com/linkcreationstudio.com/developer/zion_600x450.jpg"];
    [_lpSession createWatermark:name destination:url imageURL:imageURL completionHandler:^(UIImage *watermarkedImage, NSError *error) {
        if (watermarkedImage) {
            [self showAlert:@"Watermarked Image" image:watermarkedImage];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];
}
@end
