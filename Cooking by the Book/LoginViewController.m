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

@implementation LoginViewController {
    UIActivityIndicatorView *activityView;
    DataClass *obj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    
}

-(CompletionWeb) getLoginCompletion {
    CompletionWeb loginCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSString *userId = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        [Helper stopActivityViewAsync:activityView withViewController:self];
        
        if ([userId intValue] > 0) {
            
            obj.userId = userId;
            NSLog(@"Success! userID = %@",obj.userId);
            
            [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"userID=%@",userId] withURLEnd:@"getCookbook" withCompletionHandler:[self getCookbookCompletion]];
            
            [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"userID=%@",userId] withURLEnd:@"getProfile" withCompletionHandler:[self getProfileCompletion]];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier:@"TabBarViewController" sender:self];
            });
            
        }
        
        else{

            [Helper postUnsuccessfulAlertAsyncOK:@"Invalid Login"
                                     withMessage:[NSString stringWithFormat:@"%@\r%@",@"The username or password you entered was incorrect.",@"Please try again."]
                              withViewController:self];
            
        }
    };
    
    return loginCompletion;
}

-(CompletionWeb) getCookbookCompletion {
    CompletionWeb getCookbookCompetion = ^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonCookbookDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSArray *jsonCookbookAry = [jsonCookbookDict objectForKey:@"recipeInfo"];
        [obj initCookbookAry:jsonCookbookAry];
    };
    
    return getCookbookCompetion;
}

-(CompletionWeb) getProfileCompletion {
    CompletionWeb profileCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
        NSDictionary *jsonProfileDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        [obj initProfile:jsonProfileDict];
    };
    
    return profileCompletion;
}

- (void) loginTouch:(id)sender{
    activityView = [Helper startActivityView:self];
    
    NSString *loginCreds = [NSString stringWithFormat:@"email=%@&password=%@",self.emailTextField.text,self.passwordTextField.text];
    [Helper submitHTTPPostWithString:loginCreds withURLEnd:@"login" withCompletionHandler:[self getLoginCompletion]];

}
    
//    if ([self.emailTextField.text rangeOfString:@"@"].location == NSNotFound){


- (void) signupTouch:(id)sender{
    [self performSegueWithIdentifier:@"SignupViewController" sender:sender];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SignupViewController"]){
        SignupViewController *controller = (SignupViewController *)segue.destinationViewController;
        controller.emailTextField = self.emailTextField;
        controller.passwordTextField1 = self.passwordTextField;

    }
    else {

    }

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)loadInterface{
 
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    int buttonWidth = (screenWidth-OBJECT_BREAK*3)/2;
    int textFieldWidth = (screenWidth-OBJECT_BREAK*2);
    int textHeight = screenHeight/20;
    
    self.view.backgroundColor = [UIColor primaryColor];
    self.navigationItem.title = @"Login";
    
    obj = [DataClass getInstance];
    
    //create text fields
    UITextField *emailTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(OBJECT_BREAK, screenHeight/2-OBJECT_BREAK*2-textHeight*2, textFieldWidth, textHeight)];
    emailTextField_.backgroundColor = [UIColor whiteColor];
    emailTextField_.placeholder = @"Email";
    emailTextField_.layer.cornerRadius = CORNER_RADIUS;
    emailTextField_.clipsToBounds = YES;
    emailTextField_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [emailTextField_ setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.view addSubview:emailTextField_];
    self.emailTextField = emailTextField_;
    
    UITextField *passwordTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(OBJECT_BREAK, screenHeight/2-OBJECT_BREAK-textHeight, textFieldWidth, textHeight)];
    passwordTextField_.backgroundColor = [UIColor whiteColor];
    passwordTextField_.placeholder = @"Password";
    passwordTextField_.layer.cornerRadius = CORNER_RADIUS;
    passwordTextField_.clipsToBounds = YES;
    passwordTextField_.secureTextEntry = YES;
    passwordTextField_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:passwordTextField_];
    self.passwordTextField = passwordTextField_;
    
    //create buttons
    UIButton *signupButton_ = [[UIButton alloc]init];
    signupButton_.frame = CGRectMake(OBJECT_BREAK, screenHeight/2, buttonWidth, screenHeight/10);
    [signupButton_ addTarget:self action:@selector(signupTouch:) forControlEvents:UIControlEventTouchUpInside];
    [signupButton_ setTitle:@"Sign Up" forState:UIControlStateNormal];
    signupButton_.backgroundColor = [UIColor secondaryColor];
    signupButton_.layer.cornerRadius = CORNER_RADIUS;
    signupButton_.clipsToBounds = YES;
    [self.view addSubview:signupButton_];
    self.signupButton = signupButton_;
    
    UIButton *loginButton_ = [[UIButton alloc]init];
    loginButton_.frame = CGRectMake(buttonWidth+OBJECT_BREAK*2, screenHeight/2, buttonWidth, screenHeight/10);
    [loginButton_ addTarget:self action:@selector(loginTouch:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton_ setTitle:@"Login" forState:UIControlStateNormal];
    loginButton_.backgroundColor = [UIColor secondaryColor];
    loginButton_.layer.cornerRadius = CORNER_RADIUS;
    loginButton_.clipsToBounds = YES;
    [self.view addSubview:loginButton_];
    self.loginButton = loginButton_;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
