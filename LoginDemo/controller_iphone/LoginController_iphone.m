//
//  LoginController_iphone.m
//  LoginDemo
//
//  Created by david on 14-2-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LoginController_iphone.h"

@interface LoginController_iphone ()
@property (weak, nonatomic) IBOutlet UIView *inputBackView;//输入框背景
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIView *checkBoxBackView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPwdButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)forgotPwdButtonClicked:(id)sender;
- (IBAction)registButtonClicked:(id)sender;
- (IBAction)backgroundClicked:(id)sender;

@end

@implementation LoginController_iphone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDOWN:) name: UIKeyboardWillHideNotification object:nil];
	// Do any additional setup after loading the view.
}

#pragma mark keyboard Notification
-(void)keyBoardUP:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.inputBackView.frame = (CGRect){20,20,280,234};
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)keyBoardDOWN:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.inputBackView.frame = (CGRect){20,80,280,234};
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark --

#pragma mark button action
- (IBAction)loginButtonClicked:(id)sender {
    [self.userNameTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
}

- (IBAction)forgotPwdButtonClicked:(id)sender {
}

- (IBAction)registButtonClicked:(id)sender {
}

- (IBAction)backgroundClicked:(id)sender {
    [self.userNameTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
}
#pragma mark --

#pragma mark textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.userNameTextField) {
        NSString *userName = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([userName isEqualToString:@""]) {
            [Tools alertMsg:@"用户名不能为空"];
        }
    }else if (textField == self.pwdTextField) {
        NSString *pwd = [self.pwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return YES;
}
#pragma mark --

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
