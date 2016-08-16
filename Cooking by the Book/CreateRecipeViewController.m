//
//  CreateRecipeViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "TabBarControllerDelegate.h"
#import "CreateRecipeViewController.h"
#import "UIColor+CustomColors.h"
#import "UICreateIngredientCell.h"
#import "UICreateStepCell.h"
#import "Helper.h"
#import "DataClass.h"
#import "CookbookRecipe.h"

@implementation CreateRecipeViewController

static int objectBreak = 8;
static int cornerRadius = 3;
int objectWidth;
int textHeight;
int titleHeight;
int timeHeight;
int portionsHeight;
int ingredientHeight;
int imageViewHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
}

-(void)timeFieldChanged{
    self.totTime = [self.prepTimeField.text intValue] + [self.cookTimeField.text intValue];
    self.totTimeLabel.text = [NSString stringWithFormat:@"Total: %d minutes",self.totTime];
}

-(void)submitRecipeTouch:(id)sender{
    //create dictionary of objects to send
    
    NSLog(@"ingredientAry = %@",self.ingredientAry);
    NSLog(@"stepAry = %@",self.stepAry);
    
    NSMutableArray *ingredientAryJson = [[NSMutableArray alloc]init];
    for (int i = 1; i<=self.ingredientAry.count; i++){
        NSMutableDictionary *ingredientDictJson = [[NSMutableDictionary alloc]init];
        UICreateIngredientCell *tempIngredient = [self.ingredientAry objectAtIndex:i-1];
        [ingredientDictJson setObject:tempIngredient.titleTextField.text forKey:@"ingredientID"]; //Need to change this to do discrete lookup
        [ingredientDictJson setObject:tempIngredient.unitTextField.text forKey:@"ingredientUnitID"];
        [ingredientDictJson setObject:tempIngredient.quantityTextField.text forKey:@"ingredientUnitQuantity"];
        [ingredientAryJson addObject:ingredientDictJson];
    }
    
    
    NSMutableArray *stepAryJson = [[NSMutableArray alloc]init];
    for (int i = 1; i<=self.stepAry.count; i++){
        NSMutableDictionary *stepDictJson = [[NSMutableDictionary alloc]init];
        UICreateStepCell *tempStep = [self.stepAry objectAtIndex:i-1];
        [stepDictJson setObject:tempStep.textField.text forKey:@"stepDescription"];
        [stepAryJson addObject:stepDictJson];
        }
    
    NSMutableArray *tagAry = [[NSMutableArray alloc]init]; //there's probably a more elegant way to do this
    if (self.quickTag.tagged == TRUE){
        [tagAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"tagID", nil]];
    }
    if (self.simpleTag.tagged == TRUE){
        [tagAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"tagID", nil]];
    }
    if (self.vegetarianTag.tagged == TRUE){
        [tagAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"tagID", nil]];
    }
    if (self.veganTag.tagged == TRUE){
        [tagAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"3",@"tagID", nil]];
    }
    
    NSMutableDictionary* recipeDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.titleTextField.text,@"recipeTitle",
                                       self.descTextField.text,@"recipeDescription",
                                       self.portionNumLabel.text,@"recipePortionQuantity",
                                       self.prepTimeField.text,@"recipePrepTime",
                                       self.cookTimeField.text,@"recipeCookTime",
                                       [NSString stringWithFormat:@"%d",self.totTime],@"recipeTotalTime",
                                       ingredientAryJson,@"recipeIngredients",
                                       stepAryJson,@"recipeSteps",
                                       tagAry,@"recipeTags",
                                       nil];
    

    DataClass *obj = [DataClass getInstance];
    
    
    NSLog(@"userID in create recipe = %@",obj.userId);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:recipeDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [NSString stringWithFormat:@"user=%@&recipe=%@",obj.userId,jsonStr];
    NSLog(@"jsonStr = %@",jsonStr);
    NSData *postData = [jsonStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"createRecipe"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        
        NSString *ret_ = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"ret = %@",ret_);
        NSLog(@"response = %@",response);
        if ([ret_ intValue] > 0) {
            NSLog(@"Successful recipe post, id = %@",ret_);
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //change UI to show sending
                CookbookRecipe *newRecipe = [[CookbookRecipe alloc]initDetailedWithTitle:self.titleTextField.text withID:ret_ withDesc:self.descTextField.text withImage:nil withTagAry:tagAry withPrepTime:(NSNumber*)self.prepTimeField.text withCookTime:(NSNumber*)self.cookTimeField.text withTotTime:[NSNumber numberWithInt:self.totTime] withPortionNum:(NSNumber*)self.portionNumLabel.text withIngredientAry:ingredientAryJson withStepAry:stepAryJson];
                [obj addRecipe:newRecipe];
            });
            
        }
        
        else{
            NSLog(@"Recipe post failed");
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //change UI to show fail
            });
        }
    }];
    
    [dataTask resume];
    
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)backTouch:(id)sender{
    self.tabBarController.selectedIndex = 2;
   [self performSegueWithIdentifier:@"TabBarViewController" sender:sender];
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
    [self.ingredientAry removeObject:tempButton.superview];
    self.ingredientIdx = self.ingredientIdx-1;
}

