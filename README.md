# Link Developer SDK for iOS

Provides an Objective C interface to the "Link" service by HP for creating watermarked images, QR codes, and mobile-friendly shortened URLs. 

## Installation

1. Unpack the SDK zip file.
2. Drag the “LivePaperSDK.framework” folder to your Xcode project. When prompted, select “Copy items into destination group’s folder”.

## Quick-Start Usage

### Authenticate

The Link Developer SDK requires authentication with two keys: your id key and secret key.  These are shown in the green box on the [Link Developer Authentication](https://www.linkcreationstudio.com/api/libraries/ios/) page.
   
```objc
#import <LivePaperSDK/LivePaperSDK.h>

LPSession *lpSession = [LPSession createSessionWithClientID:@”your client id” secret:@”your client secret”];
```

### Shortening URLs

```objc
    NSString *name = @“My Short URL”;
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    [lpSession createShortUrl:name destination:url completionHandler:^(NSURL *shortUrl, NSError *error) {
        if (shortUrl) {
            [self showAlert:@"Created ShortURL" message:[shortUrl absoluteString]];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];
```

### Generating QR Codes

```objc
    NSString *name = @“My QR Code";
    NSURL *url = [NSURL URLWithString:@"https://www.amazon.com"];
    [lpSession createQrCode:name destination:url completionHandler:^(UIImage *image, NSError *error) {
        if (image) {
            [self showAlert:@"Created QrCode" image:image];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];
```

### Watermarking Images

```objc
    NSString *name = @“My Watermark";
    NSURL *url = [NSURL URLWithString:@"https://www.hp.com"];
    NSURL *imageURL = [NSURL URLWithString:@"https://s3-us-west-1.amazonaws.com/linkcreationstudio.com/developer/zion_600x450.jpg"];
    [lpSession createWatermark:name destination:url imageURL:imageURL completionHandler:^(UIImage *watermarkedImage, NSError *error) {
        if (watermarkedImage) {
            [self showAlert:@"Watermarked Image" image:watermarkedImage];
        } else {
            [self showAlert:@"Error" message:[error description]];
        }
    }];
```

### Watermarking Images with Rich Payoff

```objc
    NSString *name = @“My Watermark With Rich Payoff";
    NSURL *url = [NSURL URLWithString:@"https://www.hp.com"];
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

## Usage

The SDK supports full CRUD operations on the underlying objects. If you do not need to update or delete previously created objects, see the quick-start section above.

### Underlying Objects

**Triggers** represent the object you want to put on a page: a short url, QR code, or watermarked image.
**Payoffs** are destinations, either the url of a webpage, or an interactive mobile experience.
**Links** join a Trigger to a Payoff.

### CRUD Example

```objc
  NSString *name = @“ShortURL Example";
  NSURL *url = [NSURL URLWithString:@"https://www.hp.com"];
  LPSession *lpSession = [LPSession createSessionWithClientID:@”your client id” secret:@”your client secret”];
  [LPTrigger createShortUrl:lpSession name:name completionHandler:^(LPTrigger *trigger, NSError *error) {
    if (trigger) {
      [LPPayoff createWeb:lpSession name:name url:url completionHander:^(LPPayoff *payoff, NSError *error) {
        if (payoff) {
          [LPLink create:lpSession name:name triggerId:trigger.triggerId payoffId:payoff.payoffId completionHandler:^(LPLink *link, NSError *error) {
          if (link) {
            trigger.shortURL; // returns url of the form http://hpgo.co/abc123
          }
        }
      }];
   }];
```

After creating, you will need to persist the link, payoff, and trigger IDs in some form of
permanent storage to later access the resources. The IDs are strings.

If you want to change the destination:

```objc
  LPSession *lpSession = [LPSession createSessionWithClientID:@”your client id” secret:@”your client secret”];

  NSString *payoff_id = @"123";
  [LPPayoff get:lpSession payoffId:payoff_id completionHandler:^(LPPayoff *payoff, NSError *error) {
    if (payoff) {
      payoff.url = [NSURL URLWithString:@"http://shopping.hp.com"];
      [payoff update:^(NSError *error) {
        if (!error) {
          payoff.url // returns the new URL
        }
      }];
    }
  }];
```

Still later, if you wanted to delete the resources:

```objc
  LPSession *lpSession = [LPSession createSessionWithClientID:@”your client id” secret:@”your client secret”];

  NSString *link_id = @"123";

  // delete link first, to avoid resource conflict
  [LPLink get:lpSession linkId:link_id completionHandler:^(LPLink *link, NSError *error) {
    if (link) {
      [link delete:^(NSError *error) {
        if (!error) {
          // delete trigger
          [LPTrigger get:lpSession triggerId:link.triggerId completionHandler:^(LPTrigger *trigger, NSError *error) {
            if (trigger) {
              [trigger delete:^(NSError *error) {}];
            }
          }];
          
          // delete payoff
          [LPPayoff get:lpSession payoffId:link.payoffId completionHandler:^(LPPayoff *payoff, NSError *error) {
            if (payoff) {
              [payoff delete:^(NSError *error) {}];
            }
          }];
        }
      }];
    }
  }];
```

You can list existing resources with the list operation.

```objc
  LPSession *lpSession = [LPSession createSessionWithClientID:@”your client id” secret:@”your client secret”];

  [LPLink list:lpSession completionHandler:^(NSArray *links, NSError *error) {
    links; // returns array of LPLink objects
  }];
  
  [LPPayoff list:lpSession completionHandler:^(NSArray *payoffs, NSError *error) {
    payoffs; // returns array of LPPayoff objects
  }];
```

### QR Code Example

```objc
  NSString *name = @“QRCode Example";
  NSURL *url = [NSURL URLWithString:@"http://www.hp.com"];
  LPSession *lpSession = [LPSession createSessionWithClientID:@”your client id” secret:@”your client secret”];
  [LPTrigger createQrCode:lpSession name:name completionHandler:^(LPTrigger *trigger, NSError *error) {
    if (trigger) {
      [LPPayoff createWeb:lpSession name:name url:url completionHander:^(LPPayoff *payoff, NSError *error) {
        if (payoff) {
          [LPLink create:lpSession name:name triggerId:trigger.triggerId payoffId:payoff.payoffId completionHandler:^(LPLink *link, NSError *error) {
          if (link) {
            [trigger getQrCodeImage:^(UIImage *image, NSError *error) {
              image; // returns QR Code image
            }];
          }
        }
      }];
   }];
```

### Watermarked Image Example

```objc
  NSString *name = @“Watermark Example";
  UIImage *image = [UIImage imageNamed:@"image_to_watermark"];
  NSURL *url = [NSURL URLWithString:@"http://www.hp.com"];
  LPSession *lpSession = [LPSession createSessionWithClientID:@”your client id” secret:@”your client secret”];
  [LPTrigger createWatermark:lpSession name:name image:image completionHandler:^(LPTrigger *trigger, NSError *error) {
    if (trigger) {
      [LPPayoff createWeb:lpSession name:name url:url completionHander:^(LPPayoff *payoff, NSError *error) {
        if (payoff) {
          [LPLink create:lpSession name:name triggerId:trigger.triggerId payoffId:payoff.payoffId completionHandler:^(LPLink *link, NSError *error) {
          if (link) {
            // Download watermark image
            [trigger getWatermarkImageWithStrength:10 resolution:75 completionHandler:^(UIImage *image, NSError *error) {
              if (image) {
                image; // returns Watermark image
              }
            }];
          }
        }
      }];
   }];
```

## Sample App:

You can also look at the _LivePaperSample_ app included in the SDK. This app demonstrates how to use the __Link Developer SDK for iOS__.
