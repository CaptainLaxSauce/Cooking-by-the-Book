//
//  Recipe.h
//  Cooking by the Book
//
//  Created by Jack Smith on 7/18/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Recipe : NSObject

@property NSString *title;
@property NSString *status;
@property NSString *recipeCreateUser;
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
@property NSString *imageName;

-(id)init;
-(id)initBasicWithTitle:(NSString *)title_ withID:(NSString *)recipeID_ withDesc:(NSString *)desc_ withImageName:(NSString*)imageName_ withTagAry:(NSArray *)tagAry_;
-(id)initWithDictionary:(NSDictionary *)dict;
-(id)initDetailedWithTitle:(NSString *)title_ withID:(NSString *)recipeID_ withDesc:(NSString *)desc_ withImageName:(NSString *)imageName_ withTagAry:(NSArray *)tagAry_ withPrepTime:(NSNumber *)prepTime_ withCookTime:(NSNumber *)cookTime_ withTotTime:(NSNumber *)totTime_ withPortionNum:(NSNumber *)portionNum_ withIngredientAry:(NSArray *)ingredientAry_ withStepAry:(NSArray *)stepAry_ withImage:(UIImage *)image_;
@end
