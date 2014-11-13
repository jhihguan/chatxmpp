//
//  MainTabBarViewController.m
//  chatxmpp
//
//  Created by kuanchih on 2014/11/13.
//  Copyright (c) 2014年 Jhihguan. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "FriendListViewController.h"
#import "ChatHisViewController.h"
#import "SettingViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
        FriendListViewController *friendListViewControoler = [[FriendListViewController alloc] init];
        UINavigationController *navBar1 = [[UINavigationController alloc] initWithRootViewController:friendListViewControoler];
        navBar1.title = @"Friend";
        
        ChatHisViewController *chatHisViewController = [[ChatHisViewController alloc] init];
        UINavigationController *navBar2 = [[UINavigationController alloc] initWithRootViewController:chatHisViewController];
        navBar2.title = @"Chat";
        
        SettingViewController *settingViewController = [[SettingViewController alloc] init];
        UINavigationController *navBar3 = [[UINavigationController alloc] initWithRootViewController:settingViewController];
        navBar3.title = @"Setting";
        
        NSArray *tabViewController = [NSArray arrayWithObjects:navBar1, navBar2, navBar3, nil];
        
        self.viewControllers = tabViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
