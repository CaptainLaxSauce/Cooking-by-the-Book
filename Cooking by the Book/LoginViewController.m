//
//  LoginViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 4/25/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//


#import "LoginViewController.h"
#import "Helper.h"
#import "UIColor+CustomColors.h"
#import "SignupViewController.h"
#import "DataClass.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

static int objectBreak = 8;
static int cornerRadius = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadInterface];
    
}

- (void) loginTouch:(id)sender{
    
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@",self.emailTextField.text,self.passwordTextField.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"login"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        
        NSString *ret_ = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",ret_);
        if ([ret_ intValue] > 0) {
            
            DataClass *obj = [DataClass getInstance];
            obj.userId = ret_;
            NSLog(@"Success! userID = %@",obj.userId);
            dispatch_async(dispatch_get_main_queue(), ^(void){
               [self performSegueWithIdentifier:@"TabBarViewController" sender:sender];
            });
            
        }
        
        else{
            dispatch_async(dispatch_get_main_queue(), ^(void){
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Invalid Login"
                                        message:[NSString stringWithFormat:@"%@\r%@",@"The username or password you entered was incorrect.",@"Please try again."]
                                        preferredStyle:UIAlertControllerStyleAlert];
             
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            self.passwordTextField.text = [NSString stringWithFormat:@""];
                
            });
        }
    }];
    
    [dataTask resume];

}
    
//    if ([self.emailTextField.text rangeOfString:@"@"].location == NSNotFound){


- (void) signupTouch:(id)sender{
    
    [self performSegueWithIdentifier:@"SignupViewController" sender:sender];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SignupViewController"]){
        SignupViewController *controller;
        controller = [segue destinationViewController];
        controller.emailTextField = self.emailTextField;
        controller.passwordTextField1 = self.passwordTextField;

    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)loadInterface{
 
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    int buttonWidth = (screenWidth-objectBreak*3)/2;
    int textFieldWidth = (screenWidth-objectBreak*2);
    int textHeight = screenHeight/20;
    
    self.view.backgroundColor = [UIColor primaryColor];
    
    //create text fields
    UITextField *emailTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, screenHeight/2-objectBreak*2-textHeight*2, textFieldWidth, textHeight)];
    emailTextField_.backgroundColor = [UIColor whiteColor];
    emailTextField_.placeholder = @"Email";
    emailTextField_.layer.cornerRadius = cornerRadius;
    emailTextField_.clipsToBounds = YES;
    emailTextField_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [emailTextField_ setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.view addSubview:emailTextField_];
    self.emailTextField = emailTextField_;
    
    UITextField *passwordTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, screenHeight/2-objectBreak-textHeight, textFieldWidth, textHeight)];
    passwordTextField_.backgroundColor = [UIColor whiteColor];
    passwordTextField_.placeholder = @"Password";
    passwordTextField_.layer.cornerRadius = cornerRadius;
    passwordTextField_.clipsToBounds = YES;
    passwordTextField_.secureTextEntry = YES;
    passwordTextField_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:passwordTextField_];
    self.passwordTextField = passwordTextField_;
    
    //create buttons
    UIButton *signupButton_ = [[UIButton alloc]init];
    signupButton_.frame = CGRectMake(objectBreak, screenHeight/2, buttonWidth, screenHeight/20);
    [signupButton_ addTarget:self action:@selector(signupTouch:) forControlEvents:UIControlEventTouchUpInside];
    [signupButton_ setTitle:@"Sign Up" forState:UIControlStateNormal];
    signupButton_.backgroundColor = [UIColor secondaryColor];
    signupButton_.layer.cornerRadius = cornerRadius;
    signupButton_.clipsToBounds = YES;
    [self.view addSubview:signupButton_];
    self.signupButton = signupButton_;
    
    UIButton *loginButton_ = [[UIButton alloc]init];
    loginButton_.frame = CGRectMake(buttonWidth+objectBreak*2, screenHeight/2, buttonWidth, screenHeight/20);
    [loginButton_ addTarget:self action:@selector(loginTouch:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton_ setTitle:@"Login" forState:UIControlStateNormal];
    loginButton_.backgroundColor = [UIColor secondaryColor];
    loginButton_.layer.cornerRadius = cornerRadius;
    loginButton_.clipsToBounds = YES;
    [self.view addSubview:loginButton_];
    self.loginButton = loginButton_;
    
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
