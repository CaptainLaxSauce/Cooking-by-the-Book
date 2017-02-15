//
//  Post.m
//  Cooking by the Book
//
//  Created by Jack Smith on 2/14/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "Post.h"
#import "DataClass.h"
#import "Helper.h"

@implementation Post
{
    DataClass *obj;
}

-(id)initWithPostID:(NSString *)postID_
     withCreatorID:(NSString *)creatorID_
         withTitle:(NSString *)title_
          withBody:(NSString *)body_
      withRecipeID:(NSString *)recipeID_
      withDateTime:(NSString *)dateTime_
     withLikeCount:(NSString *)likeCount_
  withCommentCount:(NSString *)commentCount_
{
    self = [super init];
    if (self)
    {
        self.postID = postID_;
        self.creatorID = creatorID_;
        self.title = title_;
        self.body = body_;
        self.recipeID = recipeID_;
        self.dateTime = dateTime_;
        self.likeCount = likeCount_;
        self.commentCount = commentCount_;
        
        obj = [DataClass getInstance];
        self.recipe = [obj getRecipeFromCookbook:recipeID_];

    }
    return self;
}

@end
