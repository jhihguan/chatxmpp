//
//  ServerText.m
//  chatxmpp
//
//  Created by kuanchih on 2014/11/13.
//  Copyright (c) 2014年 Jhihguan. All rights reserved.
//

#import "ServerMessage.h"
#import "ServerConnect.h"
#import "XMPPFramework.h"

NSString *const kXMPPautoLogin = @"kXMPPautoLogin";
NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";
NSString *const kXMPPmyServer = @"kXMPPmyServer";

@interface ServerMessage ()<ServerConnectProtocol>

@property (strong, nonatomic) XMPPStream *xmppStream;

@end

@implementation ServerMessage

- (instancetype)init {
    self = [super init];
    if (self) {
        _xmppStream = [ServerConnect sharedConnect].xmppStream;
        [ServerConnect sharedConnect].delegate = self;
    }
    return self;
}



@end
