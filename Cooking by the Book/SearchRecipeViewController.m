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
#import "FoundRecipesTableViewController.h"
#import "DataClass.h"
#import "Ingredient.h"
#import "Helper.h"
#import "Recipe.h"
#import "Constants.h"
#import "UIColor+CustomColors.h"

@interface SearchRecipeViewController ()

@end

@implementation SearchRecipeViewController

{
    DataClass *obj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    obj = [DataClass getInstance];
    
    self.navigationItem.title = @"Search Recipes";
    
    self.recipeAry = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.ingredientTextField.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    self.ingredientTextField.autocompleteType = HTAutocompleteTypeIngredient;
    self.ingredientTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self.ingredientTextField setKeyboardType:UIKeyboardTypeDefault];
}

-(void)dismissKeyboard
{
    [self.ingredientTextField resignFirstResponder];
    [self.keywordTextField resignFirstResponder];
}

- (IBAction)addKeyword:(id)sender{
    if ([self.keywordTextField.text isEqualToString:@""])
        return;
    
    unsigned long index;
    index = self.keywordStackView.arrangedSubviews.count - 1;
    
    NSArray *words = [self.keywordTextField.text componentsSeparatedByString:@" "];
    
    for (NSString *word in words){
        UIStackView *newView = [self createEntry:word];
        newView.hidden = true;
        [self.keywordStackView insertArrangedSubview:newView atIndex:index];
        
        [UIView animateWithDuration:(0.25) animations:^{
            newView.hidden = false;
        }];
        
        [self.keywordScrollView setContentSize:CGSizeMake(self.keywordScrollView.contentSize.width + newView.frame.size.width + self.keywordStackView.spacing, self.keywordScrollView.frame.size.height)];
        self.keywordTextField.text = @"";
        
        index++;
    }

}

- (IBAction)addIngredient:(id)sender{
    if ([self.ingredientTextField.text isEqualToString:@""])
        return;
    
    unsigned long index;
    index = self.ingredientStackView.arrangedSubviews.count - 1;
    
    [self.ingredientTextField forceCompletion];
    
    NSString *ingId = [Helper ingName2Id:self.ingredientTextField.text];
    
    if ([ingId  isEqual: @""]){
        [Helper postUnsuccessfulAlertAsyncOK:@"Ingredient not found on any recipe" withMessage:@"Please select an different ingredient to search" withViewController:self];
        return;
    }
    
    UIStackView *newView = [self createEntry:self.ingredientTextField.text];
    newView.hidden = true;
    [self.ingredientStackView insertArrangedSubview:newView atIndex:index];
    
    [UIView animateWithDuration:(0.25) animations:^{
        newView.hidden = false;
    }];
    
    [self.ingredientScrollView setContentSize:CGSizeMake(self.ingredientScrollView.contentSize.width + newView.frame.size.width + self.ingredientStackView.spacing, self.ingredientScrollView.frame.size.height)];
    self.ingredientTextField.text = @"";
    
    index++;
    
    [self.ingredientTextField forceReady];
    
    
}

-(UIStackView *)createEntry:(NSString *)labelText{
    UIStackView *stack = [[UIStackView alloc]init];
    [stack setAxis:UILayoutConstraintAxisHorizontal];
    [stack setAlignment:UIStackViewAlignmentFill];
    [stack setDistribution:UIStackViewDistributionFill];
    [stack setLayoutMarginsRelativeArrangement:true];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"%@",labelText];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor brightGreenColor];
    
    UIButton *xBtn = [[UIButton alloc]init];
    [xBtn setTitle:@"X" forState:UIControlStateNormal];
    [xBtn addTarget:self action:@selector(deleteEntry:) forControlEvents:UIControlEventTouchUpInside];
    xBtn.backgroundColor = [UIColor brightGreenColor];
    UIFontDescriptor * fontD = [xBtn.titleLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    [xBtn.titleLabel setFont:[UIFont fontWithDescriptor:fontD size:20]];
    
    
    [stack addArrangedSubview:label];
    [stack addArrangedSubview:xBtn];
    
    return stack;
    
    
}

-(void)deleteEntry:(id)sender{
    UIView *view = ((UIView*)sender).superview;
    [UIView animateWithDuration:(0.25) animations:^{
        view.hidden = true;
    }completion:^(BOOL finished){
        [view removeFromSuperview];
    }];
    
}


