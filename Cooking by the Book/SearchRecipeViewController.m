//
//  SearchRecipeViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 1/14/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "SearchRecipeViewController.h"
#import "UIColor+CustomColors.h"
#import "HTAutocompleteTextField.h"
#import "HTAutocompleteManager.h"
#import "FoundRecipesViewController.h"
#import "DataClass.h"
#import "Ingredient.h"
#import "Helper.h"
#import "Recipe.h"

@interface SearchRecipeViewController ()

@end

@implementation SearchRecipeViewController

{

    int objectBreak;
    int cornerRadius;
    int screenHeight;
    int screenWidth;
    int statusBarHeight;
    int navBarHeight;
    int textHeight;
    int tabHeight;
    int scrollHeight;
    HTAutocompleteTextField *ingField1;
    HTAutocompleteTextField *ingField2;
    HTAutocompleteTextField *ingField3;
    UITextField *searchTitleField;
    DataClass *obj;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"FoundRecipesViewController"]){
        FoundRecipesViewController *controller = (FoundRecipesViewController *)segue.destinationViewController;
        NSLog(@"segueingggg");
        controller.recipeAry = self.recipeAry;
    }
}


- (void)ingredientSearchTouch:(id)sender {
    NSMutableArray *ingIdAry = [[NSMutableArray alloc]init];
    for (HTAutocompleteTextField *field in self.textFieldAry){
        if ([field hasText]){
            NSString *ingId = [Helper ingName2Id:field.text];
            [ingIdAry addObject:ingId];
        }
        
    }
    
    NSMutableArray *dictAry = [[NSMutableArray alloc]init];
    for (int i = 0; i < ingIdAry.count; i++){
        NSDictionary *ingredientDict = [[NSDictionary alloc]initWithObjectsAndKeys:ingIdAry[i],@"ingredientID",nil];
        [dictAry addObject:ingredientDict];
    }
    
    NSDictionary *postDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              dictAry, @"ingredients",
                              nil];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [NSString stringWithFormat:@"userID=%@&ingredients=%@",obj.userId, jsonStr];
    NSLog(@"send JSON = %@",jsonStr);
    NSData *postData = [jsonStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"getSearchRecipes"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        
        NSString *ret = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"search recipe ret = %@",ret);
        
        NSDictionary *retDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSArray *recipeJSONAry = [retDict objectForKey:@"recipeInfo"];
        NSLog(@"recipeJSONAry count = %lu",(unsigned long)recipeJSONAry.count);
        
        
        for (int i = 0; i < recipeJSONAry.count; i++){
            NSDictionary *recipeDict = recipeJSONAry[i];
            NSLog(@"curr recipe title = %@",[recipeDict objectForKey:@"recipeTitle"]);
            //FIX - need to change what is returned from the server to match getRecipe

            Recipe *recipe = [[Recipe alloc]initWithDictionary:recipeDict];
            [self.recipeAry addObject:recipe];
            
            if (i == recipeJSONAry.count - 1){
                NSLog(@"recipeAry count in search controller = %lu",(unsigned long)self.recipeAry.count);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self performSegueWithIdentifier:@"FoundRecipesViewController" sender:sender];
                });
            }

            
        }
        
        
    }];
    
    [dataTask resume];

}

- (void)titleSearchTouch:(id)sender {
    [self performSegueWithIdentifier:@"FoundRecipesViewController" sender:sender];
}

-(void)dismissKeyboard
{
    [ingField1 resignFirstResponder];
    [ingField2 resignFirstResponder];
    [ingField3 resignFirstResponder];
    [searchTitleField resignFirstResponder];
}

