//
//  Helper.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "Helper.h"
#import "DataClass.h"
#import "Ingredient.h"

@implementation Helper

+(NSMutableURLRequest *)setupPost:(NSData *)postData withURLEnd:(NSString *)urlEnd{
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)postData.length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://75.135.74.26:8080/%@.php",urlEnd]]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];

    return request;
}

+(NSString *)toUTC:(NSDate *)currDate{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [outputFormatter setTimeZone:timeZone];
    [outputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *newDate = [outputFormatter stringFromDate:currDate];
    NSLog(@"Time UTC = %@",newDate);
    return newDate;
}

+(NSString *)fromUTC:(NSString *)currDate{
    NSString *dateFormat = @"yyyyMMddHHmmss";
    NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setTimeZone:inputTimeZone];
    [inputDateFormatter setDateFormat:dateFormat];
    NSDate *date = [inputDateFormatter dateFromString:currDate];
    
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setTimeZone:outputTimeZone];
    [outputDateFormatter setDateFormat:dateFormat];
    NSString *outputString = [outputDateFormatter stringFromDate:date];
    NSDate *convertedDate = [outputDateFormatter dateFromString:outputString];
    
    NSDate *todayDate = [NSDate date];
    NSLog(@"today date = %@",todayDate);
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    NSLog(@"ti = %f",ti);
    if(ti < 1) {
        return @"never";
    } else 	if (ti < 60) {
        return @"less than a minute ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 31536000) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"over a year ago";
    }
    
    
}

+(NSString *)ingName2Id:(NSString *)name {
    DataClass *obj = [DataClass getInstance];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ingredientName MATCHES %@", name];
    NSArray *filteredAry = [obj.ingredientAry filteredArrayUsingPredicate:predicate];
    NSLog(@"filteredAry created with count %lu",(unsigned long)filteredAry.count);
    
    if (filteredAry.count > 0){
        Ingredient *ing = [filteredAry objectAtIndex:0];
        NSLog(@"Ingredient passed to search ID = %@",ing.ingredientID);
        return ing.ingredientID;
    }
    
    return @"";
}

+(void)addImageToRecipe:(Recipe *)recipe withCompletionHandler:(void(^)(NSData *postData, NSURLResponse *response, NSError *error))completion{

    if (recipe.image == nil){
        NSLog(@"image name = %@",recipe.imageName);
        NSString *post = [NSString stringWithFormat:@"imageName=%@" ,recipe.imageName];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSMutableURLRequest *request = [self setupPost:postData withURLEnd:@"getImage"];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:completion];
        [dataTask resume];
        
    }
    
}

@end
