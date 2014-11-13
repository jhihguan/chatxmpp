//
//  UserLoginViewController.m
//  chatxmpp
//
//  Created by kuanchih on 2014/11/13.
//  Copyright (c) 2014年 Jhihguan. All rights reserved.
//

#import "UserLoginViewController.h"
#import "MainTabBarViewController.h"
#import "ServerConnect.h"


extern NSString *const kXMPPautoLogin;
extern NSString *const kXMPPmyJID;
extern NSString *const kXMPPmyPassword;
extern NSString *const kXMPPmyServer;

@interface UserLoginViewController ()<ServerConnectProtocol>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *serverTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) ServerConnect *serverConnect;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.backgroundColor = [UIColor blueColor];
    self.serverConnect = [ServerConnect sharedConnect];
    self.serverConnect.delegate = self;
    [self.serverConnect setupStream];
    
}

- (void)serverDidFinishAuthenticate {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kXMPPautoLogin];
    [[UIApplication sharedApplication].keyWindow setRootViewController:[[MainTabBarViewController alloc] init]];
}

- (void)serverErrorAuthenticate {
    NSLog(@"authenticate error");
}

- (IBAction)loginAction:(id)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:self.accountTextField.text forKey:kXMPPmyJID];
    [userDefaults setValue:self.passwordTextField.text forKey:kXMPPmyPassword];
    [userDefaults setValue:self.serverTextField.text forKey:kXMPPmyServer];
    
    if (![self.serverConnect connect]) {
        NSLog(@"connect error");
    }
    
    
    // change root view if login success
    
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
