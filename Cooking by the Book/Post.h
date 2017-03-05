//
//  Post.h
//  Cooking by the Book
//
//  Created by Jack Smith on 2/14/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"

@interface Post : NSObject

@property (nonatomic,strong) NSString* postID;
@property (nonatomic,strong) NSString* creatorID;
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* body;
@property (nonatomic,strong) NSString* recipeID;
@property (nonatomic,strong) NSString* dateTime;
@property (nonatomic,strong) NSString* likeCount;
@property (nonatomic,strong) NSString* commentCount;
@property (nonatomic,strong) Recipe* recipe;

-(id)initWithJSONDict:(NSDictionary *)dict;

-(id)initWithPostID:(NSString *)postID_
      withCreatorID:(NSString *)creatorID_
          withTitle:(NSString *)title_
           withBody:(NSString *)body_
       withRecipeID:(NSString *)recipeID_
       withDateTime:(NSString *)dateTime_
      withLikeCount:(NSString *)likeCount_
   withCommentCount:(NSString *)commentCount_;




@end
