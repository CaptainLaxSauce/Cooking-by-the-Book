//
//  UICookbookRecipeCell.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CookbookRecipe.h"

@interface UICookbookRecipeCell : UIView

@property UIImageView *imageView;
@property CookbookRecipe *recipe;

-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame withCookbookRecipe:(CookbookRecipe*)cookbookRecipe_;

@end
