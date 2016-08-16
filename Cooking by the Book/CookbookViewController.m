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
#import "DetailedRecipeViewController.h"

@interface CookbookViewController()

@end

static int objectBreak = 8;
static int cornerRadius = 3;
int screenHeight;
int screenWidth;
int statusBarHeight;
int navBarHeight;
int buttonHeight;
int tabHeight;
int scrollHeight;

@implementation CookbookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadInterface];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self refreshRecipes];
}

-(void)refreshRecipes{

    int recipeCellHeight = (scrollHeight - objectBreak*6)/5;
    
    DataClass *obj = [DataClass getInstance];
    NSInteger recipeCnt = obj.cookbookAry.count;
    NSLog(@"coobookAry count in cookbookVC = %lu",(unsigned long)recipeCnt);
    
    for (int i = 0;i<recipeCnt;i++){
        NSLog(@"%d",i);
        CookbookRecipe *tempRecipe = [[CookbookRecipe alloc]init];
        tempRecipe = [obj.cookbookAry objectAtIndex:i];
        
        NSLog(@"2 temp recipe properties = %@ %@ %@ %@",tempRecipe.title, tempRecipe.recipeID, tempRecipe.desc, tempRecipe.tagAry);
        UICookbookRecipeCell *cookCell = [[UICookbookRecipeCell alloc]initWithFrame:CGRectMake(0, objectBreak + i*(recipeCellHeight + objectBreak), screenWidth, recipeCellHeight) withCookbookRecipe:tempRecipe];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchCell:)];
        [cookCell addGestureRecognizer:tapRecognizer];
        [self.recipeScrollView addSubview:cookCell];
    }
    
    if (recipeCnt > 5){
        self.recipeScrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollHeight + (recipeCnt - 5)*(recipeCellHeight + objectBreak));
    }
 
}

/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:self{
    if([segue.identifier isEqualToString:@"DetailedRecipeViewController"]){
        //UICookbookRecipeCell *cookCell = sender.view;
        UINavigationController *navController = [segue destinationViewController];
        DetailedRecipeViewController *controller = (DetailedRecipeViewController *)([navController viewControllers][0]);
        controller.recipeID = @"12345";
        NSLog(@"Cookbook recipe ID = %@",controller.recipeID);
        
    }
}
*/
 
-(void)touchCell:(UITapGestureRecognizer *)sender{
    DataClass *obj = [DataClass getInstance];
    UICookbookRecipeCell *cookCell = (UICookbookRecipeCell*)sender.view;
    NSLog(@"Cookbook recipe ID = %@",cookCell.recipe.recipeID);
    obj.currDetailedRecipeId = cookCell.recipe.recipeID;
    [self performSegueWithIdentifier:@"DetailedRecipeViewController" sender:sender];
    NSLog(@"Cell Touch");
}

-(void)createRecipeTouch:(id)sender{
    [self performSegueWithIdentifier:@"CreateRecipeViewController" sender:sender];
    
}

-(void)loadInterface{
    //declare constants
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    navBarHeight = self.navigationController.navigationBar.frame.size.height;
    int objWidth = screenWidth - objectBreak*2;
    buttonHeight = screenHeight/20;
    tabHeight = self.tabBarController.tabBar.frame.size.height;
    scrollHeight = screenHeight-buttonHeight-tabHeight-objectBreak*2-navBarHeight-statusBarHeight;
    
    self.view.backgroundColor = [UIColor primaryColor];
    self.navigationItem.title = @"Cookbook";
    
    //add scroll view
    UIScrollView *recipeScrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, screenWidth, scrollHeight)];
    recipeScrollView_.backgroundColor = [UIColor customGrayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.recipeScrollView = recipeScrollView_;
    [self.view addSubview:recipeScrollView_];

    //add CookbookRecipeCells
    [self refreshRecipes];

    //NSArray *tagAry = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:quick],[NSNumber numberWithInt:vegetarian],[NSNumber numberWithInt:vegan], nil];
    
    //NSMutableArray *tagAry = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:quick],[NSNumber numberWithInt:vegetarian],[NSNumber numberWithInt:vegan], nil];
   /* loop to add recipe cells

    */
    //add button
    UIButton *createRecipeButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak , screenHeight-tabHeight-objectBreak-buttonHeight, objWidth, buttonHeight)];
    [createRecipeButton_ addTarget:self action:@selector(createRecipeTouch:) forControlEvents:UIControlEventTouchUpInside];
    [createRecipeButton_ setTitle:@"Create Recipe" forState:UIControlStateNormal];
    [createRecipeButton_ setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
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
