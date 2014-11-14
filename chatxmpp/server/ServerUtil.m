//
//  ServerUtil.m
//  chatxmpp
//
//  Created by kuanchih on 2014/11/14.
//  Copyright (c) 2014年 Jhihguan. All rights reserved.
//

#import "ServerUtil.h"

@implementation ServerUtil

+ (BOOL)validateUrl: (NSString *)url {
    NSString *urlRegEx =
    @"((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:url];
    
}

@end
