//
//  Recipe.m
//  Cooking by the Book
//
//  Created by Jack Smith on 7/18/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "Recipe.h"
#import "AppDelegate.h"
#import "Helper.h"
#import "DataClass.h"
#import "Constants.h"
#import "Ingredient.h"



@implementation Recipe

-(id)initBasicWithTitle:(NSString *)title_ withID:(NSString *)recipeID_ withDesc:(NSString *)desc_ withImageName:(NSString *)imageName_ withTagAry:(NSArray *)tagAry_ withRating:(NSNumber *)rating_{
    return [self initDetailedWithTitle:title_ withID:recipeID_ withDesc:desc_ withImageName:imageName_ withTagAry:tagAry_ withPrepTime:nil withCookTime:nil withTotTime:nil withPortionNum:nil withIngredientAry:nil withStepAry:nil withRating:rating_];
}

-(id)initWithJSONDictionary:(NSDictionary *)dict{
    
    return[self initDetailedWithTitle:[dict objectForKey:@"recipeTitle"]
                               withID:[dict objectForKey:@"recipeID"]
                             withDesc:[dict objectForKey:@"recipeDescription"]
                        withImageName:[dict objectForKey:@"recipeImage"]
                           withTagAry:[self getTagAryFromJSON:[dict objectForKey:@"tagInfo"]]
                         withPrepTime:[dict objectForKey:@"recipeTimePrep"]
                         withCookTime:[dict objectForKey:@"recipeTimeCook"]
                          withTotTime:[dict objectForKey:@"recipeTimeTotal"]
                       withPortionNum:[dict objectForKey:@"recipePortions"]
                    withIngredientAry:[self getIngredientAryFromJSON:[dict objectForKey:@"ingredientInfo"]]
                          withStepAry:[self getStepAryFromJSON:[dict objectForKey:@"stepInfo"]]
                           withRating:[dict objectForKey:@"recipeRating"]];
}

-(id)initDetailedWithTitle:(NSString *)title_ withID:(NSString *)recipeID_ withDesc:(NSString *)desc_ withImageName:(NSString *)imageName_ withTagAry:(NSArray *)tagAry_ withPrepTime:(NSNumber*)prepTime_ withCookTime:(NSNumber*)cookTime_ withTotTime:(NSNumber*)totTime_ withPortionNum:(NSNumber*)portionNum_ withIngredientAry:(NSArray *)ingredientAry_ withStepAry:(NSArray *)stepAry_ withRating:(NSNumber *)rating_{
    
    self = [super init];
    
    if (self){
        self.title = title_;
        self.recipeID = recipeID_;
        self.desc = desc_;
        self.imageName = imageName_;
        self.tagAry = tagAry_;
        self.prepTime = prepTime_;
        self.cookTime = cookTime_;
        self.totTime = totTime_;
        self.portionNum = portionNum_;
        self.ingredientAry = ingredientAry_;
        self.stepAry = stepAry_;
        self.rating = rating_;
        
    }
    
    return self;
}

/*
-(id)initWithIdWeb:(NSString *)recipeId{
    //obj = [DataClass getInstance];
    //[Helper submitHTTPPostWithString:[NSString stringWithFormat:@"userID=%@&recipeID=%@",obj.userId,recipeId] withURLEnd:@"getRecipe" withCompletionHandler:[self get]
    return self;
}

-(CompletionWeb)getRecipeCompletion{
    CompletionWeb recipeCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
        NSDictionary *recipeDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:nil];
        NSDictionary *recipeInfoDict = [recipeDict objectForKey:@"recipeInfo"];
        
        [self initWithJSONDictionary:recipeInfoDict];
    }
    return recipeCompletion;
}
*/
 
-(NSMutableArray *)getTagAryFromJSON:(NSArray *)jsonTagAry{
    NSMutableArray *tagAry = [[NSMutableArray alloc]init];
    for (int i = 0;i<jsonTagAry.count;i++){
        NSDictionary *tagDict = [jsonTagAry objectAtIndex:i];
        if ([tagDict objectForKey:@"tagID"] != (id)[NSNull null]){
            [tagAry addObject:[tagDict objectForKey:@"tagID"]];
        }
        
    }
    return tagAry;
}

-(NSMutableArray *)getIngredientAryFromJSON:(NSArray *)jsonIngAry{
    NSMutableArray *ingAry = [[NSMutableArray alloc]init];
    for (int i = 0; i < jsonIngAry.count; i++){
        NSDictionary *ingDict = [jsonIngAry objectAtIndex:i];
        Ingredient *ing = [[Ingredient alloc]initWithTitle:[ingDict objectForKey:@"title"]
                                                   withID:nil
                                             withUnitName:[ingDict objectForKey:@"unitName"]
                                         withUnitQuantity:[ingDict objectForKey:@"unitQuantity"]];
        
        if (![ing.title  isEqual: @""]){
            [ingAry addObject:ing];
        }
    }
    
    return ingAry;
}

-(NSMutableArray *)getStepAryFromJSON:(NSArray *)jsonStepAry{
    NSMutableArray *stepAry =[[NSMutableArray alloc]init];
    for (int i = 0; i < jsonStepAry.count; i++){
        NSDictionary *stepDict = [jsonStepAry objectAtIndex:i];
        NSString *step = [stepDict objectForKey:@"stepDescription"];
        if (![step  isEqual: @""]){
            [stepAry addObject:step];
        }
    }
    
    return stepAry;
}

@end
