//
//  ServerConnect.m
//  xmppchat
//
//  Created by kuanchih on 2014/10/22.
//  Copyright (c) 2014年 Jhicoll. All rights reserved.
//

#import "ServerConnect.h"

extern NSString *const kXMPPmyJID;
extern NSString *const kXMPPmyPassword;
extern NSString *const kXMPPmyServer;
extern NSString *const kXMPPautoLogin;

@interface ServerConnect ()<XMPPStreamDelegate>

@property (nonatomic, strong) NSString *password;

@end

@implementation ServerConnect

//@synthesize xmppStream;

- (void)setupStream {
    NSAssert(_xmppStream == nil, @"Method setupStream invoked multiple times");
    NSLog(@"start setting xmpp stream");
    _xmppStream = [[XMPPStream alloc] init];
    _xmppStream.enableBackgroundingOnSocket = YES;
    
    _xmppReconnect = [[XMPPReconnect alloc] init];
    
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
    
    _xmppRoster.autoFetchRoster = YES;
    _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    _xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardStorage];
    _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
    
    _xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:_xmppCapabilitiesStorage];
    
    _xmppCapabilities.autoFetchHashedCapabilities = YES;
    _xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    [_xmppReconnect         activate:_xmppStream];
    [_xmppRoster            activate:_xmppStream];
    [_xmppvCardTempModule   activate:_xmppStream];
    [_xmppvCardAvatarModule activate:_xmppStream];
    [_xmppCapabilities      activate:_xmppStream];
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (BOOL)connect
{
    if (![_xmppStream isDisconnected]) {
        return YES;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *myJID = [NSString stringWithFormat:@"%@@%@", [userDefaults stringForKey:kXMPPmyJID] , [userDefaults stringForKey:kXMPPmyServer]];
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
    //
    // If you don't want to use the Settings view to set the JID,
    // uncomment the section below to hard code a JID and password.
    //
    // myJID = @"user@gmail.com/xmppframework";
    // myPassword = @"";
    
    if (myJID == nil || myPassword == nil) {
        return NO;
    }
    
    [_xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    _password = myPassword;
    
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:5.0f error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return NO;
    }
    return YES;
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
    [self.delegate serverDidFinishAuthenticate];
    _isXmppConnected = YES;
}

- (void)disconnect {
    self.isXmppConnected = NO;
    [_xmppStream disconnect];
}

- (void)clearLoginData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@"" forKey:kXMPPmyJID];
    [userDefaults setValue:@"" forKey:kXMPPmyPassword];
    [userDefaults setValue:@"" forKey:kXMPPmyServer];
    [userDefaults setBool:NO forKey:kXMPPautoLogin];
}

- (void)shutdownStream {
    [_xmppStream removeDelegate:self];
    [_xmppRoster removeDelegate:self];
    
    [_xmppReconnect         deactivate];
    [_xmppRoster            deactivate];
    
    [_xmppStream disconnect];
    
    _xmppStream = nil;
    _xmppReconnect = nil;
    _xmppRoster = nil;
    _xmppRosterStorage = nil;
    [self clearLoginData];
    
}


#pragma mark - roster storage object

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [_xmppRosterStorage mainThreadManagedObjectContext];
}

#pragma mark - stream delegate

- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    NSLog(@"will connect to server");
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    NSLog(@"socket connect");
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender {
    NSLog(@"connection timeout");
    [self.delegate serverConnectionTimeout];
    
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"it's connect, start login with password");
    NSError *error = nil;
//    NSLog(@"%@",_password);
    if (![_xmppStream authenticateWithPassword:_password error:&error]) {
        NSLog(@"login failure %@", error);
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    NSLog(@"auth failure %@", error);
    [self.delegate serverErrorAuthenticate];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"it's authenticate");
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(DDXMLElement *)error {
    NSLog(@"error %@", [error stringValue]);
}

#pragma mark - singleton object


+ (ServerConnect *)sharedConnect {
    static ServerConnect *_serverConnect = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _serverConnect = [[ServerConnect alloc] init];
    });
    
    return _serverConnect;
}


@end
