//
//  CreateRecipeViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "CreateRecipeViewController.h"
#import "UIColor+CustomColors.h"
#import "UICreateIngredientCell.h"

@implementation CreateRecipeViewController

static int objectBreak = 8;
static int cornerRadius = 3;
int screenHeight;
int screenWidth;
int objectWidth;
int textHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadInterface];
    
}

-(void)addIngredientTouch:(id)sender{

        UICreateIngredientCell *ingredient = [[UICreateIngredientCell alloc]initWithFrame:self.addIngredientButton.frame];
    [self.recipeScrollView addSubview:ingredient];
    [self.ingredientAry addObject:ingredient];
    
        //move button and line down
    self.ingredientLine.frame = CGRectMake(
                                           (int)self.ingredientLine.frame.origin.x,
                                           (int)self.ingredientLine.frame.origin.y + objectBreak + textHeight,
                                           (int)self.ingredientLine.frame.size.width,
                                           (int)self.ingredientLine.frame.size.height);
    
    self.addIngredientButton.frame = CGRectMake((int)self.addIngredientButton.frame.origin.x,
                                                (int)self.addIngredientButton.frame.origin.y + objectBreak + textHeight,
                                                (int)self.addIngredientButton.frame.size.width,
                                                (int)self.addIngredientButton.frame.size.height);
   

    
}

-(void)submitRecipeTouch:(id)sender{
   [self performSegueWithIdentifier:@"CookbookViewController" sender:sender];
}

-(void)backTouch:(id)sender{
   [self performSegueWithIdentifier:@"CookbookViewController" sender:sender];
}

-(void)stepperValueChange:(id)sender{
    self.portionNumLabel.text = [NSString stringWithFormat:@"%d",(int)self.portionStepper.value];
}

-(void)loadInterface {
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    objectWidth = screenWidth - objectBreak*2;
    textHeight = screenHeight/20;
    int buttonHeight = screenHeight/20;
    int tabHeight = self.tabBarController.tabBar.frame.size.height;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    int stepperWidth = 94;
    int scrollHeight = screenHeight-tabHeight-statusBarHeight;
    int labelWidth = screenWidth/5;
    
    int portionsHeight = objectBreak*2+textHeight;
    int ingredientHeight = textHeight*3+objectBreak*4;
    
    self.view.backgroundColor = [UIColor primaryColor];
    
    //add scroll view
    UIScrollView *recipeScrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight+objectBreak*2+textHeight, screenWidth, scrollHeight)];
    recipeScrollView_.backgroundColor = [UIColor customGrayColor];
    [self.view addSubview:recipeScrollView_];
    self.recipeScrollView = recipeScrollView_;
    
    //add portions
    UIStepper *portionStepper_ = [[UIStepper alloc]initWithFrame:CGRectMake(screenWidth-objectBreak-stepperWidth, objectBreak, 0, 0)];
    portionStepper_.minimumValue = 1;
    portionStepper_.value = 4;
    [portionStepper_ addTarget:self action:@selector(stepperValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.recipeScrollView addSubview:portionStepper_];
    self.portionStepper = portionStepper_;
    
    UILabel *portionNumLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-objectBreak*2-stepperWidth-labelWidth, objectBreak, labelWidth, textHeight)];
    portionNumLabel_.text = [NSString stringWithFormat:@"%d",(int)self.portionStepper.value];
    [self.recipeScrollView addSubview:portionNumLabel_];
    self.portionNumLabel = portionNumLabel_;
    
    UILabel *portionLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak, labelWidth, textHeight)];
    portionLabel_.text = @"Portions";
    [self.recipeScrollView addSubview:portionLabel_];
    
    UIView *portionLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight, objectWidth, 1)];
    portionLine_.backgroundColor = [UIColor darkGrayColor];
    [self.recipeScrollView addSubview:portionLine_];
    
    //add ingredients
    UILabel *ingredientLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+objectBreak, labelWidth*2, textHeight)];
    ingredientLabel_.text = @"Ingredients";
    [self.recipeScrollView addSubview:ingredientLabel_];
    
    UICreateIngredientCell *ingredient = [[UICreateIngredientCell alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+objectBreak*2+textHeight, objectWidth, textHeight)];
    [self.recipeScrollView addSubview:ingredient];
    [self.ingredientAry addObject:ingredient];
    
    UIButton *addIngredientButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+objectBreak*3+textHeight*2, objectWidth, textHeight)];
    [addIngredientButton_ addTarget:self action:@selector(addIngredientTouch:) forControlEvents:UIControlEventTouchUpInside];
    [addIngredientButton_ setTitle:@"Add Ingredient" forState:UIControlStateNormal];
    addIngredientButton_.backgroundColor = [UIColor secondaryColor];
    addIngredientButton_.layer.cornerRadius = cornerRadius;
    addIngredientButton_.clipsToBounds = YES;
    [self.recipeScrollView addSubview:addIngredientButton_];
    self.addIngredientButton = addIngredientButton_;
    
    UIView *ingredientLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight, objectWidth, 1)];
    ingredientLine_.backgroundColor = [UIColor darkGrayColor];
    [self.recipeScrollView addSubview:ingredientLine_];
    self.ingredientLine = ingredientLine_;
    self.ingredientsHeight = portionsHeight+ingredientHeight;
    
    //add buttons
    UIButton *submitRecipeButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak , screenHeight-objectBreak-buttonHeight, objectWidth, buttonHeight)];
    [submitRecipeButton_ addTarget:self action:@selector(submitRecipeTouch:) forControlEvents:UIControlEventTouchUpInside];
    [submitRecipeButton_ setTitle:@"Submit Recipe" forState:UIControlStateNormal];
    //[createRecipeButton_ setBackgroundImage:[UIImage imageNamed:@"app_logo.png"] forState: UIControlStateHighlighted];
    //[createRecipeButton_ setBackgroundImage:[UIImage imageNamed:@"app_logo.png"] forState: UIControlStateSelected];
    submitRecipeButton_.backgroundColor = [UIColor secondaryColor];
    submitRecipeButton_.layer.cornerRadius = cornerRadius;
    submitRecipeButton_.clipsToBounds = YES;
    [self.view addSubview:submitRecipeButton_];
    self.submitRecipeButton = submitRecipeButton_;
    
    UIButton *backButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak, objectBreak+statusBarHeight, textHeight, textHeight)];
    [backButton_ addTarget:self action:@selector(backTouch:) forControlEvents:UIControlEventTouchUpInside];
    [backButton_ setTitle:@"Back" forState:UIControlStateNormal];
    backButton_.backgroundColor = [UIColor secondaryColor];
    backButton_.layer.cornerRadius = cornerRadius;
    backButton_.clipsToBounds = YES;
    [self.view addSubview:backButton_];
    self.backButton = backButton_;
    
}

@end
