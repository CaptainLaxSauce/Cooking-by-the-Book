//
//  CoreIngredient+CoreDataProperties.h
//  Cooking by the Book
//
//  Created by Jack Smith on 5/7/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "CoreIngredient+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CoreIngredient (CoreDataProperties)

+ (NSFetchRequest<CoreIngredient *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *ingredientID;
@property (nullable, nonatomic, copy) NSString *ingredientName;

@end

NS_ASSUME_NONNULL_END