-(void) loadInterface {
    //declare constants
    objectBreak = 8;
    cornerRadius = 3;
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    navBarHeight = self.navigationController.navigationBar.frame.size.height;
    int objectWidth = screenWidth - objectBreak*2;
    textHeight = screenHeight/20;
    tabHeight = self.tabBarController.tabBar.frame.size.height;
    scrollHeight = screenHeight-textHeight-tabHeight-objectBreak*2-navBarHeight-statusBarHeight;
    
    obj = [DataClass getInstance];
    
    self.view.backgroundColor = [UIColor primaryColor];
    self.navigationItem.title = @"Search Recipes";
    
    NSMutableArray *recipeAry_ = [[NSMutableArray alloc]init];
    self.recipeAry = recipeAry_;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    ingField1 = [[HTAutocompleteTextField alloc]initWithFrame:CGRectMake(objectBreak, statusBarHeight + navBarHeight + objectBreak, objectWidth, textHeight)];
    ingField1.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    ingField1.autocompleteType = HTAutocompleteTypeIngredient;
    ingField1.placeholder = @"First Ingredient";
    ingField1.backgroundColor = [UIColor whiteColor];
    ingField1.autocapitalizationType = UITextAutocapitalizationTypeWords;
    ingField1.layer.cornerRadius = cornerRadius;
    ingField1.clipsToBounds = YES;
    [ingField1 setKeyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:ingField1];
    
    ingField2 = [[HTAutocompleteTextField alloc]initWithFrame:CGRectMake(objectBreak, statusBarHeight + navBarHeight + objectBreak*2 + textHeight, objectWidth, textHeight)];
    ingField2.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    ingField2.autocompleteType = HTAutocompleteTypeIngredient;
    ingField2.placeholder = @"Second Ingredient";
    ingField2.backgroundColor = [UIColor whiteColor];
    ingField2.autocapitalizationType = UITextAutocapitalizationTypeWords;
    ingField2.layer.cornerRadius = cornerRadius;
    ingField2.clipsToBounds = YES;
    [ingField2 setKeyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:ingField2];
    
    ingField3 = [[HTAutocompleteTextField alloc]initWithFrame:CGRectMake(objectBreak, statusBarHeight + navBarHeight + objectBreak*3 + textHeight*2, objectWidth, textHeight)];
    ingField3.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    ingField3.autocompleteType = HTAutocompleteTypeIngredient;
    ingField3.placeholder = @"Third Ingredient";
    ingField3.backgroundColor = [UIColor whiteColor];
    ingField3.autocapitalizationType = UITextAutocapitalizationTypeWords;
    ingField3.layer.cornerRadius = cornerRadius;
    ingField3.clipsToBounds = YES;
    [ingField3 setKeyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:ingField3];
    
    NSArray *textFieldAry_ = [[NSArray alloc] initWithObjects:ingField1, ingField2, ingField3, nil];
    self.textFieldAry = textFieldAry_;
    
    UIButton *searchIngredientButton = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak ,statusBarHeight + navBarHeight + objectBreak*4 + textHeight*3, objectWidth, textHeight)];
    [searchIngredientButton addTarget:self action:@selector(ingredientSearchTouch:) forControlEvents:UIControlEventTouchUpInside];
    [searchIngredientButton setTitle:@"Search by Ingredient" forState:UIControlStateNormal];
    [searchIngredientButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    searchIngredientButton.backgroundColor = [UIColor secondaryColor];
    searchIngredientButton.layer.cornerRadius = cornerRadius;
    searchIngredientButton.clipsToBounds = YES;
    [self.view addSubview:searchIngredientButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(objectBreak, statusBarHeight + navBarHeight + objectBreak*5 + textHeight*4, objectWidth, 1)];
    line.backgroundColor = [UIColor customGrayColor];
    [self.view addSubview:line];
    
    searchTitleField = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, statusBarHeight + navBarHeight + objectBreak*6 + textHeight*4 + 1, objectWidth, textHeight)];
    searchTitleField.backgroundColor = [UIColor whiteColor];
    searchTitleField.placeholder = @"Title";
    searchTitleField.layer.cornerRadius = cornerRadius;
    searchTitleField.clipsToBounds = YES;
    [searchTitleField setKeyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:searchTitleField];
    
    UIButton *searchTitleButton =  [[UIButton alloc]initWithFrame:CGRectMake(objectBreak, statusBarHeight + navBarHeight + objectBreak*7 + textHeight*5 + 1, objectWidth, textHeight)];
    [searchTitleButton addTarget:self action:@selector(titleSearchTouch:) forControlEvents:UIControlEventTouchUpInside];
    [searchTitleButton setTitle:@"Search by Title" forState:UIControlStateNormal];
    [searchTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    searchTitleButton.backgroundColor = [UIColor secondaryColor];
    searchTitleButton.layer.cornerRadius = cornerRadius;
    searchTitleButton.clipsToBounds = YES;
    [self.view addSubview:searchTitleButton];
    
 }



@end
