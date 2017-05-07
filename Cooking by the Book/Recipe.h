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

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *recipeCreateUser;
@property (nonatomic,strong) NSString *recipeCreateUserName;
@property (nonatomic,strong) NSString *recipeID;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSArray *tagAry;
@property (nonatomic,strong) NSNumber *prepTime;
@property (nonatomic,strong) NSNumber *cookTime;
@property (nonatomic,strong) NSNumber *totTime;
@property (nonatomic,strong) NSNumber *portionNum;
@property (nonatomic,strong) NSArray *ingredientAry;
@property (nonatomic,strong) NSArray *stepAry;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) NSNumber *rating;

-(id)initBasicWithTitle:(NSString *)title_
                 withID:(NSString *)recipeID_
               withDesc:(NSString *)desc_
          withImageName:(NSString*)imageName_
             withTagAry:(NSArray *)tagAry_
             withRating:(NSNumber *)rating_;

-(id)initWithJSONDictionary:(NSDictionary *)dict;

-(id)initDetailedWithTitle:(NSString *)title_
                    withID:(NSString *)recipeID_
                  withDesc:(NSString *)desc_
             withImageName:(NSString *)imageName_
                withTagAry:(NSArray *)tagAry_
              withPrepTime:(NSNumber *)prepTime_
              withCookTime:(NSNumber *)cookTime_
               withTotTime:(NSNumber *)totTime_
            withPortionNum:(NSNumber *)portionNum_
         withIngredientAry:(NSArray *)ingredientAry_
               withStepAry:(NSArray *)stepAry_
                withRating:(NSNumber *)rating_;

@end
