//
//  ServerRoom.h
//  chatxmpp
//
//  Created by jhihguan on 2015/3/4.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerRoomProtocol;
@protocol ServerMessageProtocol;
@interface ServerRoom : NSObject

- (void)userLeaveRoom;
- (void)userJoinRoomWithRoomName:(NSString *)roomName;
- (void)userSendMessageToRoom:(NSString *)message;
@property (strong, nonatomic) id<ServerRoomProtocol> delegate;
@property (strong, nonatomic) id<ServerMessageProtocol> msdelegate;

@end

@protocol ServerRoomProtocol <NSObject>

@optional
- (void)userDidSuccessJoinRoom;

@end
