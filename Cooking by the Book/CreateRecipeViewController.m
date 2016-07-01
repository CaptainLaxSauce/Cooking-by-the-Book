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
int portionsHeight;
int ingredientHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadInterface];
    
}

-(void)addIngredientTouch{
    UICreateIngredientCell *ingredient = [[UICreateIngredientCell alloc]initWithFrame:self.addIngredientButton.frame withDelBtn:YES];
    self.ingredientIdx = self.ingredientIdx+1;
    [ingredient.delButton addTarget:self action:@selector(delIngredientTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.moveAry insertObject:ingredient atIndex:self.ingredientIdx];
    [self shiftObjectsDown:self.ingredientIdx];
    [self.recipeScrollView addSubview:ingredient];
    [self.ingredientAry addObject:ingredient];
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

-(void)delIngredientTouch:(id)sender{
    UIButton *tempButton = [sender self];
    NSInteger index = [self.moveAry indexOfObject:tempButton.superview];
    NSLog(@"index jack = %ld",(long)index);
    [self.moveAry removeObjectAtIndex:index];
    [self shiftObjectsUp:index];
    self.ingredientIdx = self.ingredientIdx-1;
}

-(void)shiftObjectsUp:(NSInteger)index{
    
    for (NSInteger i=index; i<self.moveAry.count;i++){
        UIView *currView = [self.moveAry objectAtIndex:i];
        currView.frame = CGRectMake(currView.frame.origin.x, currView.frame.origin.y - textHeight - objectBreak, currView.frame.size.width, currView.frame.size.height);
    }
}


-(void)shiftObjectsDown:(int)index{
    for (NSInteger i=self.moveAry.count-1; i>index;i--){
        UIView *currView = [self.moveAry objectAtIndex:i];
        currView.frame = CGRectMake(currView.frame.origin.x, currView.frame.origin.y + textHeight + objectBreak, currView.frame.size.width, currView.frame.size.height);
        
        //shift down in moveAry
        [self.moveAry insertObject:[self.moveAry objectAtIndex:i] atIndex:i+1];
        [self.moveAry removeObjectAtIndex:i];
        NSLog(@"down loop i = %ld",(long)i);
    }
    NSLog(@"Move ary count after down= %lu",(unsigned long)self.moveAry.count);
}


-(void)loadInterface {
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    objectWidth = screenWidth - objectBreak*2;
    textHeight = screenHeight/20;
    int tabHeight = self.tabBarController.tabBar.frame.size.height;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    int stepperWidth = 94;
    int scrollHeight = screenHeight-tabHeight-statusBarHeight-textHeight-objectBreak*2;
    int labelWidth = screenWidth/5;
    
    portionsHeight = objectBreak*2+textHeight;
    ingredientHeight = textHeight*3+objectBreak*4;
    
    self.view.backgroundColor = [UIColor primaryColor];
    
    //add non-viewable objects
    NSMutableArray *moveAry_ = [[NSMutableArray alloc]init];
    
    //add scroll view
    UIScrollView *recipeScrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight+objectBreak*2+textHeight, screenWidth, scrollHeight)];
    recipeScrollView_.backgroundColor = [UIColor customGrayColor];
    recipeScrollView_.contentSize = CGSizeMake(screenWidth, screenHeight*2);
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
    
    UICreateIngredientCell *ingredient_ = [[UICreateIngredientCell alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+objectBreak*2+textHeight, objectWidth, textHeight) withDelBtn:FALSE];
    [self.recipeScrollView addSubview:ingredient_];
    [self.ingredientAry addObject:ingredient_];
    [moveAry_ insertObject:ingredient_ atIndex:0];
    
    UIButton *addIngredientButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+objectBreak*3+textHeight*2, objectWidth, textHeight)];
    [addIngredientButton_ addTarget:self action:@selector(addIngredientTouch) forControlEvents:UIControlEventTouchUpInside];
    [addIngredientButton_ setTitle:@"Add Ingredient" forState:UIControlStateNormal];
    addIngredientButton_.backgroundColor = [UIColor secondaryColor];
    addIngredientButton_.layer.cornerRadius = cornerRadius;
    addIngredientButton_.clipsToBounds = YES;
    [self.recipeScrollView addSubview:addIngredientButton_];
    self.addIngredientButton = addIngredientButton_;
    [moveAry_ insertObject:addIngredientButton_ atIndex:1];
    
    UIView *ingredientLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight, objectWidth, 1)];
    ingredientLine_.backgroundColor = [UIColor darkGrayColor];
    [self.recipeScrollView addSubview:ingredientLine_];
    self.ingredientLine = ingredientLine_;
    [moveAry_ insertObject:ingredientLine_ atIndex:2];
    self.ingredientIdx=0;
    self.moveAry = moveAry_;
    NSLog(@"moveAry cnt = %lu",moveAry_.count);
    
    //add buttons
    UIButton *submitRecipeButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak , screenHeight-objectBreak-textHeight, objectWidth, textHeight)];
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
