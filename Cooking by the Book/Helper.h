//
//  Helper.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"

@interface Helper : NSObject

+(void)submitHTTPPostWithString:(NSString *)postString withURLEnd:(NSString *)urlEnd withCompletionHandler:(void(^)(NSData *postData, NSURLResponse *response, NSError *error))completion;
+(void)submitImage:(NSString *)objectID withURLEnd:(NSString *)urlEnd withImage:(UIImage *)image;
+(NSMutableURLRequest *)setupPost:(NSData *)postData withURLEnd:(NSString *)urlEnd;
+(NSString *)toUTC:(NSDate *)date;
+(NSString *)fromUTC:(NSDate *)date;
+(NSString *)ingName2Id:(NSString*)name;
+(void)addImageToRecipe:(Recipe *)recipe withCompletionHandler:(void(^)(NSData *postData, NSURLResponse *response, NSError *error))completion;

@end
