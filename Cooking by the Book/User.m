//
//  User.m
//  Cooking by the Book
//
//  Created by Jack Smith on 3/8/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "User.h"

@implementation User

-(id)initWithDict:(NSDictionary*)dict{
    self = [super init];
    
    if(self){
        self.userID = [dict objectForKey:@"userID"];
        self.userName = [dict objectForKey:@"userName"];
        self.email = [dict objectForKey:@"userEmail"];
        self.imageName = [dict objectForKey:@"userImage"];
        self.userDescription = [dict objectForKey:@"userDescription"];
        self.chefLevelName = [dict objectForKey:@"chefLevelName"];
    }
    
    return self;
}

@end
