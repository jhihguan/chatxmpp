//
//  MessageData.h
//  chatxmpp
//
//  Created by jhihguan on 2015/3/2.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>

@interface MessageData : RLMObject

@property (strong, nonatomic) NSString *fromUser;
@property (strong, nonatomic) NSString *toUser;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *chatUser;
@end
RLM_ARRAY_TYPE(MessageData);