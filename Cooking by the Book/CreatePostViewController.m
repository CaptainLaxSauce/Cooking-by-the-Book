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
#import "HCSStarRatingView.h"
#import "Constants.h"

@interface CreatePostViewController ()

@end

@implementation CreatePostViewController

{
DataClass *obj;
UITextField *titleField;
UITextView *descField;
HCSStarRatingView *starView;
}

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
- (void)didChangeValue:(HCSStarRatingView *)sender {
    NSLog(@"Changed rating to %.1f", sender.value);
}
*/

-(void)dismissKeyboard
{
    [descField resignFirstResponder];
    [titleField resignFirstResponder];
}

-(void)configurePostCompletion{
    CreatePostViewController *__weak weakSelf = self;
    self.postCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
        [weakSelf stopActivityViewAsync:weakSelf.activityView];
        
        NSString *postID = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"Post ID = %@",postID);

        //successful post
        if ([postID intValue] > 0){
            NSLog(@"Successful post");
            [weakSelf configureRatingCompletion];
            [weakSelf submitRatingWeb];
        }
        else{
            [weakSelf postUnsuccessfulAlertAsync];
        }
        
        
    };
}

-(void)submitPostWeb{
    NSDictionary *postDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              obj.userId, @"creatorID",
                              obj.userId, @"wallUserID",
                              titleField.text, @"postTitle",
                              self.recipeID, @"recipeID",
                              descField.text, @"postBody",
                              [Helper toUTC:[NSDate date]], @"postDateTime",
                              nil];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [NSString stringWithFormat:@"post=%@",jsonStr];
    [Helper submitHTTPPostWithString:jsonStr withURLEnd:@"addPost" withCompletionHandler:self.postCompletion];
}

-(void)configureRatingCompletion{
    CreatePostViewController *__weak weakSelf = self;
    self.ratingCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
        [weakSelf stopActivityViewAsync:weakSelf.activityView];
        
        NSString *ret = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"Rating ret = %@",ret);
        
        //successful rating submission
        if ([ret intValue] > 0){
            NSLog(@"Successful rating submission");
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                [weakSelf.tabBarController setSelectedIndex:1];
                [[weakSelf navigationController] popViewControllerAnimated:NO];
            });
        }
        else{
            [weakSelf postUnsuccessfulAlertAsync];
        }
    };
}

-(void)submitRatingWeb{
    NSString *sendStr = [NSString stringWithFormat:@"userID=%@&recipeID=%@&rating=%.01f",obj.userId,self.recipeID,starView.value];
    NSLog(@"sendStr for rating = %@",sendStr);
    [Helper submitHTTPPostWithString:sendStr withURLEnd:@"addRating" withCompletionHandler:self.ratingCompletion];
}

-(void) startActivityView{
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview: self.activityView];
    self.activityView.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [self.activityView startAnimating];
    self.view.userInteractionEnabled = FALSE;
    self.navigationController.view.userInteractionEnabled = FALSE;
    self.tabBarController.view.userInteractionEnabled = FALSE;
}

-(void)stopActivityViewAsync:(UIActivityIndicatorView *)activityView{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [activityView stopAnimating];
        self.view.userInteractionEnabled = TRUE;
        self.navigationController.view.userInteractionEnabled = TRUE;
        self.tabBarController.view.userInteractionEnabled = TRUE;
        
    });
}

-(void)postUnsuccessfulAlertAsync{
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

-(void)ratingUnsuccessfulAlertAsync{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Rating Submission Unsuccessful"
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

- (void) submitPostTouch:(id)sender {
    [self startActivityView];
    
    [self configurePostCompletion];
    [self submitPostWeb];
    
}

-(void)loadInterface {
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    int objectWidth = screenWidth - objectBreak*2;
    int recipeCellHeight = objectWidth/4;
    int textHeight = screenHeight/20;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    int navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    obj = [DataClass getInstance];
    Recipe *recipe = [obj getRecipe:self.recipeID];
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

    starView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(objectBreak, statusBarHeight + navBarHeight + objectBreak*4 + textHeight + recipeCellHeight + textHeight*5, objectWidth, textHeight * 2)];
    starView.maximumValue = 5;
    starView.minimumValue = 0;
    starView.allowsHalfStars = YES;
    starView.userInteractionEnabled = YES;
    starView.tintColor = [UIColor starColor];
    starView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:starView];
    
    //add buttons
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitPostTouch:)];
    self.navigationItem.rightBarButtonItem = createButton;
    
}

@end
