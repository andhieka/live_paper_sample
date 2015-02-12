# LivePaperSDK for iOS


### INTRODUCTION

The __LivePaper SDK for iOS__ lets you create QR codes, watermark images and short URLs.


### HOW TO USE THE SDK

1. Unpack the SDK zip file.
2. Drag the “LivePaperSDK.framework” folder to your Xcode project. When prompted, select “Copy items into destination group’s folder”.
3. Include `LivePaperSDK.h` in your source code:
   
   ```objc
#import <LivePaperSDK/LivePaperSDK.h>
```
4. Create an instance of LPSession using your client ID and secret, which you can get from the Link Developer website.

   ```objc
LPSession *lpSession = [LPSession createSessionWithClientID:”CLIENT_ID” secret:”CLIENT_SECRET”];
```
5. Use `LPSession` to create QR codes, watermark images and short URLs.

### TO CREATE SHORT URL:

```objc
    NSString *name = @“My Short URL”;
    NSURL *url = [NSURL URLWithString:@"https://www.linkcreationstudio.com"];
    [lpSession createShortUrl:name destination:url completionHandler:^(NSURL *shortUrl, NSError *error) {
        if (shortUrl) {
            [self showAlert:@"Created ShortURL" message:[shortUrl absoluteString]];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];
```

### TO CREATE QR CODE:

```objc
    NSString *name = @“My QR Code";
    NSURL *url = [NSURL URLWithString:@"https://www.linkcreationstudio.com"];
    [lpSession createQrCode:name destination:url completionHandler:^(UIImage *image, NSError *error) {
        if (image) {
            [self showAlert:@"Created QrCode" image:image];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];
```

### TO CREATE WATERMARK:

```objc
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
```

### TO CREATE WATERMARK WITH RICH PAYOFF DATA:

```objc
    NSString *name = @“My Watermark With Rich Payoff";
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
    [lpSession createWatermark:name richPayoffData:richPayoffData publicURL:url imageURL:imageURL completionHandler:^(UIImage *watermarkedImage, NSError *error) {
        if (watermarkedImage) {
            [self showAlert:@"Watermarked Image" image:watermarkedImage];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];
```

### SAMPLE APP:

You can also look at the _LivePaperSample_ app included in the SDK. This app demonstrates how to use the __LivePaper SDK for iOS__.
