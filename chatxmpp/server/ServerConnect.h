//
//  ServerConnect.h
//  xmppchat
//
//  Created by kuanchih on 2014/10/22.
//  Copyright (c) 2014年 Jhicoll. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMPPFramework.h"
//#import "XMPP.h"
//#import "XMPPRosterCoreDataStorage.h"
//#import "XMPPReconnect.h"

@protocol ServerConnectProtocol;
@interface ServerConnect : NSObject

- (void)setupStream;
- (void)shutdownStream;
- (BOOL)connect;
- (void)disconnect;
- (void)clearLoginData;

- (NSManagedObjectContext *)managedObjectContext_roster;

+ (ServerConnect *) sharedConnect;

@property (nonatomic, strong) id<ServerConnectProtocol> delegate;

// object

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;

@property (nonatomic, strong, readonly) XMPPvCardCoreDataStorage *xmppvCardStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

@end

@protocol ServerConnectProtocol <NSObject>

- (void)serverDidFinishAuthenticate;
- (void)serverErrorAuthenticate;

@optional
- (void)serverConnectionTimeout;

@end
