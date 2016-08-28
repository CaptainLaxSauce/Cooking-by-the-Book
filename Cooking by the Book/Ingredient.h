//
//  Ingredient.h
//  Cooking by the Book
//
//  Created by Jack Smith on 8/28/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ingredient : NSObject

@property (nonatomic,strong) NSString *ingredientName;
@property (nonatomic,strong) NSString *ingredientID;

-(id)init;
-(id)initWithName:(NSString *)ingredientName withID:(NSString *)ingredientID;

@end
