//
//  Helper.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"
#import "Constants.h"

@interface Helper : NSObject

//Web service functions
+(void)submitHTTPPostWithString:(NSString *)postString withURLEnd:(NSString *)urlEnd withCompletionHandler:(void(^)(NSData *postData, NSURLResponse *response, NSError *error))completion;
+(void)submitImage:(NSString *)objectID withURLEnd:(NSString *)urlEnd withImage:(UIImage *)image;
+(NSMutableURLRequest *)setupPost:(NSData *)postData withURLEnd:(NSString *)urlEnd;

//Conversion functions
+(NSString *)toUTC:(NSDate *)date;
+(NSString *)fromUTC:(NSDate *)date;
+(NSString *)ingName2Id:(NSString*)name;
+(NSString *)chefName:(NSString*)chefLevel withName:(NSString*)name;

//Alert functions
+(void)postUnsuccessfulAlertAsyncOK:(NSString *)title withMessage:(NSString *)message withViewController:(UIViewController *)controller;

//Activityiew functions
+(UIActivityIndicatorView *) startActivityView:(UIViewController *) controller;
+(void)stopActivityViewAsync:(UIActivityIndicatorView *)activityView withViewController:(UIViewController *)controller;

@end
