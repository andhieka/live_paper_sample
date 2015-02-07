LivePaperSDK for iOS

INTRODUCTION
The LivePaper SDK for iOS lets you create QR codes, watermark images and short URLs.


HOW TO USE THE SDK
1) Unpack the SDK zip file.

2) Drag the “LivePaperSDK.framework” folder to your Xcode project. When prompted, select “Copy items into destination group’s folder”.

3) Include LivePaperSDK.h in your source code:

#import <LivePaperSDK/LivePaperSDK.h>

4) Create an instance of LivePaperSession using your client ID and secret, which you can get from the Link Developer website.

LivePaperSession *lpSession = [LivePaperSession createSessionWithClientID:”CLIENT_ID” secret:”CLIENT_SECRET”];

5) Use LivePaperSession to create QR codes, watermark images and short URLs.


TO CREATE SHORT URL:

    NSString *name = @“My Short URL”;
    NSURL *url = [NSURL URLWithString:@"https://www.linkcreationstudio.com"];
    [lpSession createShortUrl:name destination:url completionHandler:^(NSURL *shortUrl, NSError *error) {
        if (shortUrl) {
            [self showAlert:@"Created ShortURL" message:[shortUrl absoluteString]];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];


TO CREATE QR CODE:

    NSString *name = @“My QR Code";
    NSURL *url = [NSURL URLWithString:@"https://www.linkcreationstudio.com"];
    [lpSession createQrCode:name destination:url completionHandler:^(UIImage *image, NSError *error) {
        if (image) {
            [self showAlert:@"Created QrCode" image:image];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];


TO CREATE WATERMARK:

    NSString *name = @“My Watermark";
    NSURL *url = [NSURL URLWithString:@"https://www.linkcreationstudio.com"];
    NSURL *imageURL = [NSURL URLWithString:@"https://s3-us-west-1.amazonaws.com/linkcreationstudio.com/developer/zion_600x450.jpg"];
    [lpSession createWatermark:name destination:url imageURL:imageURL completionHandler:^(UIImage *watermarkedImage, NSError *error) {
        if (watermarkedImage) {
            [self showAlert:@"Watermarked Image" image:watermarkedImage];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];


SAMPLE APP:
You can also look at the LivePaperSample included in the zip file. This app demonstrates how to use the LivePaperSDK.
