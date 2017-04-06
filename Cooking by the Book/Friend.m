//
//  Friend.m
//  Cooking by the Book
//
//  Created by Jack Smith on 2/11/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "Friend.h"

@implementation Friend

-(id)initWithDict:(NSDictionary *)dict{
    return [self initWithName:[dict objectForKey:@"userName"]
                   withUserId:[dict objectForKey:@"friendUserID"]
                withImageName:[dict objectForKey:@"userImage"]
            withMutualFriends:[dict objectForKey:@"mutualFriends"]];
}

-(id) initWithName:(NSString *)username_ withUserId:(NSString *)userId_ withImageName:(NSString *)imageName_ withMutualFriends:(NSString *)mutualFriends_{
    self = [super init];
    
    if (self) {
        self.username = username_;
        self.userId = userId_;
        self.imageName = imageName_;
        self.mutualFriends = mutualFriends_;
    }
    
    return self;
}

@end
