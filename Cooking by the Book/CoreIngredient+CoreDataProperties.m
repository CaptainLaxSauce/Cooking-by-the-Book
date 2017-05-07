//
//  CoreIngredient+CoreDataProperties.m
//  Cooking by the Book
//
//  Created by Jack Smith on 5/7/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "CoreIngredient+CoreDataProperties.h"

@implementation CoreIngredient (CoreDataProperties)

+ (NSFetchRequest<CoreIngredient *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CoreIngredient"];
}

@dynamic ingredientID;
@dynamic ingredientName;

@end
