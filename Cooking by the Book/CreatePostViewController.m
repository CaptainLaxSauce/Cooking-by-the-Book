//
//  CreatePostViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 1/8/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "CreatePostViewController.h"
#import "DataClass.h"
#import "UICookbookRecipeCell.h"
#import "UIColor+CustomColors.h"
#import "Helper.h"
#import "AppDelegate.h"

@interface CreatePostViewController ()

@end

@implementation CreatePostViewController

DataClass *obj;
UITextField *titleField;
UITextView *descField;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    // Do any additional setup after loading the view.
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

-(void)dismissKeyboard
{
    [descField resignFirstResponder];
    [titleField resignFirstResponder];
}

- (void) submitPostTouch:(id)sender {
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview: activityView];
    activityView.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [activityView startAnimating];
    self.view.userInteractionEnabled = FALSE;
    self.navigationController.view.userInteractionEnabled = FALSE;
    self.tabBarController.view.userInteractionEnabled = FALSE;
    
    NSDictionary *postDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              obj.userId, @"creatorID",
                              obj.userId, @"wallUserID",
                              titleField.text, @"postTitle",
                              obj.currDetailedRecipeId, @"recipeID",
                              descField.text, @"postBody",
                              [Helper toUTC:[NSDate date]], @"postDateTime",
                              nil];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [NSString stringWithFormat:@"post=%@",jsonStr];
    NSData *postData = [jsonStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"addPost"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [activityView stopAnimating];
            self.view.userInteractionEnabled = TRUE;
            self.navigationController.view.userInteractionEnabled = TRUE;
            self.tabBarController.view.userInteractionEnabled = TRUE;
            
        });

        NSString *postID = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"Post ID = %@",postID);
        //successful post
        if ([postID intValue] > 0){
            NSLog(@"Successful post");
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                [[self navigationController] popViewControllerAnimated:NO];
                [self.tabBarController setSelectedIndex:1];
                
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Post Unsuccessful"
                                            message:@"Please try again."
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

            });
        }
        
    }];
    [dataTask resume];
}
                                     

    
    //[self performSegueWithIdentifier:@"CreatePostViewController" sender:sender];
    

- (void) loadInterface {
    int objectBreak=8;
    int cornerRadius=3;
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    int objectWidth = screenWidth - objectBreak*2;
    int recipeCellHeight = objectWidth/4;
    int tagBoxHeight = (objectWidth/2-objectBreak*2)*3/5;
    int textHeight = screenHeight/20;
    int ingLabelStart = objectBreak*6 + objectWidth/2 + textHeight*3;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    int navBarHeight = self.navigationController.navigationBar.frame.size.height;
    int tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    int scrollHeight = screenHeight-statusBarHeight-navBarHeight-textHeight-objectBreak*2-tabBarHeight;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    obj = [DataClass getInstance];
    Recipe *recipe = [obj getRecipe:obj.currDetailedRecipeId];
    self.navigationItem.title = [NSString stringWithFormat:@"Create Post"];
    self.view.backgroundColor = [UIColor primaryColor];
    
    titleField = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, statusBarHeight + navBarHeight + objectBreak, objectWidth, textHeight)];
    titleField.text = [NSString stringWithFormat:@"%@ cooked %@!", [obj.profileDict objectForKey:@"userName"], recipe.title];
    titleField.backgroundColor = [UIColor whiteColor];
    titleField.layer.cornerRadius = cornerRadius;
    titleField.clipsToBounds = YES;
    [self.view addSubview:titleField];
    
    UICookbookRecipeCell *recipeCell = [[UICookbookRecipeCell alloc]initWithFrame:CGRectMake(objectBreak, statusBarHeight + navBarHeight + objectBreak*2 + textHeight, objectWidth, recipeCellHeight) withRecipe:recipe];
    recipeCell.layer.cornerRadius = cornerRadius;
    recipeCell.clipsToBounds = YES;
    [self.view addSubview:recipeCell];
    
    descField = [[UITextView alloc]initWithFrame:CGRectMake(objectBreak, statusBarHeight + navBarHeight + objectBreak*3 + textHeight + recipeCellHeight, objectWidth, textHeight*5)];
    descField.backgroundColor = [UIColor whiteColor];
    descField.layer.cornerRadius = cornerRadius;
    descField.clipsToBounds = YES;
    [self.view addSubview:descField];
    
    UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak ,statusBarHeight + navBarHeight + objectBreak*4 + textHeight*6 + recipeCellHeight, objectWidth, textHeight)];
    [submitButton addTarget:self action:@selector(submitPostTouch:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    submitButton.backgroundColor = [UIColor secondaryColor];
    submitButton.layer.cornerRadius = cornerRadius;
    submitButton.clipsToBounds = YES;
    [self.view addSubview:submitButton];
    
}

@end
