//
//  LPLink.h
//  LivePaperSDK
//
//  Created by Steven Say on 2/9/15.
//  Copyright (c) 2015 Hewlett-Packard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivePaperSession.h"

@interface LPLink : NSObject

+ (void) create:(LivePaperSession *) session name:(NSString *) name triggerId:(NSString *) triggerId payoffId:(NSString *) payoffId completionHandler:(void (^)(LPLink *link, NSError *error)) handler;

+ (void) get:(LivePaperSession *) session linkId:(NSString *) linkId completionHandler:(void (^)(LPLink *link, NSError *error)) handler;

+ (void) list:(LivePaperSession *) session completionHandler:(void (^)(NSArray *links, NSError *error)) handler;

@property(nonatomic, readonly) NSString *linkId;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, readonly) NSString *triggerId;
@property(nonatomic, readonly) NSString *payoffId;
@property(nonatomic, readonly) NSArray *link;

- (void) update:(void (^)(NSError *error))handler;

- (void) delete:(void (^)(NSError *error)) handler;

@end
