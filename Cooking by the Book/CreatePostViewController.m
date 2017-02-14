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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    CompletionWeb postCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
        NSString *postID = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"Post ID = %@",postID);

        //successful post
        if ([postID intValue] > 0){
            NSLog(@"Successful post");
            [self configureRatingCompletion];
            [self submitRatingWeb];
        }
        else{
            [Helper postUnsuccessfulAlertAsyncOK:@"Post Unsuccessful" withMessage:@"Please try again" withViewController:self];
        }
        
        
    };
    
    self.postCompletion = postCompletion;
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
     CompletionWeb ratingCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
        [Helper stopActivityViewAsync:self.activityView withViewController:self];
        
        NSString *ret = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"Rating ret = %@",ret);
        
        //successful rating submission
        if ([ret intValue] > 0){
            NSLog(@"Successful rating submission");
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                [self.tabBarController setSelectedIndex:1];
                [[self navigationController] popViewControllerAnimated:NO];
            });
        }
        else{
            [Helper postUnsuccessfulAlertAsyncOK:@"Rating Submission Failed" withMessage:@"Please try again" withViewController:self];
        }
    };
    
    self.ratingCompletion = ratingCompletion;
}

-(void)submitRatingWeb{
    NSString *sendStr = [NSString stringWithFormat:@"userID=%@&recipeID=%@&rating=%.01f",obj.userId,self.recipeID,starView.value];
    NSLog(@"sendStr for rating = %@",sendStr);
    [Helper submitHTTPPostWithString:sendStr withURLEnd:@"addRating" withCompletionHandler:self.ratingCompletion];
}

- (void) submitPostTouch:(id)sender {
    self.activityView = [Helper startActivityView:self];
    
    [self configurePostCompletion];
    [self submitPostWeb];
    
}

-(void)loadInterface {
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    int objectWidth = screenWidth - OBJECT_BREAK*2;
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
    
    titleField = [[UITextField alloc]initWithFrame:CGRectMake(OBJECT_BREAK, statusBarHeight + navBarHeight + OBJECT_BREAK, objectWidth, textHeight)];
    titleField.text = [NSString stringWithFormat:@"%@ cooked %@!", [obj.profileDict objectForKey:@"userName"], recipe.title];
    titleField.backgroundColor = [UIColor whiteColor];
    titleField.layer.cornerRadius = CORNER_RADIUS;
    titleField.clipsToBounds = YES;
    [self.view addSubview:titleField];
    
    UICookbookRecipeCell *recipeCell = [[UICookbookRecipeCell alloc]initWithFrame:CGRectMake(OBJECT_BREAK, statusBarHeight + navBarHeight + OBJECT_BREAK*2 + textHeight, objectWidth, recipeCellHeight) withRecipe:recipe];
    recipeCell.layer.cornerRadius = CORNER_RADIUS;
    recipeCell.clipsToBounds = YES;
    [self.view addSubview:recipeCell];
    
    descField = [[UITextView alloc]initWithFrame:CGRectMake(OBJECT_BREAK, statusBarHeight + navBarHeight + OBJECT_BREAK*3 + textHeight + recipeCellHeight, objectWidth, textHeight*5)];
    descField.backgroundColor = [UIColor whiteColor];
    descField.layer.cornerRadius = CORNER_RADIUS;
    descField.clipsToBounds = YES;
    [self.view addSubview:descField];

    starView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(OBJECT_BREAK, statusBarHeight + navBarHeight + OBJECT_BREAK*4 + textHeight + recipeCellHeight + textHeight*5, objectWidth, textHeight * 2)];
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
