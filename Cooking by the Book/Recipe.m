//
//  Recipe.m
//  Cooking by the Book
//
//  Created by Jack Smith on 7/18/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "Recipe.h"
#import "AppDelegate.h"



@implementation Recipe

-(id)init{
    return [self initBasicWithTitle:nil withID:nil withDesc:nil withImageName:nil withTagAry:nil];
}

-(id)initBasicWithTitle:(NSString *)title_ withID:(NSString *)recipeID_ withDesc:(NSString *)desc_ withImageName:(NSString *)imageName_ withTagAry:(NSArray *)tagAry_{
    return [self initDetailedWithTitle:title_ withID:recipeID_ withDesc:desc_ withImageName:imageName_ withTagAry:tagAry_ withPrepTime:nil withCookTime:nil withTotTime:nil withPortionNum:nil withIngredientAry:nil withStepAry:nil withImage:nil];
}

-(id)initDetailedWithTitle:(NSString *)title_ withID:(NSString *)recipeID_ withDesc:(NSString *)desc_ withImageName:(NSString *)imageName_ withTagAry:(NSArray *)tagAry_ withPrepTime:(NSNumber*)prepTime_ withCookTime:(NSNumber*)cookTime_ withTotTime:(NSNumber*)totTime_ withPortionNum:(NSNumber*)portionNum_ withIngredientAry:(NSArray *)ingredientAry_ withStepAry:(NSArray *)stepAry_ withImage:(UIImage *)image_{
    
    self = [super init];
    
    if (self){
        self.title = title_;
        self.recipeID = recipeID_;
        self.desc = desc_;
        self.imageName = imageName_;
        self.image = image_;
        self.tagAry = tagAry_;
        self.prepTime = prepTime_;
        self.cookTime = cookTime_;
        self.totTime = totTime_;
        self.portionNum = portionNum_;
        self.ingredientAry = ingredientAry_;
        self.stepAry = stepAry_;
        
    }
    
    return self;
}

@end
