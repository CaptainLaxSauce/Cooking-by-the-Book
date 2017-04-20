//
//  SearchRecipeViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 1/14/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAutocompleteTextField.h"

@interface SearchRecipeViewController : UIViewController

@property (nonatomic,strong) NSArray *textFieldAry;
@property (nonatomic,strong) NSMutableArray *recipeAry; //an array of recipe class objects
@property (weak, nonatomic) IBOutlet UIScrollView *keywordScrollView;
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;
@property (weak, nonatomic) IBOutlet UIButton *keywordAddButton;
@property (weak, nonatomic) IBOutlet UIStackView *keywordStackView;
@property (weak, nonatomic) IBOutlet UILabel *keywordLabel;
@property (weak, nonatomic) IBOutlet UIButton *keywordDeleteButton;
@property (weak, nonatomic) IBOutlet HTAutocompleteTextField *ingredientTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *ingredientScrollView;
@property (weak, nonatomic) IBOutlet UIButton *ingredientAddButton;
@property (weak, nonatomic) IBOutlet UIStackView *ingredientStackView;
@property (weak, nonatomic) IBOutlet UILabel *ingredientLabel;
@property (weak, nonatomic) IBOutlet UIButton *ingredientDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

- (IBAction)addKeyword:(id)sender;
- (IBAction)addIngredient:(id)sender;

@end
