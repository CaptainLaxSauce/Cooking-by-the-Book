//
//  Ingredient.m
//  Cooking by the Book
//
//  Created by Jack Smith on 8/28/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "Ingredient.h"

@implementation Ingredient

-(id)initWithTitle:(NSString *)title_ withID:(NSString *)ingredientID_ withUnitName:(NSString *)unitName_ withUnitQuantity:(NSString *)unitQuantity_{
    self = [super init];
    if (self){
        self.ingredientID = ingredientID_;
        self.title = title_;
        self.unitName = unitName_;
        self.unitQuantity = unitQuantity_;
    }
    return self;
}   

@end
