//
//  CookbookRecipe.m
//  Cooking by the Book
//
//  Created by Jack Smith on 7/18/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "CookbookRecipe.h"
#import "AppDelegate.h"



@implementation CookbookRecipe

@synthesize title = _title;


-(id)init{
    return [self initWithTitle:nil withID:nil withDesc:nil withTagAry:nil withPrepTime:0 withCookTime:0 withTotTime:0 withPortionNum:0 withIngredientAry:nil withStepAry:nil withImage:nil];
}

-(id)initWithTitle:(NSString *)title_ withID:(NSString *)recipeID_ withDesc:(NSString *)desc_ withTagAry:(NSArray *)tagAry_ withPrepTime:(NSNumber*)prepTime_ withCookTime:(NSNumber*)cookTime_ withTotTime:(NSNumber*)totTime_ withPortionNum:(NSNumber*)portionNum_ withIngredientAry:(NSArray *)ingredientAry_ withStepAry:(NSArray *)stepAry_ withImage:(UIImage *)image_{
    
    self = [super init];
    
    if (self){
        self.title = title_;
        self.recipeID = recipeID_;
        self.desc = desc_;
        self.tagAry = tagAry_;
        self.prepTime = prepTime_;
        self.cookTime = cookTime_;
        self.totTime = totTime_;
        self.portionNum = portionNum_;
        self.ingredientAry = ingredientAry_;
        self.stepAry = stepAry_;
        self.image = image_;
        
    }
    
    return self;
}

@end