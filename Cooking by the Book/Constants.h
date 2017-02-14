//
//  Constants.h
//  Cooking by the Book
//
//  Created by Jack Smith on 2/11/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int const OBJECT_BREAK;
extern int const CORNER_RADIUS;
extern float const FRIEND_LABEL_FRACTION;

typedef void(^CompletionWeb)(NSData *postData, NSURLResponse *response, NSError *error);

@interface Constants : NSObject

@end
