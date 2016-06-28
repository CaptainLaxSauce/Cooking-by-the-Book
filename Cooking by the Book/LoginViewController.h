//
//  LoginViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 4/25/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIButton *signupButton;
@property (nonatomic,strong) UITextField *emailTextField;
@property (nonatomic,strong) UITextField *passwordTextField;
@property (nonatomic,strong) NSString *ret;

-(void)loginTouch:(id)sender;
-(void)signupTouch:(id)sender;
-(void)loadInterface;
@end
