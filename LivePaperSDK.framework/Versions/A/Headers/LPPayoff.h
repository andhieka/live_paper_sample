//
//  LPPayoff.h
//  LivePaperSDK
//
//  Created by Steven Say on 2/9/15.
//  Copyright (c) 2015 Hewlett-Packard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivePaperSession.h"

@interface LPPayoff : NSObject

+ (void) create:(LivePaperSession *) session json:(NSDictionary *) json completionHandler:(void (^)(LPPayoff *payoff, NSError *error)) handler;

+ (void) createWeb:(LivePaperSession *) session name:(NSString *) name url:(NSURL *) url completionHandler:(void (^)(LPPayoff *payoff, NSError *error)) handler;

+ (void) createRich:(LivePaperSession *) session name:(NSString *) name url:(NSURL *) url richPayoffData:(NSDictionary *) richPayoffData completionHandler:(void (^)(LPPayoff *payoff, NSError *error)) handler;

+ (void) get:(LivePaperSession *) session payoffId:(NSString *) payoffId completionHandler:(void (^)(LPPayoff *payoff, NSError *error)) handler;

+ (void) list:(LivePaperSession *) session completionHandler:(void (^)(NSArray *payoffs, NSError *error)) handler;

@property(nonatomic, readonly) NSString *payoffId;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSURL *url;
@property(nonatomic, retain) NSDictionary *richPayoffData;
@property(nonatomic, readonly) NSArray *link;

- (BOOL) isWebPayoff;
- (BOOL) isRichPayoff;

- (void) update:(void (^)(NSError *error))handler;

- (void) delete:(void (^)(NSError *error)) handler;

@end
