//
//  FriendDetailViewController.h
//  chatxmpp
//
//  Created by jhihguan on 2014/11/15.
//  Copyright (c) 2014年 Jhihguan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"

@interface FriendDetailViewController : UIViewController

@property (strong, nonatomic) XMPPUserCoreDataStorageObject *toUser;

@end
