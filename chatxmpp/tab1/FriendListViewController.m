//
//  FriendListViewController.m
//  chatxmpp
//
//  Created by kuanchih on 2014/11/12.
//  Copyright (c) 2014年 Jhihguan. All rights reserved.
//

#import "FriendListViewController.h"
#import "UserLoginViewController.h"

extern NSString *const kXMPPautoLogin;

@interface FriendListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Friend";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
