//
//  Friend.m
//  Cooking by the Book
//
//  Created by Jack Smith on 2/11/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "Friend.h"

@implementation Friend

-(id) initWithName:(NSString *)name withUserId:(NSString *)userId withImageName:(NSString *)imageName withMutualFriends:(NSString *)mutualFriends{
    self = [super init];
    
    if (self) {
        _name = name;
        _userId = userId;
        _imageName = imageName;
        _mutualFriends = mutualFriends;
    }
    
    return self;
}

@end
