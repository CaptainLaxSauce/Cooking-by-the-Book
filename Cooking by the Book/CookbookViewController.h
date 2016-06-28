//
//  CookbookViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookbookViewController : UIViewController

@property UIScrollView *recipeScrollView;
@property UIButton *createRecipeButton;

-(void)createRecipeTouch:(id)sender;
-(void)loadInterface;

@end
