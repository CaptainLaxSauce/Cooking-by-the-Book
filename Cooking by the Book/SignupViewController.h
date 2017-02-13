//
//  SignupViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/21/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *emailTextField;
@property (nonatomic,strong) UITextField *passwordTextField1;
@property (nonatomic,strong) UITextField *passwordTextField2;
@property (nonatomic,strong) UIButton *signupButton;
@property (nonatomic,strong) UIButton *backButton;

-(void)loadInterface;
-(void)signupTouch:(id)sender;

@end
