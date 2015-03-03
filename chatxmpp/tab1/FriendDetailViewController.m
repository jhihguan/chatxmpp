//
//  FriendDetailViewController.m
//  chatxmpp
//
//  Created by jhihguan on 2014/11/15.
//  Copyright (c) 2014年 Jhihguan. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "ServerConnect.h"
#import "MessageData.h"

@interface FriendDetailViewController ()<UITextViewDelegate, ServerMessageProtocol, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property BOOL isMessageTyped;
@property CGFloat keyboardInset;
@property (strong, nonatomic) NSMutableArray *messageArray;

@property (strong, nonatomic) ServerConnect *serverConnect;
@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.isMessageTyped = YES;
    [self registerForKeyboardNotifications];
    
    self.serverConnect = [ServerConnect sharedConnect];
    self.serverConnect.talkJID = self.toUser.jidStr;
    self.serverConnect.msdelegate = self;
    self.messageArray = [[NSMutableArray alloc] init];
    NSLog(@"%@", self.toUser.jidStr);
}

- (IBAction)sendMessageAction:(id)sender {
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:self.messageTextView.text];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:self.toUser.jidStr];
    [message addChild:body];
    
    [self.serverConnect.xmppStream sendElement:message];
    MessageData *messageData = [[MessageData alloc] init];
    messageData.message = self.messageTextView.text;
    messageData.toUser = self.toUser.jidStr;
    messageData.fromUser = @"me";
    [self.messageArray addObject:messageData];
    self.messageTextView.text = @"";
//    [self.messageTextView resignFirstResponder];
    [self.tableView reloadData];

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

#pragma mark - receive message delegate

- (void)serverDidReceiveMessageFromTalkUser:(NSString *)message {
    MessageData *messageData = [[MessageData alloc] init];
    messageData.message = message;
    messageData.fromUser = self.toUser.jidStr;
    messageData.toUser = @"me";
    [self.messageArray addObject:messageData];
    [self.tableView reloadData];
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
    
    NSUInteger index = indexPath.row;
    MessageData *data = [self.messageArray objectAtIndex:index];
    if ([data.fromUser isEqualToString:@"me"]) {
        tableViewCell.textLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        tableViewCell.textLabel.textAlignment = NSTextAlignmentRight;
    }
    tableViewCell.textLabel.text = data.message;
    return tableViewCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
    CGRect textFrame = self.messageTextView.frame;
    CGRect tableFrame = self.tableView.frame;
    CGRect sendFrame = self.sendButton.frame;
    if (self.keyboardInset == 0) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGFloat tabbarHeight = self.tabBarController.tabBar.frame.size.height;
        ;
        self.keyboardInset = tabbarHeight - kbSize.height;
    }
    textFrame.origin = CGPointMake(textFrame.origin.x, textFrame.origin.y + self.keyboardInset);
    sendFrame.origin = CGPointMake(sendFrame.origin.x, sendFrame.origin.y + self.keyboardInset);
    tableFrame.size = CGSizeMake(tableFrame.size.width, tableFrame.size.height + self.keyboardInset);
    self.messageTextView.frame = textFrame;
    self.sendButton.frame = sendFrame;
    self.tableView.frame = tableFrame;
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
    CGRect textFrame = self.messageTextView.frame;
    CGRect tableFrame = self.tableView.frame;
    CGRect sendFrame = self.sendButton.frame;
    textFrame.origin = CGPointMake(textFrame.origin.x, textFrame.origin.y - self.keyboardInset);
    sendFrame.origin = CGPointMake(sendFrame.origin.x, sendFrame.origin.y - self.keyboardInset);
    tableFrame.size = CGSizeMake(tableFrame.size.width, tableFrame.size.height - self.keyboardInset);
    self.messageTextView.frame = textFrame;
    self.sendButton.frame = sendFrame;
    self.tableView.frame = tableFrame;
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.serverConnect.msdelegate = nil;
    self.serverConnect = nil;
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
