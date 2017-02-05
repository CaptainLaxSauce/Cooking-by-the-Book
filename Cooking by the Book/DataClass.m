//
//  DataClass.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "DataClass.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Ingredient.h"


@implementation DataClass

static DataClass *instance = nil;

+(DataClass *)getInstance{
    @synchronized (self) {
        if (instance == nil)
        {
            instance = [DataClass new];
        }
    }
    return instance;
}

-(void)initProfile:(NSDictionary *)jsonProfileDict{
    self.profileDict = jsonProfileDict;
}

-(void)initCookbookAry:(NSArray *)jsonCookbookAry_{
    NSMutableArray *cookbookAry_ = [[NSMutableArray alloc]init];
    self.cookbookAry = cookbookAry_;
    
    for (int i=0;i<jsonCookbookAry_.count;i++){
        NSDictionary *recipeDict = [jsonCookbookAry_ objectAtIndex:i];
        NSArray *tagAry = [recipeDict objectForKey:@"tagInfo"];
        NSMutableArray *tagNumAry = [[NSMutableArray alloc]init];
        NSLog(@"tagAry count = %lu",(unsigned long)tagAry.count);
        
        for (int ii=0;ii<tagAry.count;ii++){
            NSDictionary *tagDict = [tagAry objectAtIndex:ii];
            if ([tagDict objectForKey:@"tagID"] != (id)[NSNull null]){
                [tagNumAry addObject:[tagDict objectForKey:@"tagID"]];
                NSLog(@"tagID = %@",[tagDict objectForKey:@"tagID"]);
                NSLog(@"tagAry count inside ii loop = %lu",(unsigned long)tagAry.count); 
            }

        }
        
        Recipe *tempRecipe = [[Recipe alloc] initBasicWithTitle:[recipeDict objectForKey:@"recipeTitle"]
                                                                         withID:[recipeDict objectForKey:@"recipeID"]
                                                                       withDesc:[recipeDict objectForKey:@"recipeDescription"]
                                                                  withImageName:[recipeDict objectForKey:@"recipeImage"]
                                                                     withTagAry:tagNumAry];
        NSLog(@"temp recipe properties = %@ %@ %@ %@ %@",tempRecipe.title, tempRecipe.recipeID, tempRecipe.desc, tempRecipe.tagAry, tempRecipe.imageName);
        [self.cookbookAry addObject:tempRecipe];
        NSLog(@"Cookbook ary count after initialization = %lu",(unsigned long)self.cookbookAry.count);
    }
    
    self.cookbookAry = [self alphebetizeAry:self.cookbookAry withKey:@"title"];
}

-(void)addRecipe:(Recipe *)recipe{
    [self.cookbookAry addObject:recipe];
    self.cookbookAry = [self alphebetizeAry:self.cookbookAry withKey:@"title"];
}

-(Recipe *)getRecipe:(NSString *)recipeID{
    NSArray *recipeAry = [[NSArray alloc]initWithArray:self.cookbookAry];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recipeID MATCHES %@", recipeID];
    NSArray *filteredAry = [recipeAry filteredArrayUsingPredicate:predicate];
    if (filteredAry.count == 0){
        return nil;
    }
    else{
        return [filteredAry objectAtIndex:0];
    }
    
}

-(void)addImageToRecipe:(Recipe *)recipe withImage:(UIImage *)image_{
    ((Recipe *) [self.cookbookAry objectAtIndex:[self.cookbookAry indexOfObject:recipe]]).image = image_;
}

-(void)deleteRecipe:(Recipe *)recipe{
    [self.cookbookAry removeObject:recipe];
}

-(NSMutableArray *)alphebetizeAry:(NSMutableArray *)theArray withKey:(NSString *)key{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [theArray sortUsingDescriptors:@[sort]];
    return theArray;
}

-(void)initIngredientAry{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Ingredient"];
    NSMutableArray *coreIngAry = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    NSMutableArray *dataIngAry = [[NSMutableArray alloc]init];
    
    NSLog (@"ingredientCount = %lu",(unsigned long)coreIngAry.count);
    for (int i=0;i<coreIngAry.count;i++){
        NSManagedObject *coreIngredient = [coreIngAry objectAtIndex:i];
        Ingredient *tempIng = [[Ingredient alloc]initWithName:[coreIngredient valueForKey:@"ingredientName"] withID:[coreIngredient valueForKey:@"ingredientID"]];
        [dataIngAry addObject:tempIng];
        NSLog(@"Data Ingredient ID = %@",[coreIngredient valueForKey:@"ingredientID"]);
        NSLog(@"Data IngredientName = %@",[coreIngredient valueForKey:@"ingredientName"]);
    }
    self.ingredientAry = dataIngAry;
    NSLog(@"Data IngredientAry count = %lu",(unsigned long)self.ingredientAry.count);
    for (Ingredient *temp in self.ingredientAry){
        NSLog(@"dataclass ing id = %@, name = %@",temp.ingredientID,temp.ingredientName);
    }
}

@end
