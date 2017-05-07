//
//  AppDelegate.h
//  Cooking by the Book
//
//  Created by Jack Smith on 4/19/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
//@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory; // nice to have to reference files for core data
- (void)saveContext;
@property (nonatomic,strong) NSManagedObjectContext *context;
//- (NSManagedObjectModel *)managedObjectModel;
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end

