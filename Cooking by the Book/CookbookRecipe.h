//
//  CookbookRecipe.h
//  Cooking by the Book
//
//  Created by Jack Smith on 7/18/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CookbookRecipe : NSObject

@property NSString *title;
@property NSString *recipeID;
@property NSString *desc;
@property NSArray *tagAry;
@property NSNumber *prepTime;
@property NSNumber *cookTime;
@property NSNumber *totTime;
@property NSNumber *portionNum;
@property NSArray *ingredientAry;
@property NSArray *stepAry;
@property UIImage *image;

-(id)init;
-(id)initBasicWithTitle:(NSString *)title_ withID:(NSString *)recipeID_ withDesc:(NSString *)desc_ withImage:(UIImage *)image_ withTagAry:(NSArray *)tagAry_;
-(id)initDetailedWithTitle:(NSString *)title_ withID:(NSString *)recipeID_ withDesc:(NSString *)desc_ withImage:(UIImage *)image_ withTagAry:(NSArray *)tagAry_ withPrepTime:(NSNumber *)prepTime_ withCookTime:(NSNumber *)cookTime_ withTotTime:(NSNumber *)totTime_ withPortionNum:(NSNumber *)portionNum_ withIngredientAry:(NSArray *)ingredientAry_ withStepAry:(NSArray *)stepAry_;
@end
