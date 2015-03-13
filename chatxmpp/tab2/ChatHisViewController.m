//
//  ChatHisViewController.m
//  chatxmpp
//
//  Created by kuanchih on 2014/11/12.
//  Copyright (c) 2014年 Jhihguan. All rights reserved.
//

#import "ChatHisViewController.h"
#import "FriendDetailViewController.h"
#import "UserData.h"

@interface ChatHisViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (nonatomic, strong) NSMutableArray *chatArray;

@end

@implementation ChatHisViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.chatArray = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChatMessage:) name:@"receiveMessage" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Chat";
    
}

#pragma mark - receive message

- (void)receiveChatMessage:(NSNotification*) notification {
    UserData *data = notification.object;
    NSUInteger sameChatIndex = -1;
    
    for (NSUInteger i = 0; i < [self.chatArray count]; i++) {
        UserData *userData = [self.chatArray objectAtIndex:i];
        if ([userData.userJid isEqualToString:data.userJid]) {
            sameChatIndex = i;
            break;
        }
    }
    if (sameChatIndex == -1) {
        [self.chatArray insertObject:data atIndex:0];
    } else {
        [self.chatArray removeObjectAtIndex:sameChatIndex];
        [self.chatArray insertObject:data atIndex:sameChatIndex];
//        [self.chatArray replaceObjectAtIndex:sameChatIndex withObject:[self.chatArray objectAtIndex:sameChatIndex]];
    }
    [self.chatTableView reloadData];
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserData *userData = [self.chatArray objectAtIndex:indexPath.row];
    
    FriendDetailViewController *detailViewController = [[FriendDetailViewController alloc] init];
    detailViewController.title = userData.userName;
    detailViewController.chatUser = userData;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    //    [self presentViewController:[[FriendDetailViewController alloc] init] animated:NO completion:^{
    //
    //    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserData *userData = [self.chatArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"chatCell"];
    cell.textLabel.text = userData.userName;
    cell.detailTextLabel.text = userData.lastMessage;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - life cycle

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
