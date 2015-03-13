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

@class MessageData;
@protocol ServerConnectProtocol;
@protocol ServerMessageProtocol;
@interface ServerConnect : NSObject

- (void)setupStream;
- (void)shutdownStream;
- (void)registerUser;
- (BOOL)connect;
- (void)disconnect;
- (void)clearLoginData;

- (NSManagedObjectContext *)managedObjectContext_roster;

+ (ServerConnect *) sharedConnect;

@property (nonatomic, strong) id<ServerConnectProtocol> delegate;
@property (nonatomic, strong) id<ServerMessageProtocol> msdelegate;
@property (nonatomic) BOOL isXmppConnected;
@property (nonatomic, strong) NSString *talkJID;
@property (nonatomic) BOOL isRegisterUser;

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

@optional
- (void)serverDidFinishAuthenticate;
- (void)serverConnectionTimeout;
- (void)serverErrorAuthenticate;

@end

@protocol ServerMessageProtocol <NSObject>

@optional
- (void)serverDidReceiveMessage:(NSString *)message fromUser:(NSString *)user;
- (void)serverDidReceiveMessageFromTalkUser:(NSString *)message;
- (void)serverDidReceiveMessageData:(MessageData *)messageData;
- (void)serverDidReceiveRoomMessage:(NSString *)message fromUser:(NSString *)user;

@end
