//
//  CreateRecipeViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToggleTagButton.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface CreateRecipeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic,strong) UIScrollView *recipeScrollView;
@property (nonatomic,strong) UIButton *submitRecipeButton;
@property (nonatomic,strong) UIButton *backButton;

@property (nonatomic,strong) UITextField *titleTextField;
@property (nonatomic,strong) UITextField *descTextField;

@property (nonatomic,strong) UITextField *prepTimeField;
@property (nonatomic,strong) UITextField *cookTimeField;
@property (nonatomic,strong)  UILabel *totTimeLabel;
@property (nonatomic) int totTime;

@property (nonatomic,strong) UIStepper *portionStepper;
@property (nonatomic,strong) UILabel *portionNumLabel;

@property (nonatomic,strong) UIButton *addIngredientButton;
@property (nonatomic,strong) UIButton *addStepButton;

@property (nonatomic,strong) UIToggleTagButton *quickTag;
@property (nonatomic,strong) UIToggleTagButton *simpleTag;
@property (nonatomic,strong) UIToggleTagButton *vegetarianTag;
@property (nonatomic,strong) UIToggleTagButton *veganTag;

@property (nonatomic,strong) NSMutableArray *ingredientAry;
@property (nonatomic,strong) NSMutableArray *stepAry;
@property (nonatomic,strong) NSMutableArray *tagAry;
@property (nonatomic,strong) UIImageView *recipeImageView;

@property (nonatomic,strong) NSMutableArray *moveAry;
@property (nonatomic) int ingredientIdx;

-(void)timeFieldChanged;

-(void)addIngredientTouch;
-(void)delIngredientTouch:(id)sender;

-(void)addStepTouch;
-(void)delStepTouch:(id)sender;

-(void)submitRecipeTouch:(id)sender;
-(void)imageTouch:(id)sender;
-(void)cameraTouch:(id)sender;
-(void)stepperValueChange:(id)sender;
-(void)shiftObjectsUp:(NSInteger)index;
-(void)shiftObjectsDown:(NSInteger)index;
-(void)loadInterface;
@end
