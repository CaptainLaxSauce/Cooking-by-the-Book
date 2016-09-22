//
//  CookbookViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "CookbookViewController.h"
#import "Recipe.h"
#import "UIColor+CustomColors.h"
#import "UICookbookRecipeCell.h"
#import "TabBarControllerDelegate.h"
#import "DataClass.h"
#import "DetailedRecipeViewController.h"
#import "Helper.h"

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
{
    NSMutableArray *cookbookRecipeCellAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
       
       [self loadInterface];
       [self refreshRecipes];
   
    
}

-(void)delRecipeTouch:(id)sender{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview: activityView];
    activityView.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [activityView startAnimating];
    
    
    UIButton *tempBtn = [sender self];
    UICookbookRecipeCell *tempCell = (UICookbookRecipeCell *) tempBtn.superview;
    [tempCell removeFromSuperview];
    NSInteger index = [cookbookRecipeCellAry indexOfObject:tempCell];
    [self shiftCellsUp:index];
    
    NSString *post = [NSString stringWithFormat:@"recipeID=%@" ,tempCell.recipeID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"deleteRecipe"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSString *ret = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
        if ([ret isEqual:@"1"]){
            DataClass *obj = [DataClass getInstance];
            [obj deleteRecipe:tempCell.recipe];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Invalid Login"
                                            message:[NSString stringWithFormat:@"The recipe deletion was unsuccessful"]
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
        [activityView stopAnimating];
        
    }];
    
    [dataTask resume];
    
    NSLog(@"deleted recipe %@",tempCell.recipeID);
}

-(void)shiftCellsUp:(NSInteger)startInt{
    UICookbookRecipeCell *tempCell = [[UICookbookRecipeCell alloc]init];
    int moveSize = 0;
    for(NSInteger i = startInt;i < cookbookRecipeCellAry.count; i++){
        tempCell = [cookbookRecipeCellAry objectAtIndex:i];
        
        moveSize = tempCell.frame.size.height + objectBreak;
        
        [tempCell setFrame:CGRectMake(tempCell.frame.origin.x, tempCell.frame.origin.y - moveSize, tempCell.frame.size.width, tempCell.frame.size.height)];
    }
    self.recipeScrollView.contentSize = CGSizeMake(self.recipeScrollView.contentSize.width, self.recipeScrollView.contentSize.height - moveSize);
}

-(void)refreshRecipes{
    NSLog(@"recipes refreshed");
    int recipeCellHeight = (scrollHeight - objectBreak*6)/5;
    cookbookRecipeCellAry = [[NSMutableArray alloc]init];
    
    DataClass *obj = [DataClass getInstance];
    NSInteger recipeCnt = obj.cookbookAry.count;
    NSLog(@"coobookAry count in cookbookVC = %lu",(unsigned long)recipeCnt);
    
    for (int i=0;i<recipeCnt;i++){
        Recipe *tempRecipe = [obj.cookbookAry objectAtIndex:i];
         NSLog(@"2 temp recipe properties = %@ %@ %@ %@ %@",tempRecipe.title, tempRecipe.imageName, tempRecipe.recipeID, tempRecipe.desc, tempRecipe.tagAry);
        UICookbookRecipeCell *cookCell = [[UICookbookRecipeCell alloc]initWithFrame:CGRectMake(0, objectBreak + i*(recipeCellHeight + objectBreak), screenWidth, recipeCellHeight) withRecipe:tempRecipe];
        [cookCell.delButton addTarget:self action:@selector(delRecipeTouch:) forControlEvents:UIControlEventTouchUpInside];
        cookCell.allowDelBtn = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchCell:)];
        [cookCell addGestureRecognizer:tapRecognizer];
        [cookbookRecipeCellAry addObject:cookCell];
        NSLog(@"cookbookRecipeCellAry count just after adding = %lu",(unsigned long)cookbookRecipeCellAry.count);
        [self.recipeScrollView addSubview:cookCell];
        NSLog(@"loopy %d",i);
    }
    
    if (recipeCnt > 5){
        self.recipeScrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollHeight + (recipeCnt - 5)*(recipeCellHeight + objectBreak));
    }
    
    //load images
    for (int i=0;i<recipeCnt;i++){
        Recipe *tempRecipe = [obj.cookbookAry objectAtIndex:i];
        if (tempRecipe.image == nil){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recipeID MATCHES %@", tempRecipe.recipeID];
            NSArray *filteredAry = [cookbookRecipeCellAry filteredArrayUsingPredicate:predicate];
            UICookbookRecipeCell *tempCookCell = [filteredAry objectAtIndex:0];
            NSLog(@"filteredAry count = %lu",(unsigned long)filteredAry.count);
            NSLog(@"cookbookRecipeCellAry count = %lu",(unsigned long)cookbookRecipeCellAry.count);
            NSLog(@"tempCookCell recipe ID = %@",tempCookCell.recipeID);
        
            NSLog(@"image name = %@",tempRecipe.imageName);
            NSString *post = [NSString stringWithFormat:@"imageName=%@" ,tempRecipe.imageName];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"getImage"];
            NSURLSession *session = [NSURLSession sharedSession];
            //for some reason we are calling this more than once per recipe, need to investigate
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
                tempRecipe.image = [UIImage imageWithData:postData];
                
                // ((Recipe *) [obj.cookbookAry objectAtIndex:i]).image = tempRecipe.image;
                NSLog(@"%d",i);

                dispatch_async(dispatch_get_main_queue(), ^(void){
                    if (tempRecipe.image != nil){
                        [tempCookCell.imageView setImage:tempRecipe.image];
                       

                   //[obj addImageToRecipe:tempRecipe withImage:tempRecipe.image];
                    }
                });
                
        }];
        [dataTask resume];
        }
        
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