-(void)addStepTouch{
    UICreateStepCell *step = [[UICreateStepCell alloc]initWithFrame:self.addStepButton.frame withNumber:self.stepAry.count+1 withDelBtn:TRUE];
    [step.delButton addTarget:self action:@selector(delStepTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger moveIndex = self.ingredientIdx+self.stepAry.count+4;
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
    [self.recipeScrollView setContentSize:CGSizeMake(self.view.frame.size.width,self.recipeScrollView.contentSize.height - textHeight - objectBreak)];
}

-(void)shiftObjectsDown:(NSInteger)index{
    for (NSInteger i=self.moveAry.count-1; i>index;i--){
        UIView *currView = [self.moveAry objectAtIndex:i];
        currView.frame = CGRectMake(currView.frame.origin.x, currView.frame.origin.y + textHeight + objectBreak, currView.frame.size.width, currView.frame.size.height);
        
        //shift down in moveAry
        [self.moveAry insertObject:[self.moveAry objectAtIndex:i] atIndex:i+1];
        [self.moveAry removeObjectAtIndex:i];
    }
    [self.recipeScrollView setContentSize:CGSizeMake(self.view.frame.size.width,self.recipeScrollView.contentSize.height + textHeight + objectBreak)];
}

-(void)imageTouch:(id)sender{
    NSLog(@"Image Touch");
    [self performSegueWithIdentifier:@"ImagePickerViewController" sender:sender];
    /*
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    */
    
}

-(void)loadInterface {
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    objectWidth = screenWidth - objectBreak*2;
    textHeight = screenHeight/20;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    int navBarHeight = self.navigationController.navigationBar.frame.size.height;
    int stepperWidth = 94;
    int tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    int scrollHeight = screenHeight-statusBarHeight-navBarHeight-textHeight-objectBreak*2-tabBarHeight;
    int labelWidth = (screenWidth-objectBreak*2)/10;
    int tagWidth = (screenWidth-objectBreak*3)/2;
    
    titleHeight = objectBreak*3+textHeight*2;
    timeHeight = objectBreak*2+textHeight;
    portionsHeight = objectBreak*2+textHeight+titleHeight+timeHeight;
    ingredientHeight = textHeight*3+objectBreak*4;
    imageViewHeight = screenWidth-objectBreak*2;
    
    self.view.backgroundColor = [UIColor primaryColor];
    self.navigationItem.title = @"Create Recipe";
    
    //add non-viewable objects
    NSMutableArray *moveAry_ = [[NSMutableArray alloc]init];
    NSMutableArray *ingredientAry_ = [[NSMutableArray alloc]init];
    NSMutableArray *stepAry_ = [[NSMutableArray alloc]init];
    
    //add scroll view
    UIScrollView *recipeScrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight+navBarHeight, screenWidth, scrollHeight)];
    recipeScrollView_.backgroundColor = [UIColor customGrayColor];
    recipeScrollView_.contentSize = CGSizeMake(screenWidth, titleHeight+timeHeight+portionsHeight+ingredientHeight*2+imageViewHeight);
    recipeScrollView_.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    titleLine_.backgroundColor = [UIColor lineColor];
    [self.recipeScrollView addSubview:titleLine_];
    
    //add times
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, titleHeight+objectBreak, labelWidth*1.6, textHeight)];
    timeLabel.text = @"Time";
    [self.recipeScrollView addSubview:timeLabel];
    
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(objectBreak+labelWidth*1.6, titleHeight+objectBreak, labelWidth*4, textHeight)];
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
    timeLine_.backgroundColor = [UIColor lineColor];
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
    portionLine_.backgroundColor = [UIColor lineColor];
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
    ingredientLine_.backgroundColor = [UIColor lineColor];
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
    stepLine_.backgroundColor = [UIColor lineColor];
    [self.recipeScrollView addSubview:stepLine_];
    [moveAry_ addObject:stepLine_];
    
    //add tags
    UILabel *tagLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight*2+objectBreak, objectWidth, textHeight)];
    tagLabel_.text = @"Tags";
    [self.recipeScrollView addSubview:tagLabel_];
    [moveAry_ addObject:tagLabel_];
    
    UIToggleTagButton *quickTag_ = [[UIToggleTagButton alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight*2+objectBreak*2+textHeight, tagWidth, textHeight) withTagType:0 withTagged:FALSE];
    [self.recipeScrollView addSubview:quickTag_];
    [moveAry_ addObject:quickTag_];
    self.quickTag = quickTag_;
    
    UIToggleTagButton *simpleTag_ = [[UIToggleTagButton alloc]initWithFrame:CGRectMake(objectBreak*2+tagWidth, portionsHeight+ingredientHeight*2+objectBreak*2+textHeight, tagWidth, textHeight) withTagType:1 withTagged:FALSE];
    [self.recipeScrollView addSubview:simpleTag_];
    [moveAry_ addObject:simpleTag_];
    self.simpleTag = simpleTag_;
    
    UIToggleTagButton *vegetarianTag_ = [[UIToggleTagButton alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight*2+objectBreak*3+textHeight*2, tagWidth, textHeight) withTagType:2 withTagged:FALSE];
    [self.recipeScrollView addSubview:vegetarianTag_];
    [moveAry_ addObject:vegetarianTag_];
    self.vegetarianTag = vegetarianTag_;
    
    UIToggleTagButton *veganTag_ = [[UIToggleTagButton alloc]initWithFrame:CGRectMake(objectBreak*2+tagWidth, portionsHeight+ingredientHeight*2+objectBreak*3+textHeight*2, tagWidth, textHeight) withTagType:3 withTagged:FALSE];
    [self.recipeScrollView addSubview:veganTag_];
    [moveAry_ addObject:veganTag_];
    self.veganTag = veganTag_;
    
    //add image picker
    UIImageView *imageSelectView = [[UIImageView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight*2+objectBreak*4+textHeight*3, screenWidth - objectBreak*2, screenWidth - objectBreak*2)];
    [imageSelectView setImage:[UIImage imageWithCGImage:[[UIImage imageNamed:@"addimage.png"] CGImage] scale:50/800 orientation:UIImageOrientationUp]];
    imageSelectView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTouch:)];
    [imageSelectView addGestureRecognizer:imageTap];
    [self.recipeScrollView addSubview:imageSelectView];
    
    //assign arrays to properties
    self.ingredientAry = ingredientAry_;
    self.stepAry = stepAry_;
    self.moveAry = moveAry_;
    NSLog(@"end of loadInterface stepAry cnt = %lu",(unsigned long)self.stepAry.count);
    
    //add buttons
    UIButton *submitRecipeButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak , screenHeight-objectBreak-textHeight-tabBarHeight, objectWidth, textHeight)];
    [submitRecipeButton_ addTarget:self action:@selector(submitRecipeTouch:) forControlEvents:UIControlEventTouchUpInside];
    [submitRecipeButton_ setTitle:@"Submit Recipe" forState:UIControlStateNormal];
    //[createRecipeButton_ setBackgroundImage:[UIImage imageNamed:@"app_logo.png"] forState: UIControlStateHighlighted];
    //[createRecipeButton_ setBackgroundImage:[UIImage imageNamed:@"app_logo.png"] forState: UIControlStateSelected];
    submitRecipeButton_.backgroundColor = [UIColor secondaryColor];
    submitRecipeButton_.layer.cornerRadius = cornerRadius;
    submitRecipeButton_.clipsToBounds = YES;
    [self.view addSubview:submitRecipeButton_];
    self.submitRecipeButton = submitRecipeButton_;

}

@end
