//
//  ServerRoom.m
//  chatxmpp
//
//  Created by jhihguan on 2015/3/4.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "ServerRoom.h"
#import "ServerConnect.h"
#import "XMPPFramework.h"
#import "XMPPRoom.h"
#import "XMPPMessage+XEP0045.h"
#import "MessageData.h"

extern NSString *const kXMPPmyServerName;
extern NSString *const kXMPPmyJID;
@interface ServerRoom ()<XMPPRoomDelegate>

@property (nonatomic, strong) XMPPRoom *xmppRoom;
@property (nonatomic, strong) NSString *roomID;
//@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation ServerRoom

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.messageArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)userJoinRoomWithRoomName:(NSString *)roomName {
    XMPPRoomCoreDataStorage *roomStorage = [XMPPRoomCoreDataStorage sharedInstance];
//    self.roomID = [NSString stringWithFormat:@"%@@conference.%@", roomName, kXMPPmyServerName];
    self.roomID = [NSString stringWithFormat:@"%@@myroom.%@", roomName, kXMPPmyServerName];
    self.xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomStorage jid:[XMPPJID jidWithString:self.roomID]];
    [self.xmppRoom activate:[ServerConnect sharedConnect].xmppStream];
    [self.xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self.xmppRoom joinRoomUsingNickname:[[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID] history:nil];
}

- (void)userLeaveRoom {
    [self.xmppRoom leaveRoom];
}

- (void)userSendMessageToRoom:(NSString *)message {
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message];
    
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
    
    NSLog(@"%@", self.xmppRoom.roomJID);
    
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:self.roomID];
    
    //由谁发送
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@/%@",self.roomID,[defaults stringForKey:kXMPPmyJID]]];
    
    //组合
    [mes addChild:body];
    
    NSLog(@"%@", mes);
    //发送消息
    [[[ServerConnect sharedConnect] xmppStream] sendElement:mes];
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender {
    NSLog(@"join room!");
    [self.delegate userDidSuccessJoinRoom];
}

- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID {
    
//    NSLog(@"%@", message);
//    NSLog(@"%@", occupantJID);
    
    if ([message isGroupChatMessageWithBody]) {
//        NSLog(@"%@:%@", occupantJID.user, [message stringValue]);
        
        NSString *msg = [[message elementForName:@"body"] stringValue];
//            NSString *timexx = [[timex attributeForName:@"stamp"] stringValue];
        NSString *from = [[message attributeForName:@"from"] stringValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:msg forKey:@"body"];
        [dict setObject:from forKey:@"from"];
        
        MessageData *messageData = [[MessageData alloc] init];
        messageData.message = msg;
        messageData.fromUser = from;
        messageData.toUser = @"me";
        messageData.chatUser = [[from componentsSeparatedByString:@"/"] objectAtIndex:1];
        
        if ([self.msdelegate respondsToSelector:@selector(serverDidReceiveMessageData:)]) {
            [self.msdelegate serverDidReceiveMessageData:messageData];
        }

        
//        NSLog(@"%@", dict);
        
    }
    
    
}

@end
