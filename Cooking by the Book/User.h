//
//  User.h
//  Cooking by the Book
//
//  Created by Jack Smith on 3/8/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (nonatomic,strong) NSString* userID;
@property (nonatomic,strong) NSString* userName;
@property (nonatomic,strong) UIImage* profileImage;
@property (nonatomic,strong) NSString* imageName;
@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSString* userDescription;
@property (nonatomic,strong) NSString* chefLevelName;

-(id)initWithDict:(NSDictionary*)dict;

@end
