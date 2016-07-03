//
//  SignupViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/21/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "SignupViewController.h"
#import "LoginViewController.h"
#import "UIColor+CustomColors.h"
#import "Helper.h"
#import "DataClass.h"



@implementation SignupViewController

static int objectBreak = 8;
static int cornerRadius = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadInterface];
}

-(void)signupTouch:(id)sender{
    
    //validate email and password meet requirements
    
    NSLog(@"%@",self.nameTextField.text);
    
    NSString *post = [NSString stringWithFormat:@"name=%@&email=%@&password=%@",self.nameTextField.text,self.emailTextField.text,self.passwordTextField2.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"signup"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSString *ret_ = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        if ([ret_ intValue] > 0) {
            DataClass *obj = [DataClass getInstance];
            obj.userId = ret_;
            //transition to home screen
            
        }
        else {
            
        }

        
    }];
    [dataTask resume];
    
}

-(void)backTouch:(id)sender{
    [self performSegueWithIdentifier:@"LoginViewController" sender:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField1 resignFirstResponder];
    [self.passwordTextField2 resignFirstResponder];
}

-(void)loadInterface{
    
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    int buttonWidth = (screenWidth-objectBreak*3)/2;
    int textFieldWidth = (screenWidth-objectBreak*2);
    int textHeight = screenHeight/20;
    
    self.view.backgroundColor = [UIColor primaryColor];
    
    //create text fields
    UITextField *nameTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, screenHeight/2-objectBreak*4-textHeight*4, textFieldWidth, textHeight)];
    nameTextField_.backgroundColor = [UIColor whiteColor];
    nameTextField_.placeholder = @"Name";
    nameTextField_.layer.cornerRadius = cornerRadius;
    nameTextField_.clipsToBounds = YES;
    nameTextField_.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self.view addSubview:nameTextField_];
    self.nameTextField = nameTextField_;
    
    UITextField *emailTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, screenHeight/2-objectBreak*3-textHeight*3, textFieldWidth, textHeight)];
    emailTextField_.backgroundColor = [UIColor whiteColor];
    emailTextField_.placeholder = @"Email";
    emailTextField_.layer.cornerRadius = cornerRadius;
    emailTextField_.clipsToBounds = YES;
    emailTextField_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [emailTextField_ setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.view addSubview:emailTextField_];
    self.emailTextField = emailTextField_;
    
    UITextField *passwordTextField1_ = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, screenHeight/2-objectBreak*2-textHeight*2, textFieldWidth, textHeight)];
    passwordTextField1_.backgroundColor = [UIColor whiteColor];
    passwordTextField1_.placeholder = @"Password";
    passwordTextField1_.layer.cornerRadius = cornerRadius;
    passwordTextField1_.clipsToBounds = YES;
    passwordTextField1_.secureTextEntry = YES;
    passwordTextField1_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:passwordTextField1_];
    self.passwordTextField1 = passwordTextField1_;
    
    UITextField *passwordTextField2_ = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, screenHeight/2-objectBreak-textHeight, textFieldWidth, textHeight)];
    passwordTextField2_.backgroundColor = [UIColor whiteColor];
    passwordTextField2_.placeholder = @"Confirm password";
    passwordTextField2_.layer.cornerRadius = cornerRadius;
    passwordTextField2_.clipsToBounds = YES;
    passwordTextField2_.secureTextEntry = YES;
    passwordTextField2_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:passwordTextField2_];
    self.passwordTextField2 = passwordTextField2_;
    
    //create buttons
    UIButton *backButton_ = [[UIButton alloc]init];
    backButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton_.frame = CGRectMake(objectBreak, objectBreak*3, screenWidth/15, screenWidth/15);
    [backButton_ addTarget:self action:@selector(backTouch:) forControlEvents:UIControlEventTouchUpInside];
    [backButton_ setTitle:@"Back" forState:UIControlStateNormal];
    backButton_.backgroundColor = [UIColor secondaryColor];
    backButton_.layer.cornerRadius = cornerRadius;
    backButton_.clipsToBounds = YES;
    [self.view addSubview:backButton_];
    self.backButton = backButton_;
    
    UIButton *signupButton_ = [[UIButton alloc]init];
    signupButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    signupButton_.frame = CGRectMake(screenWidth/2-buttonWidth/2, screenHeight/2, buttonWidth, screenHeight/20);
    [signupButton_ addTarget:self action:@selector(signupTouch:) forControlEvents:UIControlEventTouchUpInside];
    [signupButton_ setTitle:@"Sign Up" forState:UIControlStateNormal];
    signupButton_.backgroundColor = [UIColor secondaryColor];
    signupButton_.layer.cornerRadius = cornerRadius;
    signupButton_.clipsToBounds = YES;
    [self.view addSubview:signupButton_];
    self.signupButton = signupButton_;
}



@end
