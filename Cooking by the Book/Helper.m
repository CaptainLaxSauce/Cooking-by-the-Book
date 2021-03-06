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
#import "DataClass.h"


@implementation Helper

+(void)submitHTTPPostWithString:(NSString *)sendString withURLEnd:(NSString *)urlEnd withAuth:(BOOL)auth withCompletionHandler:(void(^)(NSData *postData, NSURLResponse *response, NSError *error))completion{
    NSData *postData = [sendString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:urlEnd withAuth:auth];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:completion];
    [dataTask resume];
}

+(NSMutableURLRequest *)setupPost:(NSData *)postData withURLEnd:(NSString *)urlEnd withAuth:(BOOL)auth{
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)postData.length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://75.135.74.26:8080/%@.php",urlEnd]]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    
    //Authorization
    if (auth){
        DataClass *obj = [DataClass getInstance];
        NSString *authValue = [NSString stringWithFormat:@"%@ %@",obj.authData.tokenType,obj.authData.authToken];
        [request addValue:authValue forHTTPHeaderField:@"Authorization"];
    }


    return request;
}

+(void)submitImage:(NSString *)objectID withURLEnd:(NSString *)urlEnd withImage:(UIImage *)image{
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@"1.0" forKey:@"ver"];
    [_params setObject:@"en" forKey:@"lan"];
    //[_params setObject:[NSString stringWithFormat:@"%d", userId] forKey:@"userId"];
    //[_params setObject:[NSString stringWithFormat:@"%@",title] forKey:[NSString stringWithString:@"title"]];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----WebKitFormBoundaryEPRzw3WzbhDJRoYn"];
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"image";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSString *URLString = [NSString stringWithFormat:@"http://75.135.74.26:8080/%@.php",urlEnd];
    NSURL* requestURL = [NSURL URLWithString:URLString];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    DataClass *obj = [DataClass getInstance];
    NSString *authValue = [NSString stringWithFormat:@"%@ %@",obj.authData.tokenType,obj.authData.authToken];
    [request addValue:authValue forHTTPHeaderField:@"Authorization"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (imageData) {
        NSLog(@"image data contains something");
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"recipeID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", objectID] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *dataString = [[NSString alloc]initWithData:body encoding:NSUTF8StringEncoding];
    NSLog(@"dataString = %@",dataString);
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSString *ret = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"the image return is!!!: %@",ret);
    }];
    [dataTask resume];
    
    NSLog(@"image send attempted");
    NSLog(@"postLength = %@",postLength);
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
    NSDate *convertedDate = [Helper UTCstring2LocalNSDate:currDate];
    
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
        if (diff == 1){
            return @"1 minute ago";
        }
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        if (diff == 1){
            return @"1 hour ago";
        }
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 31536000) {
        int diff = round(ti / 60 / 60 / 24);
        if (diff == 1){
            return @"1 day ago";
        }
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"over a year ago";
    }
    
    
}

+(NSDate*)UTCstring2LocalNSDate:(NSString*)stringDate{
    NSString *dateFormat = @"yyyyMMddHHmmss";
    NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setTimeZone:inputTimeZone];
    [inputDateFormatter setDateFormat:dateFormat];
    NSDate *date = [inputDateFormatter dateFromString:stringDate];
    
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setTimeZone:outputTimeZone];
    [outputDateFormatter setDateFormat:dateFormat];
    NSString *outputString = [outputDateFormatter stringFromDate:date];
    NSDate *convertedDate = [outputDateFormatter dateFromString:outputString];
    
    return convertedDate;
}

+(NSString *)ingName2Id:(NSString *)name {
    DataClass *obj = [DataClass getInstance];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title MATCHES %@", name];
    NSArray *filteredAry = [obj.ingredientAry filteredArrayUsingPredicate:predicate];
    NSLog(@"filteredAry created with count %lu",(unsigned long)filteredAry.count);
    
    if (filteredAry.count > 0){
        Ingredient *ing = [filteredAry objectAtIndex:0];
        NSLog(@"Ingredient passed to search ID = %@",ing.ingredientID);
        return ing.ingredientID;
    }
    
    return @"";
}

+(NSString *)chefName:(NSString*)chefLevel withName:(NSString*)name{
    if ([chefLevel isEqual:@""]){
        return name;
    }
    
    return [NSString stringWithFormat:@"%@ %@",chefLevel, name];
    
}

+(void)postUnsuccessfulAlertAsyncOK:(NSString *)title withMessage:(NSString *)message withViewController:(UIViewController *)controller{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:title
                                    message:message
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        [controller presentViewController:alert animated:YES completion:nil];
        
    });
    
}


+(UIActivityIndicatorView *) startActivityView:(UIViewController *) controller{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(controller.view.frame.size.width/2,controller.view.frame.size.height/2);
    [controller.view addSubview: activityView];
    [activityView startAnimating];
    controller.view.userInteractionEnabled = FALSE;
    controller.navigationController.view.userInteractionEnabled = FALSE;
    controller.tabBarController.view.userInteractionEnabled = FALSE;
    
    return activityView;
}

+(void)stopActivityViewAsync:(UIActivityIndicatorView *)activityView withViewController:(UIViewController *)controller{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [activityView stopAnimating];
        controller.view.userInteractionEnabled = TRUE;
        controller.navigationController.view.userInteractionEnabled = TRUE;
        controller.tabBarController.view.userInteractionEnabled = TRUE;
        
    });
}

@end
