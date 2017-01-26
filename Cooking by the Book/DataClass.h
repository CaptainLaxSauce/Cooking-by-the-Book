//
//  DataClass.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"
#import "UIPost.h"

@interface DataClass : NSObject{

}

@property(nonatomic,retain) NSDictionary *profileDict;
@property(nonatomic,retain) NSMutableArray *cookbookAry;
@property(nonatomic,retain) NSMutableArray *ingredientAry;
@property(nonatomic,retain) NSString *userId;
@property(nonatomic,retain) UIPost *currDetailedPost;


+(DataClass*)getInstance;
-(void)initProfile:(NSDictionary *)jsonProfileDict;
-(void)initCookbookAry:(NSArray *)jsonCookbookAry_;
-(void)addRecipe:(Recipe *)recipe;
-(void)addImageToRecipe:(Recipe *)recipe withImage:(UIImage *)image;
-(void)deleteRecipe:(Recipe *)recipe;
-(Recipe *)getRecipe:(NSString *)recipeID;
-(NSMutableArray *)alphebetizeAry:(NSMutableArray *)theArray withKey:(NSString *)key;
-(void)initIngredientAry;

@end
