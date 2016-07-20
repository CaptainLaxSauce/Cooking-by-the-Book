//
//  CookbookViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "CookbookViewController.h"
#import "UIColor+CustomColors.h"
#import "UICookbookRecipeCell.h"
#import "TabBarControllerDelegate.h"
#import "DataClass.h"

@interface CookbookViewController()

@end

static int objectBreak = 8;
static int cornerRadius = 3;

@implementation CookbookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadInterface];
    
}

-(void)createRecipeTouch:(id)sender{
    [self performSegueWithIdentifier:@"CreateRecipeViewController" sender:sender];
    
}


-(void)loadInterface{
    //declare constants
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    NSLog(@"screenWidth = %d",screenWidth);
    
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    int objWidth = screenWidth - objectBreak*2;
    int textHeight = screenHeight/20;
    int buttonHeight = screenHeight/20;
    int tabHeight = self.tabBarController.tabBar.frame.size.height;
    int scrollHeight = screenHeight-buttonHeight-tabHeight-objectBreak*4-textHeight-statusBarHeight;
    self.view.backgroundColor = [UIColor primaryColor];
    
    //add scroll view
    UIScrollView *recipeScrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, textHeight+objectBreak*2+statusBarHeight, screenWidth, scrollHeight)];
    recipeScrollView_.backgroundColor = [UIColor customGrayColor];
    recipeScrollView_.contentSize = CGSizeMake(screenWidth, screenHeight*2);
    self.recipeScrollView = recipeScrollView_;
    [self.view addSubview:recipeScrollView_];
    
    //add CookbookRecipeCells
    DataClass *obj = [DataClass getInstance];
    NSLog(@"coobookAry count in cookbookVC = %lu",(unsigned long)obj.cookbookAry.count);
    //NSArray *tagAry = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:quick],[NSNumber numberWithInt:vegetarian],[NSNumber numberWithInt:vegan], nil];
    for (int i=0;i<obj.cookbookAry.count;i++){
        NSDictionary *recipeDict = [obj.cookbookAry objectAtIndex:i];
        NSArray *tagAry = [recipeDict objectForKey:@"tagInfo"];
        NSMutableArray *tagNumAry = [[NSMutableArray alloc]init];
        NSLog(@"tagAry count = %lu",(unsigned long)tagAry.count);
        
        for (int ii=0;ii<tagAry.count;ii++){
            NSDictionary *tagDict = [tagAry objectAtIndex:ii];
            [tagNumAry addObject:[tagDict objectForKey:@"tagID"]];
            NSLog(@"tagID = %@",[tagDict objectForKey:@"tagID"]);
            NSLog(@"tagAry count inside ii loop = %lu",(unsigned long)tagAry.count);
         
        }
        
        //NSMutableArray *tagAry = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:quick],[NSNumber numberWithInt:vegetarian],[NSNumber numberWithInt:vegan], nil];
        UICookbookRecipeCell *cookCell = [[UICookbookRecipeCell alloc]initWithFrame:CGRectMake(0, objectBreak + screenHeight/6*i + objectBreak*i, screenWidth, screenHeight/6) withImage:[UIImage imageNamed:@"recipeimage.png"] withTitle:[recipeDict objectForKey:@"recipeTitle"] withDesc:[recipeDict objectForKey:@"recipeDescription"] withTags:tagNumAry];
        [self.recipeScrollView addSubview:cookCell];
        
    }
    

    
    //add button
    UIButton *createRecipeButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak , screenHeight-tabHeight-objectBreak-buttonHeight, objWidth, buttonHeight)];
    [createRecipeButton_ addTarget:self action:@selector(createRecipeTouch:) forControlEvents:UIControlEventTouchUpInside];
    [createRecipeButton_ setTitle:@"Create Recipe" forState:UIControlStateNormal];
    //[createRecipeButton_ setBackgroundImage:[UIImage imageNamed:@"app_logo.png"] forState: UIControlStateHighlighted];
    //[createRecipeButton_ setBackgroundImage:[UIImage imageNamed:@"app_logo.png"] forState: UIControlStateSelected];
    createRecipeButton_.backgroundColor = [UIColor secondaryColor];
    createRecipeButton_.layer.cornerRadius = cornerRadius;
    createRecipeButton_.clipsToBounds = YES;
    [self.view addSubview:createRecipeButton_];
    self.createRecipeButton = createRecipeButton_;
    
    
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
