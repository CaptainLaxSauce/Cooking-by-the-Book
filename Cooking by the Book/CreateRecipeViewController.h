//
//  CreateRecipeViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToggleTagButton.h"

@interface CreateRecipeViewController : UIViewController

@property UIScrollView *recipeScrollView;
@property UIButton *submitRecipeButton;
@property UIButton *backButton;

@property UITextField *titleTextField;
@property UITextField *descTextField;

@property UITextField *prepTimeField;
@property UITextField *cookTimeField;
@property UILabel *totTimeLabel;
@property int totTime;

@property UIStepper *portionStepper;
@property UILabel *portionNumLabel;

@property UIButton *addIngredientButton;
@property UIButton *addStepButton;

@property UIToggleTagButton *quickTag;
@property UIToggleTagButton *simpleTag;
@property UIToggleTagButton *vegetarianTag;
@property UIToggleTagButton *veganTag;

@property NSMutableArray *ingredientAry;
@property NSMutableArray *stepAry;
@property NSMutableArray *tagAry;

@property (nonatomic,strong) NSMutableArray *moveAry;
@property int ingredientIdx;

-(void)timeFieldChanged;

-(void)addIngredientTouch;
-(void)delIngredientTouch:(id)sender;

-(void)addStepTouch;
-(void)delStepTouch:(id)sender;

-(void)submitRecipeTouch:(id)sender;
-(void)backTouch:(id)sender;
-(void)stepperValueChange:(id)sender;
-(void)shiftObjectsUp:(NSInteger)index;
-(void)shiftObjectsDown:(NSInteger)index;
-(void)loadInterface;
@end
