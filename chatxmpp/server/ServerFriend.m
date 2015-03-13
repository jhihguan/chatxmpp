//
//  ServerUser.m
//  chatxmpp
//
//  Created by jhihguan on 2014/11/15.
//  Copyright (c) 2014年 Jhihguan. All rights reserved.
//

#import "ServerFriend.h"
#import "ServerConnect.h"

extern NSString *const kXMPPmyServer;
extern NSString *const kXMPPmyServerName;
@interface ServerFriend ()<XMPPStreamDelegate>

@property (strong, nonatomic) XMPPRoster *xmppRoster;

@end

@implementation ServerFriend

- (instancetype)init {
    self = [super init];
    if (self) {
        _xmppRoster = [[ServerConnect sharedConnect] xmppRoster];
    }
    return self;
}

- (void)addNewFriend:(NSString *)userId {
    NSString *fullUserId = [NSString stringWithFormat:@"%@@%@", userId, kXMPPmyServerName];
//    NSString *fullUserId = [NSString stringWithFormat:@"%@@%@", userId, [[NSUserDefaults standardUserDefaults] valueForKey:kXMPPmyServer]];
    [self.xmppRoster addUser:[XMPPJID jidWithString:fullUserId] withNickname:userId];
}


@end