- (IBAction)goButtonTouch:(id)sender {
    NSString *jsonStr = [self getJSONString];
    NSLog(@"JSON Str = %@",jsonStr);
    [Helper submitHTTPPostWithString:jsonStr withURLEnd:@"getRecipesByKeywordIngredient" withCompletionHandler:[self getSearchCompletion]];
    
}

-(NSMutableArray*)getLabelTextsFromStackview:(UIStackView*)sv{
    NSMutableArray *ary = [[NSMutableArray alloc]init];;
    for (UIView *view in sv.arrangedSubviews){
        if ([view isKindOfClass:[UIStackView class]]){
            for (UIView *view2 in ((UIStackView *)view).arrangedSubviews){
                if ([view2 isKindOfClass:[UILabel class]]){
                    UILabel *lbl = (UILabel*)view2;
                    [ary addObject:lbl.text];
                }
            }
        }
    }
    return ary;
}

-(NSString*)getJSONString{
    NSMutableArray *keywordAry = [self getLabelTextsFromStackview:self.keywordStackView];
    NSMutableArray *ingAry = [self getLabelTextsFromStackview:self.ingredientStackView];
    
    NSString *keywordsOut = [[NSString alloc]init];
    for (NSString *keyword in keywordAry){
        if ([keyword isEqualToString:[keywordAry firstObject]])
            keywordsOut = keyword;
        else
            keywordsOut = [keywordsOut stringByAppendingString:[NSString stringWithFormat:@" %@",keyword]];
        
    }
    
    NSMutableArray *ingJsonAry = [[NSMutableArray alloc]init];
    for (NSString *ing in ingAry){
        NSDictionary *ingDict = [[NSDictionary alloc]initWithObjectsAndKeys:[Helper ingName2Id:ing],@"ingredientID", nil];
        [ingJsonAry addObject:ingDict];
    }
    
    NSDictionary *infoDict= [[NSDictionary alloc]initWithObjectsAndKeys:
                             keywordsOut, @"searchString",
                             ingJsonAry, @"ingredients", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [NSString stringWithFormat:@"userID=%@&searchInfo=%@",obj.userId,jsonStr];
    
    return jsonStr;
    
}

-(CompletionWeb) getSearchCompletion {
    CompletionWeb ingSearchComp = ^(NSData *postData, NSURLResponse *response, NSError *error){
        NSDictionary *retDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSArray *recipeJSONAry = [retDict objectForKey:@"recipeInfo"];
        
        if (recipeJSONAry.count == 0){
            [Helper postUnsuccessfulAlertAsyncOK:@"No results found" withMessage:@"Please try again" withViewController:self];
        }
        else{
            for (int i = 0; i < recipeJSONAry.count; i++){
                NSDictionary *recipeDict = recipeJSONAry[i];
                NSLog(@"curr recipe = %@",recipeDict);
                //TODO - need to change what is returned from the server to match getRecipe
                
                Recipe *recipe = [[Recipe alloc]initWithJSONDictionary:recipeDict];
                [self.recipeAry addObject:recipe];
                
                if (i == recipeJSONAry.count - 1){
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [self performSegueWithIdentifier:@"FoundRecipesTableViewController" sender:self];
                    });
                }
            }
        }
        
        
    };
    
    return ingSearchComp;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"FoundRecipesTableViewController"]){
        FoundRecipesTableViewController *controller = (FoundRecipesTableViewController *)segue.destinationViewController;
        controller.recipeAry = self.recipeAry;
    }
}

