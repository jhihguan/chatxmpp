//
//  FriendListViewController.m
//  chatxmpp
//
//  Created by kuanchih on 2014/11/12.
//  Copyright (c) 2014年 Jhihguan. All rights reserved.
//

#import "FriendListViewController.h"
#import "UserLoginViewController.h"
#import "ServerConnect.h"
#import "ServerRosterFetch.h"

extern NSString *const kXMPPautoLogin;

@interface FriendListViewController ()<ServerConnectProtocol, ServerRosterProtocol, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (strong, nonatomic) ServerConnect *serverConnect;
@property (strong, nonatomic) ServerRosterFetch *serverRoster;
@property (strong, nonatomic) NSMutableArray *friendArray;

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Friend";
    
    self.friendArray = [[NSMutableArray alloc] init];
    
    [self setupServer];
}

#pragma mark - setup

- (void)setupServer {
    // setup server connect
    self.serverConnect = [ServerConnect sharedConnect];
    self.serverConnect.delegate = self;
    self.serverRoster = [[ServerRosterFetch alloc] init];
    self.serverRoster.delegate = self;
    
    if (self.serverConnect.isXmppConnected) {
        [self.serverRoster setupFetchRosterController];
    } else {
        [self.serverConnect setupStream];
        [self.serverConnect connect];
    }
}

#pragma mark - server delegate

- (void)serverDidFinishAuthenticate {
    NSLog(@"is connecting to server");
    // start fetching friend
    [self.serverRoster setupFetchRosterController];
}

- (void)serverDidFinishFetchRosters:(NSArray *)users sections:(NSArray *)sections {
    [self.friendArray removeAllObjects];
    [self.friendArray addObjectsFromArray:users];
    [self.friendTableView reloadData];
}

#pragma mark - tableview delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    NSUInteger index = indexPath.row;
    XMPPUserCoreDataStorageObject *userObject = [self.friendArray objectAtIndex:index];
    tableViewCell.textLabel.text = userObject.displayName;
    
    return tableViewCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friendArray count];
}

#pragma mark - life cycle

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
