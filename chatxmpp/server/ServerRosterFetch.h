//
//  ServerRosterFetch.h
//  xmppchat
//
//  Created by kuanchih on 2014/10/22.
//  Copyright (c) 2014年 Jhicoll. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerRosterProtocol;
@interface ServerRosterFetch : NSObject

- (NSArray *) sections;
- (NSArray *) users;
- (void)setupFetchRosterController;
@property (nonatomic, strong) id<ServerRosterProtocol> delegate;

@end
@protocol ServerRosterProtocol <NSObject>

- (void)serverDidFinishFetchRosters:(NSArray *)users sections:(NSArray *)sections;

@end
