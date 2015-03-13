//
//  UserData.h
//  chatxmpp
//
//  Created by jhihguan on 2015/3/3.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>

@interface UserData : RLMObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userJid;
@property (nonatomic, strong) NSString *lastMessage;
@end
RLM_ARRAY_TYPE(UserData);
