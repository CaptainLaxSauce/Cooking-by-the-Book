//
//  AppDelegate.m
//  Cooking by the Book
//
//  Created by Jack Smith on 4/19/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "AppDelegate.h"
#import "DataClass.h"
#import "Helper.h"
#import "CoreIngredient+CoreDataProperties.h"

@interface AppDelegate ()
@property (nonatomic,strong) UIManagedDocument *document;
@end

@implementation AppDelegate

//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.s
    
    [self setupNotifications];
    
    [self setupManagedObjectContext];
    
    NSArray *dateAry = [self getDateAryFromCoreData];
    NSManagedObject *coreDate = [dateAry firstObject];
    NSDate *updateDate = [[NSDate alloc]init];
    
    //an update date is stored
    if (coreDate){
        updateDate = [coreDate valueForKey:@"updateDate"];
        
    }
    //no update date is stored, use default
    else {
        NSString *dateStr = [NSString stringWithFormat:@"2000-01-01"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"YYYY-MM-dd"];
        updateDate = [dateFormat dateFromString:dateStr];
        
    }
    
    NSString *updateStr = [Helper toUTC:updateDate];
    
    NSLog(@"last update date = %@",updateDate);
    NSLog(@"last update string = %@",updateStr);

    [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"lastUpdate=%@",updateStr]
                          withURLEnd:@"initialize"
               withCompletionHandler:[self getInitCompletion:coreDate]];
    
      return YES;
}

-(void)setupNotifications{
    [[UIApplication sharedApplication] respondsToSelector:(@selector(registerForRemoteNotifications))];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

-(NSArray *)getDateAryFromCoreData{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"LastIngredientUpdate"];
    fetchRequest.fetchBatchSize = 1;
    fetchRequest.fetchLimit = 1;
    
    NSError *error;
    return [self.context executeFetchRequest:fetchRequest error:&error];
};

-(CompletionWeb)getInitCompletion:(NSManagedObject*)coreDate{
    CompletionWeb initComplete = ^(NSData *postData, NSURLResponse *response, NSError *error){
        NSString *ret = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"initialize = %@",ret);
        NSDictionary *initDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSArray *ingredientAry = [initDict objectForKey:@"ingredientInfo"];
        
        //update core data aray if value returned
        if (![ingredientAry isKindOfClass:[NSNull class]]){
            NSLog(@"entered if");
            //clear core data for ingredients
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CoreIngredient"];
            NSError *error;
            NSArray *delAry = [self.context executeFetchRequest:fetchRequest error:&error];
            
            for (CoreIngredient *ing in delAry){
                [self.context deleteObject:ing];
            }
            
            //update the update date in core data
            if (coreDate){
                [coreDate setValue:[NSDate date] forKey:@"updateDate"];
            }
            else {
                NSManagedObject *newCoreDate = [NSEntityDescription insertNewObjectForEntityForName:@"LastIngredientUpdate"
                                                                             inManagedObjectContext:self.context];
                [newCoreDate setValue:[NSDate date] forKey:@"updateDate"];
                
            }
            
            //load ingredients into core data
            for (int i=0;i<ingredientAry.count;i++){
                NSMutableDictionary *ingredientDict = [ingredientAry objectAtIndex:i];
                NSString *ingredientID = [ingredientDict objectForKey:@"ingredientID"];
                NSString *ingredientName = [ingredientDict objectForKey:@"ingredientName"];
                //NSString *ingredientName = [NSString stringWithFormat:@"%@",[ingredientDict objectForKey:@"ingredientName"]];
                
                CoreIngredient *ingredient = [NSEntityDescription insertNewObjectForEntityForName:@"CoreIngredient"
                                                                           inManagedObjectContext:self.context];
                [ingredient setValue:ingredientID forKey:@"ingredientID"];
                [ingredient setValue:ingredientName forKey:@"ingredientName"];
                
                //NSLog(@"init dict name = %@",[ingredientDict objectForKey:@"ingredientName"]);
                //NSLog(@"core data cnt = %lu",(unsigned long)coreIngredientArray.count);
                //NSLog(@"ing id i = %@",[ingredientDict objectForKey:@"ingredientID"]);
            }
            
            
            
        }
        //initialize the data ingredient array whether core data was updated or not
        DataClass *obj = [DataClass getInstance];
        [obj initIngredientAry];
    };
    return initComplete;
}

-(void)setupManagedObjectContext{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"MyCoreData";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    BOOL fileExists = [fileManager fileExistsAtPath:[url path]];
    
    if (fileExists){
        [self.document openWithCompletionHandler:^(BOOL success){
            if (success) [self documentIsReady];
            if (!success) NSLog(@"couldn't open document at %@",url);
        }];
    }
    else{
        [self.document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success){
              if (success) [self documentIsReady];
              if (!success) NSLog(@"couldn't create document at %@",url);
          }];
    }
    
}

-(void)documentIsReady{
    if (self.document.documentState == UIDocumentStateNormal){
        self.context = self.document.managedObjectContext;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.context;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
/*
- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

 */
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@", deviceToken];
    NSLog(@"device token = %@", deviceTokenString);
}


@end
