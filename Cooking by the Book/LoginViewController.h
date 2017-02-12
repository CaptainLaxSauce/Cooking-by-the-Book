//
//  LoginViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 4/25/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface LoginViewController : UIViewController

@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIButton *signupButton;
@property (nonatomic,strong) UITextField *emailTextField;
@property (nonatomic,strong) UITextField *passwordTextField;

@property (copy) CompletionWeb loginCompletion;
@property (copy) CompletionWeb getCookbookCompletion;
@property (copy) CompletionWeb getProfileCompletion;


-(void)loginTouch:(id)sender;
-(void)signupTouch:(id)sender;
-(void)loadInterface;
@end
