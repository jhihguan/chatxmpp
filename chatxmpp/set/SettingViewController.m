//
//  SettingViewController.m
//  chatxmpp
//
//  Created by kuanchih on 2014/11/12.
//  Copyright (c) 2014年 Jhihguan. All rights reserved.
//

#import "SettingViewController.h"
#import "UserLoginViewController.h"

extern NSString *const kXMPPautoLogin;

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SettingViewController


- (IBAction)logoutAction:(id)sender {
    // remove data and switch to login view
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kXMPPautoLogin];
    [[UIApplication sharedApplication].keyWindow setRootViewController:[[UserLoginViewController alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Setting";
    self.logoutButton.backgroundColor = [UIColor redColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