-(void) loadInterface {
    /*
    //declare constants
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    navBarHeight = self.navigationController.navigationBar.frame.size.height;
    int objectWidth = screenWidth - OBJECT_BREAK*2;
    textHeight = screenHeight/20;
    tabHeight = self.tabBarController.tabBar.frame.size.height;
    scrollHeight = screenHeight-textHeight-tabHeight-OBJECT_BREAK*2-navBarHeight-statusBarHeight;

    obj = [DataClass getInstance];

    self.navigationItem.title = @"Search Recipes";
    
    NSMutableArray *recipeAry_ = [[NSMutableArray alloc]init];
    self.recipeAry = recipeAry_;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    

    ingField1 = [[HTAutocompleteTextField alloc]initWithFrame:CGRectMake(OBJECT_BREAK, statusBarHeight + navBarHeight + OBJECT_BREAK, objectWidth, textHeight)];
    ingField1.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    ingField1.autocompleteType = HTAutocompleteTypeIngredient;
    ingField1.placeholder = @"First Ingredient";
    ingField1.backgroundColor = [UIColor whiteColor];
    ingField1.autocapitalizationType = UITextAutocapitalizationTypeWords;
    ingField1.layer.cornerRadius = CORNER_RADIUS;
    ingField1.clipsToBounds = YES;
    [ingField1 setKeyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:ingField1];
    
    ingField2 = [[HTAutocompleteTextField alloc]initWithFrame:CGRectMake(OBJECT_BREAK, statusBarHeight + navBarHeight + OBJECT_BREAK*2 + textHeight, objectWidth, textHeight)];
    ingField2.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    ingField2.autocompleteType = HTAutocompleteTypeIngredient;
    ingField2.placeholder = @"Second Ingredient";
    ingField2.backgroundColor = [UIColor whiteColor];
    ingField2.autocapitalizationType = UITextAutocapitalizationTypeWords;
    ingField2.layer.cornerRadius = CORNER_RADIUS;
    ingField2.clipsToBounds = YES;
    [ingField2 setKeyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:ingField2];
    
    ingField3 = [[HTAutocompleteTextField alloc]initWithFrame:CGRectMake(OBJECT_BREAK, statusBarHeight + navBarHeight + OBJECT_BREAK*3 + textHeight*2, objectWidth, textHeight)];
    ingField3.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    ingField3.autocompleteType = HTAutocompleteTypeIngredient;
    ingField3.placeholder = @"Third Ingredient";
    ingField3.backgroundColor = [UIColor whiteColor];
    ingField3.autocapitalizationType = UITextAutocapitalizationTypeWords;
    ingField3.layer.cornerRadius = CORNER_RADIUS;
    ingField3.clipsToBounds = YES;
    [ingField3 setKeyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:ingField3];
    
    NSArray *textFieldAry_ = [[NSArray alloc] initWithObjects:ingField1, ingField2, ingField3, nil];
    self.textFieldAry = textFieldAry_;
    
    UIButton *searchIngredientButton = [[UIButton alloc]initWithFrame:CGRectMake(OBJECT_BREAK ,statusBarHeight + navBarHeight + OBJECT_BREAK*4 + textHeight*3, objectWidth, textHeight)];
    [searchIngredientButton addTarget:self action:@selector(ingredientSearchTouch:) forControlEvents:UIControlEventTouchUpInside];
    [searchIngredientButton setTitle:@"Search by Ingredient" forState:UIControlStateNormal];
    [searchIngredientButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    searchIngredientButton.backgroundColor = [UIColor secondaryColor];
    searchIngredientButton.layer.cornerRadius = CORNER_RADIUS;
    searchIngredientButton.clipsToBounds = YES;
    [self.view addSubview:searchIngredientButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(OBJECT_BREAK, statusBarHeight + navBarHeight + OBJECT_BREAK*5 + textHeight*4, objectWidth, 1)];
    line.backgroundColor = [UIColor customGrayColor];
    [self.view addSubview:line];
    
    searchTitleField = [[UITextField alloc]initWithFrame:CGRectMake(OBJECT_BREAK, statusBarHeight + navBarHeight + OBJECT_BREAK*6 + textHeight*4 + 1, objectWidth, textHeight)];
    searchTitleField.backgroundColor = [UIColor whiteColor];
    searchTitleField.placeholder = @"Title";
    searchTitleField.layer.cornerRadius = CORNER_RADIUS;
    searchTitleField.clipsToBounds = YES;
    [searchTitleField setKeyboardType:UIKeyboardTypeDefault];
    [self.view addSubview:searchTitleField];
    
    UIButton *searchTitleButton =  [[UIButton alloc]initWithFrame:CGRectMake(OBJECT_BREAK, statusBarHeight + navBarHeight + OBJECT_BREAK*7 + textHeight*5 + 1, objectWidth, textHeight)];
    [searchTitleButton addTarget:self action:@selector(titleSearchTouch:) forControlEvents:UIControlEventTouchUpInside];
    [searchTitleButton setTitle:@"Search by Title" forState:UIControlStateNormal];
    [searchTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    searchTitleButton.backgroundColor = [UIColor secondaryColor];
    searchTitleButton.layer.cornerRadius = CORNER_RADIUS;
    searchTitleButton.clipsToBounds = YES;
    [self.view addSubview:searchTitleButton];
    */
 }


@end
