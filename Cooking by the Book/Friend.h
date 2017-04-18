//
//  Friend.h
//  Cooking by the Book
//
//  Created by Jack Smith on 2/11/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Friend : NSObject

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *mutualFriends;
@property (nonatomic,strong) NSString* chefLevelName;

-(id)initWithDict:(NSDictionary *)dict;
-(id) initWithName:(NSString *)name withUserId:(NSString *)userId withImageName:(NSString *)imageName withMutualFriends:(NSString *)mutualFriends;


@end
