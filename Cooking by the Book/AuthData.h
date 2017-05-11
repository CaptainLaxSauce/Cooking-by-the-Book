//
//  AuthData.h
//  Cooking by the Book
//
//  Created by Jack Smith on 5/10/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthData : NSObject

@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *authToken;
@property (nonatomic,retain) NSString *tokenType;
@property (nonatomic,retain) NSDate *expireInstant;

@end
