//
//  ServerConnect.m
//  xmppchat
//
//  Created by kuanchih on 2014/10/22.
//  Copyright (c) 2014年 Jhicoll. All rights reserved.
//

#import "ServerConnect.h"
#import "MessageData.h"
#import "UserData.h"

extern NSString *const kXMPPmyJID;
extern NSString *const kXMPPmyPassword;
extern NSString *const kXMPPmyServer;
extern NSString *const kXMPPautoLogin;
extern NSString *const kXMPPmyServerName;

@interface ServerConnect ()<XMPPStreamDelegate, XMPPReconnectDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSString *password;
@property BOOL customCertEvaluation;
@end

@implementation ServerConnect

//@synthesize xmppStream;

- (void)setupStream {
    NSAssert(_xmppStream == nil, @"Method setupStream invoked multiple times");
    NSLog(@"start setting xmpp stream");
    _xmppStream = [[XMPPStream alloc] init];
    _xmppStream.enableBackgroundingOnSocket = YES;
//    _xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicyRequired;
    
    _xmppReconnect = [[XMPPReconnect alloc] init];
    
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
    
    _xmppRoster.autoFetchRoster = YES;
    _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
//    _xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
//    _xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardStorage];
//    _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
    
    _xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:_xmppCapabilitiesStorage];
    
    _xmppCapabilities.autoFetchHashedCapabilities = YES;
    _xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    [_xmppReconnect         activate:_xmppStream];
    [_xmppRoster            activate:_xmppStream];
//    [_xmppvCardTempModule   activate:_xmppStream];
//    [_xmppvCardAvatarModule activate:_xmppStream];
    [_xmppCapabilities      activate:_xmppStream];
    
    [_xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.customCertEvaluation = YES;
    
}

- (BOOL)connect
{
    if (![_xmppStream isDisconnected]) {
        return YES;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *myJID = [NSString stringWithFormat:@"%@@%@", [userDefaults stringForKey:kXMPPmyJID], [userDefaults stringForKey:kXMPPmyServerName]];
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
    [_xmppStream setHostName:[userDefaults stringForKey:kXMPPmyServer]];
    NSError *error = nil;

    if (![_xmppStream connectWithTimeout:10.0f error:&error])
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

- (void)login {
    NSError *error = nil;
    if (![_xmppStream authenticateWithPassword:_password error:&error]) {
        NSLog(@"login failure %@", error);
    }
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
    [_xmppStream disconnect];
    [_xmppReconnect         deactivate];
    [_xmppRoster            deactivate];
    
    [_xmppStream removeDelegate:self];
    [_xmppRoster removeDelegate:self];
    
    
    
    _xmppStream = nil;
    _xmppReconnect = nil;
    _xmppRoster = nil;
    _xmppRosterStorage = nil;
    [self clearLoginData];
    
}

#pragma mark - register

- (void)registerUser {
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
//    NSMutableArray *elements = [NSMutableArray array];
//    [elements addObject:[NSXMLElement elementWithName:@"username" stringValue:[userDefaults stringForKey:kXMPPmyJID]]];
//    [elements addObject:[NSXMLElement elementWithName:@"password" stringValue:myPassword]];
//    [elements addObject:[NSXMLElement elementWithName:@"name" stringValue:[userDefaults stringForKey:kXMPPmyJID]]];
//    [elements addObject:[NSXMLElement elementWithName:@"accountType" stringValue:@"3"]];
    
    if ([_xmppStream registerWithPassword:myPassword error:nil]) {
        NSLog(@"register success");
    }
//    [_xmppStream registerWithElements:elements error:nil];
}


#pragma mark - roster storage object

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [_xmppRosterStorage mainThreadManagedObjectContext];
}

#pragma mark - stream delegate

-(void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
    
    /*
     * Properly secure your connection by setting kCFStreamSSLPeerName
     * to your server domain name
     */
    [settings setObject:_xmppStream.myJID.domain forKey:(NSString *)kCFStreamSSLPeerName];
    
    /*
     * Use manual trust evaluation
     * as stated in the XMPPFramework/GCDAsyncSocket code documentation
     */
    if (self.customCertEvaluation) {
        settings[GCDAsyncSocketManuallyEvaluateTrust] = @(YES);
//        [settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
    }
//    [settings setObject:@(NO) forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
    NSLog(@"%@", settings);
}


- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL))completionHandler {
    NSLog(@"%@", sender);
    completionHandler(YES);
}

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
    _xmppStream = sender;
//    NSLog(@"%@",_password);
    if (self.isRegisterUser) {
        [self registerUser];
        self.isRegisterUser = NO;
    } else {
        [self login];
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    NSLog(@"disconnect %@", error);
    [self.delegate serverErrorAuthenticate];
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

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    if ([message isChatMessageWithBody]) {
        NSString *msg = [[message elementForName:@"body"] stringValue];
        NSString *from = [[message attributeForName:@"from"] stringValue];
        from = [[from componentsSeparatedByString:@"/"] objectAtIndex:0];
        
        UserData *userData = [[UserData alloc] init];
        
        userData.userJid = from;
        userData.userName = [[from componentsSeparatedByString:@"@"] objectAtIndex:0];
        userData.lastMessage = msg;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveMessage" object:userData];
        
        if ([self.msdelegate respondsToSelector:@selector(serverDidReceiveMessage:fromUser:)]) {
            [self.msdelegate serverDidReceiveMessage:msg fromUser:from];
        }
        
        if ([self.talkJID isEqualToString:from]) {
//            NSLog(@"%@", message);
            if ([self.msdelegate respondsToSelector:@selector(serverDidReceiveMessageFromTalkUser:)]) {
                [self.msdelegate serverDidReceiveMessageFromTalkUser:msg];
            }
        }
    }
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    
    NSLog(@"%@", iq);
    
    return YES;
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration" message:@"Registration Successful!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    
    DDXMLElement *errorXML = [error elementForName:@"error"];
    NSString *errorCode  = [[errorXML attributeForName:@"code"] stringValue];
    
    NSString *regError = [NSString stringWithFormat:@"ERROR :- %@",error.description];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Failed!" message:regError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    if([errorCode isEqualToString:@"409"]){
        
        [alert setMessage:@"Username Already Exists!"];
    }   
    [alert show];
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Registration"]) {
        [self login];
    }
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
