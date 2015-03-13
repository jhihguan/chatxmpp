//
//  GroupChatViewController.m
//  chatxmpp
//
//  Created by jhihguan on 2015/3/5.
//  Copyright (c) 2015年 Jhihguan. All rights reserved.
//

#import "GroupChatViewController.h"
#import "ServerConnect.h"
#import "MessageData.h"
#import "UserData.h"
#import "ServerRoom.h"

@interface GroupChatViewController ()<UITableViewDataSource, UITableViewDelegate, ServerMessageProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property BOOL isMessageTyped;
@property CGFloat keyboardInset;
@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong, nonatomic) ServerConnect *serverConnect;
@end

@implementation GroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.isMessageTyped = YES;
    [self registerForKeyboardNotifications];
    self.serverRoom.msdelegate = self;
    self.messageArray = [[NSMutableArray alloc] init];
}

#pragma mark - room message

- (IBAction)sendMessageAction:(id)sender {
    
    NSString *message = self.messageTextView.text;
//    [self.sendtextfield resignFirstResponder];
    
    if (message.length > 0){
        self.messageTextView.text = @"";
//        MessageData *messageData = [[MessageData alloc] init];
//        messageData.message = message;
//        messageData.toUser = self.chatUser.userJid;
//        messageData.fromUser = @"me";
//        messageData.chatUser = self.chatUser.userJid;
//        [self.messageArray addObject:messageData];
        [self.serverRoom userSendMessageToRoom:message];
        [self.tableView reloadData];
    }
    
//    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//    [body setStringValue:self.messageTextView.text];
//    
//    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
//    [message addAttributeWithName:@"type" stringValue:@"chat"];
//    [message addAttributeWithName:@"to" stringValue:self.chatUser.userJid];
//    [message addChild:body];
//    
//    [self.serverConnect.xmppStream sendElement:message];
//    MessageData *messageData = [[MessageData alloc] init];
//    messageData.message = self.messageTextView.text;
//    messageData.toUser = self.chatUser.userJid;
//    messageData.fromUser = @"me";
//    messageData.chatUser = self.chatUser.userJid;
//    self.chatUser.lastMessage = messageData.message;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveMessage" object:self.chatUser];
//    [self.messageArray addObject:messageData];
//    self.messageTextView.text = @"";
//    //    [self.messageTextView resignFirstResponder];
//    [self.tableView reloadData];
}

- (void)serverDidReceiveMessageData:(MessageData *)messageData {
    [self.messageArray addObject:messageData];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"messageCell"];
    
    NSUInteger index = indexPath.row;
    MessageData *data = [self.messageArray objectAtIndex:index];
    if ([data.fromUser isEqualToString:@"me"]) {
        tableViewCell.textLabel.textAlignment = NSTextAlignmentRight;
        tableViewCell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    } else {
        tableViewCell.textLabel.textAlignment = NSTextAlignmentLeft;
        tableViewCell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    }
    tableViewCell.textLabel.text = data.message;
    tableViewCell.detailTextLabel.text = data.chatUser;
    return tableViewCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.isMessageTyped) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        self.isMessageTyped = NO;
    }
    return YES;
}

- (void) textViewDidEndEditing:(UITextView*)textView {
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"message";
        self.isMessageTyped = YES;
    }
}

#pragma mark - keyboard dismiss

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (self.keyboardInset == 0) {
        CGRect textFrame = self.messageTextView.frame;
        CGRect tableFrame = self.tableView.frame;
        CGRect sendFrame = self.sendButton.frame;
        
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGFloat tabbarHeight = self.tabBarController.tabBar.frame.size.height;
        ;
        self.keyboardInset = tabbarHeight - kbSize.height;
        
        textFrame.origin = CGPointMake(textFrame.origin.x, textFrame.origin.y + self.keyboardInset);
        sendFrame.origin = CGPointMake(sendFrame.origin.x, sendFrame.origin.y + self.keyboardInset);
        tableFrame.size = CGSizeMake(tableFrame.size.width, tableFrame.size.height + self.keyboardInset);
        self.messageTextView.frame = textFrame;
        self.sendButton.frame = sendFrame;
        self.tableView.frame = tableFrame;
    }
    //    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    //    scrollView.contentInset = contentInsets;
    //    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    //    CGRect aRect = self.view.frame;
    //    aRect.size.height -= kbSize.height;
    //    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
    //        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
    //        [scrollView setContentOffset:scrollPoint animated:YES];
    //    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (self.keyboardInset != 0) {
        CGRect textFrame = self.messageTextView.frame;
        CGRect tableFrame = self.tableView.frame;
        CGRect sendFrame = self.sendButton.frame;
        textFrame.origin = CGPointMake(textFrame.origin.x, textFrame.origin.y - self.keyboardInset);
        sendFrame.origin = CGPointMake(sendFrame.origin.x, sendFrame.origin.y - self.keyboardInset);
        tableFrame.size = CGSizeMake(tableFrame.size.width, tableFrame.size.height - self.keyboardInset);
        self.messageTextView.frame = textFrame;
        self.sendButton.frame = sendFrame;
        self.tableView.frame = tableFrame;
        self.keyboardInset = 0;
    }
    //    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    //    scrollView.contentInset = contentInsets;
    //    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.serverRoom userLeaveRoom];
    self.serverRoom = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
