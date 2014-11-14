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
#import "ServerUtil.h"


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
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

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
    [self.activityIndicator stopAnimating];
    // change root view if login success
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kXMPPautoLogin];
    [[UIApplication sharedApplication].keyWindow setRootViewController:[[MainTabBarViewController alloc] init]];
}

- (void)serverErrorAuthenticate {
    [self.activityIndicator stopAnimating];
    NSLog(@"authenticate error");
}

- (void)serverConnectionTimeout {
    [self.activityIndicator stopAnimating];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Response" message:@"Please check your network or server address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

- (IBAction)loginAction:(id)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *account = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *server = self.serverTextField.text;
    NSString *errorMessage = @"";
    
    //check textfield format
    if ([account isEqualToString:@""]) {
        errorMessage = [NSString stringWithFormat:@"%@\naccount can't blank", errorMessage];
    }
    if ([password isEqualToString:@""]) {
        errorMessage = [NSString stringWithFormat:@"%@\npasswork can't blank", errorMessage];
    }
    if ([server isEqualToString:@""]) {
        errorMessage = [NSString stringWithFormat:@"%@\nserver can't blank", errorMessage];
    } else if (![ServerUtil validateUrl:server]) {
        errorMessage = [NSString stringWithFormat:@"%@\nserver format error", errorMessage];
    }
    
    if (![errorMessage isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Requirement" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else {
    
        [userDefaults setValue:self.accountTextField.text forKey:kXMPPmyJID];
        [userDefaults setValue:self.passwordTextField.text forKey:kXMPPmyPassword];
        [userDefaults setValue:self.serverTextField.text forKey:kXMPPmyServer];
        
        if (![self.serverConnect connect]) {
            NSLog(@"connect error");
            [self serverConnectionTimeout];
        } else {
            [self.activityIndicator startAnimating];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIActivityIndicatorView *)activityIndicator {
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.center=self.view.center;
        
//        [activityView startAnimating];
//        self.activityView = activityView;
//        _activityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75);
        _activityIndicator.hidesWhenStopped = YES;
        [self.view addSubview:_activityIndicator];
    }
    return _activityIndicator;
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
