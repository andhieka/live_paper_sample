//
//  ViewController.m
//  LivePaperSample
//
//  Copyright (c) 2015 Hewlett-Packard. All rights reserved.
//

#import "ViewController.h"
#import <LivePaperSDK/LivePaperSDK.h>

#define CLIENT_ID       @"YOUR_CLIENT_ID"
#define CLIENT_SECRET   @"YOUR_CLIENT_SECRET"

@interface ViewController ()

@property(nonatomic, retain) LPSession *lpSession;
- (IBAction)onCreateShortURL:(id)sender;
- (IBAction)onCreateQrCode:(id)sender;
- (IBAction)onCreateWatermark:(id)sender;
- (IBAction)onCreateWatermarkWithRichPayoff:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _lpSession = [LPSession createSessionWithClientID:CLIENT_ID secret:CLIENT_SECRET];
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
    NSString *name = @"Short URL with Basic Payoff";
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
    NSString *name = @"QrCode with Basic Payoff";
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
    NSString *name = @"Watermark with Basic Payoff";
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

- (IBAction)onCreateWatermarkWithRichPayoff:(id)sender {
    NSString *name = @"Watermark with Rich Payoff";
    NSURL *url = [NSURL URLWithString:@"https://www.linkcreationstudio.com"];
    NSURL *imageURL = [NSURL URLWithString:@"http://static.movember.com/uploads/2014/profiles/ef4/ef48a53fb031669fe86e741164d56972-546b9b5c56e15-hero.jpg"];
    NSDictionary *richPayoffData = @{
                                     @"type" : @"content action layout",
                                     @"version" : @"1",
                                     @"data" : @{
                                             @"content" : @{
                                                     @"type" : @"image",
                                                     @"label" : @"Movember!",
                                                     @"data" : @{
                                                             @"URL" : @"http://static.movember.com/uploads/2014/profiles/ef4/ef48a53fb031669fe86e741164d56972-546b9b5c56e15-hero.jpg"
                                                             }
                                                     },
                                             @"actions" : @[
                                                           @{
                                                             @"type" : @"webpage",
                                                             @"label" : @"Donate!",
                                                             @"icon" : @{ @"id" : @"533" },
                                                             @"data" : @{ @"URL" : @"http://MOBRO.CO/oamike" }
                                                             },
                                                           @{
                                                             @"type" : @"share",
                                                             @"label" : @"Share!",
                                                             @"icon" : @{ @"id" : @"527" },
                                                             @"data" : @{ @"URL" : @"Help Mike get the prize of most donations on his team! MOBRO.CO/oamike"}
                                                             }
                                                           ]
                                             }
                                     };
    [_lpSession createWatermark:name richPayoffData:richPayoffData publicURL:url imageURL:imageURL completionHandler:^(UIImage *watermarkedImage, NSError *error) {
        if (watermarkedImage) {
            [self showAlert:@"Watermarked Image" image:watermarkedImage];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];
}
@end
