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
#import "UICreateStepCell.h"

@implementation CreateRecipeViewController

static int objectBreak = 8;
static int cornerRadius = 3;
int screenHeight;
int screenWidth;
int objectWidth;
int textHeight;
int titleHeight;
int timeHeight;
int portionsHeight;
int ingredientHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
}

-(void)timeFieldChanged{
    int totTime = [self.prepTimeField.text intValue] + [self.cookTimeField.text intValue];
    self.totTimeLabel.text = [NSString stringWithFormat:@"Total: %d minutes",totTime];
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

-(void)addIngredientTouch{
    UICreateIngredientCell *ingredient = [[UICreateIngredientCell alloc]initWithFrame:self.addIngredientButton.frame withDelBtn:YES];
    self.ingredientIdx = self.ingredientIdx+1;
    [ingredient.delButton addTarget:self action:@selector(delIngredientTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.moveAry insertObject:ingredient atIndex:self.ingredientIdx];
    [self shiftObjectsDown:self.ingredientIdx];
    [self.recipeScrollView addSubview:ingredient];
    [self.ingredientAry addObject:ingredient];
}

-(void)delIngredientTouch:(id)sender{
    UIButton *tempButton = [sender self];
    NSInteger index = [self.moveAry indexOfObject:tempButton.superview];
    [self.moveAry removeObjectAtIndex:index];
    [self shiftObjectsUp:index];
    self.ingredientIdx = self.ingredientIdx-1;
}

-(void)addStepTouch{
    UICreateStepCell *step = [[UICreateStepCell alloc]initWithFrame:self.addStepButton.frame withNumber:self.stepAry.count+1 withDelBtn:TRUE];
    [step.delButton addTarget:self action:@selector(delStepTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger moveIndex = self.ingredientIdx+self.stepAry.count+4;
    NSLog(@"stepAry count = %ld",(long)self.stepAry.count);
    NSLog(@"moveIndex = %ld",(long)moveIndex);
    NSLog(@"move ary cnt = %ld",(long)self.moveAry.count);
    
    [self.moveAry insertObject:step atIndex:moveIndex];
    [self shiftObjectsDown:moveIndex];
    [self.recipeScrollView addSubview:step];
    [self.stepAry addObject:step];
}

-(void)delStepTouch:(id)sender{
    UIButton *tempButton = [sender self];
    NSInteger moveIndex = [self.moveAry indexOfObject:tempButton.superview];
    [self.moveAry removeObjectAtIndex:moveIndex];
    [self shiftObjectsUp:moveIndex];

    NSInteger stepIndex = [self.stepAry indexOfObject:tempButton.superview];
    [self.stepAry removeObjectAtIndex:stepIndex];
    
    for (NSInteger i = stepIndex-1;i<self.stepAry.count;i++){
        UICreateStepCell *tempStepCell = [self.stepAry objectAtIndex:i];
        [tempStepCell updateNum:i+1];
    }
    
    
}

-(void)shiftObjectsUp:(NSInteger)index{
    
    for (NSInteger i=index; i<self.moveAry.count;i++){
        UIView *currView = [self.moveAry objectAtIndex:i];
        currView.frame = CGRectMake(currView.frame.origin.x, currView.frame.origin.y - textHeight - objectBreak, currView.frame.size.width, currView.frame.size.height);
    }
}

-(void)shiftObjectsDown:(NSInteger)index{
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
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    int stepperWidth = 94;
    int scrollHeight = screenHeight-statusBarHeight-textHeight*2-objectBreak*4;
    int labelWidth = (screenWidth-objectBreak*2)/10;
    
    titleHeight = objectBreak*3+textHeight*2;
    timeHeight = objectBreak*2+textHeight;
    portionsHeight = objectBreak*2+textHeight+titleHeight+timeHeight;
    ingredientHeight = textHeight*3+objectBreak*4;
    
    self.view.backgroundColor = [UIColor primaryColor];
    
    //add non-viewable objects
    NSMutableArray *moveAry_ = [[NSMutableArray alloc]init];
    NSMutableArray *ingredientAry_ = [[NSMutableArray alloc]init];
    NSMutableArray *stepAry_ = [[NSMutableArray alloc]init];
    
    //add scroll view
    UIScrollView *recipeScrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight+objectBreak*2+textHeight, screenWidth, scrollHeight)];
    recipeScrollView_.backgroundColor = [UIColor customGrayColor];
    recipeScrollView_.contentSize = CGSizeMake(screenWidth, screenHeight*2);
    [self.view addSubview:recipeScrollView_];
    self.recipeScrollView = recipeScrollView_;
    
    //add title and description
    UITextField *titleTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, objectBreak, objectWidth, textHeight)];
    titleTextField_.placeholder = @"Title";
    titleTextField_.backgroundColor = [UIColor whiteColor];
    titleTextField_.layer.cornerRadius = cornerRadius;
    titleTextField_.clipsToBounds = YES;
    [self.recipeScrollView addSubview:titleTextField_];
    self.titleTextField = titleTextField_;
    
    UITextField *descTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, objectBreak*2 + textHeight, objectWidth, textHeight)];
    descTextField_.placeholder = @"Description (optional)";
    descTextField_.backgroundColor = [UIColor whiteColor];
    descTextField_.backgroundColor = [UIColor whiteColor];
    descTextField_.layer.cornerRadius = cornerRadius;
    [self.recipeScrollView addSubview:descTextField_];
    self.descTextField = descTextField_;
    
    UIView *titleLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, titleHeight, objectWidth, 1)];
    titleLine_.backgroundColor = [UIColor darkGrayColor];
    [self.recipeScrollView addSubview:titleLine_];
    
    //add times
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, titleHeight+objectBreak, labelWidth*2, textHeight)];
    timeLabel.text = @"Time";
    [self.recipeScrollView addSubview:timeLabel];
    
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(objectBreak+labelWidth*2, titleHeight+objectBreak, labelWidth*4, textHeight)];
    timeView.backgroundColor = [UIColor whiteColor];
    timeView.layer.cornerRadius = cornerRadius;
    timeView.clipsToBounds = YES;
    [self.recipeScrollView addSubview:timeView];
    
    UITextField *prepTimeField_ = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, timeView.frame.size.width/2, timeView.frame.size.height)];
    prepTimeField_.placeholder = @"Prep";
    [prepTimeField_ addTarget:self action:@selector(timeFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [prepTimeField_ setKeyboardType:UIKeyboardTypeNumberPad];
    [timeView addSubview:prepTimeField_];
    self.prepTimeField = prepTimeField_;
    
    UITextField *cookTimeField_ = [[UITextField alloc]initWithFrame:CGRectMake(timeView.frame.size.width/2, 0, timeView.frame.size.width/2, timeView.frame.size.height)];
    cookTimeField_.placeholder = @"Cook";
    [cookTimeField_ addTarget:self action:@selector(timeFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [cookTimeField_ setKeyboardType:UIKeyboardTypeNumberPad];
    [timeView addSubview:cookTimeField_];
    self.cookTimeField = cookTimeField_;
    
    UILabel *totTimeLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak*2+labelWidth*6, titleHeight+objectBreak, labelWidth*5, textHeight)];
    totTimeLabel_.text = @"Total: 0 minutes";
    [self.recipeScrollView addSubview:totTimeLabel_];
    self.totTimeLabel = totTimeLabel_;
    
    UIView *timeLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, titleHeight+objectBreak*2+textHeight, objectWidth, 1)];
    timeLine_.backgroundColor = [UIColor darkGrayColor];
    [self.recipeScrollView addSubview:timeLine_];
    
    //add portions
    UIStepper *portionStepper_ = [[UIStepper alloc]initWithFrame:CGRectMake(screenWidth-objectBreak-stepperWidth, objectBreak+titleHeight+timeHeight+2, 0, 0)];
    portionStepper_.minimumValue = 1;
    portionStepper_.value = 4;
    [portionStepper_ addTarget:self action:@selector(stepperValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.recipeScrollView addSubview:portionStepper_];
    self.portionStepper = portionStepper_;
    
    UILabel *portionNumLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-objectBreak*2-stepperWidth-labelWidth, objectBreak+titleHeight+timeHeight, labelWidth, textHeight)];
    portionNumLabel_.text = [NSString stringWithFormat:@"%d",(int)self.portionStepper.value];
    [self.recipeScrollView addSubview:portionNumLabel_];
    self.portionNumLabel = portionNumLabel_;
    
    UILabel *portionLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak+titleHeight+timeHeight, labelWidth*4, textHeight)];
    portionLabel_.text = @"Portions";
    [self.recipeScrollView addSubview:portionLabel_];
    
    UIView *portionLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight, objectWidth, 1)];
    portionLine_.backgroundColor = [UIColor darkGrayColor];
    [self.recipeScrollView addSubview:portionLine_];
    
    //add ingredients
    UILabel *ingredientLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+objectBreak, labelWidth*4, textHeight)];
    ingredientLabel_.text = @"Ingredients";
    [self.recipeScrollView addSubview:ingredientLabel_];
    
    UICreateIngredientCell *ingredient_ = [[UICreateIngredientCell alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+objectBreak*2+textHeight, objectWidth, textHeight) withDelBtn:FALSE];
    [self.recipeScrollView addSubview:ingredient_];
    [ingredientAry_ addObject:ingredient_];
    [moveAry_ addObject:ingredient_];
    
    UIButton *addIngredientButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+objectBreak*3+textHeight*2, objectWidth, textHeight)];
    [addIngredientButton_ addTarget:self action:@selector(addIngredientTouch) forControlEvents:UIControlEventTouchUpInside];
    [addIngredientButton_ setTitle:@"Add Ingredient" forState:UIControlStateNormal];
    addIngredientButton_.backgroundColor = [UIColor secondaryColor];
    addIngredientButton_.layer.cornerRadius = cornerRadius;
    addIngredientButton_.clipsToBounds = YES;
    [self.recipeScrollView addSubview:addIngredientButton_];
    self.addIngredientButton = addIngredientButton_;
    [moveAry_ addObject:addIngredientButton_];
    
    UIView *ingredientLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight, objectWidth, 1)];
    ingredientLine_.backgroundColor = [UIColor darkGrayColor];
    [self.recipeScrollView addSubview:ingredientLine_];
    [moveAry_ addObject:ingredientLine_];
    self.ingredientIdx=0;
    
    //add steps
    UILabel *stepLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight+objectBreak, objectWidth, textHeight)];
    stepLabel_.text = @"Steps";
    [self.recipeScrollView addSubview:stepLabel_];
    [moveAry_ addObject:stepLabel_];
    
    UICreateStepCell *step_ = [[UICreateStepCell alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight+objectBreak*2+textHeight, objectWidth, textHeight) withNumber:1 withDelBtn:FALSE];
    [self.recipeScrollView addSubview:step_];
    [stepAry_ addObject:step_];
    [moveAry_ addObject:step_];
    
    UIButton *addStepButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight+objectBreak*3+textHeight*2, objectWidth, textHeight)];
    [addStepButton_ addTarget:self action:@selector(addStepTouch) forControlEvents:UIControlEventTouchUpInside];
    [addStepButton_ setTitle:@"Add Step" forState:UIControlStateNormal];
    addStepButton_.backgroundColor = [UIColor secondaryColor];
    addStepButton_.layer.cornerRadius = cornerRadius;
    addStepButton_.clipsToBounds = YES;
    [self.recipeScrollView addSubview:addStepButton_];
    self.addStepButton = addStepButton_;
    [moveAry_ addObject:addStepButton_];
    
    UIView *stepLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight+objectBreak*4+textHeight*3, objectWidth, 1)];
    stepLine_.backgroundColor = [UIColor darkGrayColor];
    [self.recipeScrollView addSubview:stepLine_];
    [moveAry_ addObject:stepLine_];
    
    //add tags
    
    
    //assign arrays to properties
    self.ingredientAry = ingredientAry_;
    self.stepAry = stepAry_;
    self.moveAry = moveAry_;
    NSLog(@"end of loadInterface stepAry cnt = %lu",(unsigned long)self.stepAry.count);
    
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
