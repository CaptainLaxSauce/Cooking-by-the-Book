//
//  Ingredient.m
//  Cooking by the Book
//
//  Created by Jack Smith on 8/28/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "Ingredient.h"

@implementation Ingredient

-(id)init{
    return [self initWithName:nil withID:nil];
}

-(id)initWithName:(NSString *)ingredientName_ withID:(NSString *)ingredientID_{
    self = [super init];
    if (self){
        self.ingredientID = ingredientID_;
        self.ingredientName = ingredientName_;
    }
    return self;
}   

@end
