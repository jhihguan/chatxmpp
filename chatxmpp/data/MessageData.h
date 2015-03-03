//
//  MessageData.h
//  chatxmpp
//
//  Created by jhihguan on 2015/3/2.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageData : NSObject

@property (strong, nonatomic) NSString *fromUser;
@property (strong, nonatomic) NSString *toUser;
@property (strong, nonatomic) NSString *message;

@end
