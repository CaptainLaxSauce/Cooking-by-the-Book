//
//  DetailedRecipeViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 8/10/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface DetailedRecipeViewController : UIViewController

@property (nonatomic,strong) NSString *recipeID;
@property (nonatomic,strong) Recipe *recipe;
@property (nonatomic,strong) UIScrollView *scrollView;


@end
