//
//  CreateRecipeViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateRecipeViewController : UIViewController

@property UIScrollView *recipeScrollView;
@property UIButton *submitRecipeButton;
@property UIButton *backButton;

@property UIStepper *portionStepper;
@property UILabel *portionNumLabel;

@property UIButton *addIngredientButton;
@property UIView *ingredientLine;
@property int ingredientsHeight;

@property NSMutableArray *ingredientAry;
@property NSMutableArray *stepAry;
@property NSMutableArray *tagAry;

-(void)addIngredientTouch:(id)sender;
-(void)submitRecipeTouch:(id)sender;
-(void)backTouch:(id)sender;
-(void)stepperValueChange:(id)sender;
-(void)loadInterface;
@end
