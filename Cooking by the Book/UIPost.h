//
//  UIPost.h
//  Cooking by the Book
//
//  Created by Jack Smith on 9/19/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface UIPost : UIView

-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame withRecipe:(Recipe *)recipe_;//not finished with params
@end
