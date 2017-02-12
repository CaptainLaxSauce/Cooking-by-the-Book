//
//  SearchRecipeViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 1/14/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchRecipeViewController : UIViewController

@property (nonatomic,strong) NSArray *textFieldAry;
@property (nonatomic,strong) NSMutableArray *recipeAry; //an array of recipe class objects

@end
