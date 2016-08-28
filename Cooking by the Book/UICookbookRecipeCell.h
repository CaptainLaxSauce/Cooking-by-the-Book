//
//  UICookbookRecipeCell.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface UICookbookRecipeCell : UIView

@property UIImageView *imageView;
@property Recipe *recipe;
@property NSString *recipeID; //used so this object can be found using NSPredicate

-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame withRecipe:(Recipe*)Recipe_;

@end
