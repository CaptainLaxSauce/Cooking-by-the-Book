//
//  CookbookViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookbookViewController : UIViewController

typedef enum TagType : int{
    quick = 0,
    simple = 1,
    vegetarian = 2,
    vegan = 3
    
} TagType;

@property UIScrollView *recipeScrollView;
@property UIButton *createRecipeButton;

-(void)createRecipeTouch:(id)sender;
-(void)loadInterface;

@end
