//
//  Ingredient.h
//  Cooking by the Book
//
//  Created by Jack Smith on 8/28/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ingredient : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *ingredientID;
@property (nonatomic,strong) NSString *unitName;
@property (nonatomic,strong) NSString *unitQuantity;

-(id)initWithTitle:(NSString *)title_ withID:(NSString *)ingredientID_ withUnitName:(NSString *)unitName_ withUnitQuantity:(NSString *)unitQuantity_;

@end
