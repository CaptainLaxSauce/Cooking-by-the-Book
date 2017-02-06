//
//  UIPost.h
//  Cooking by the Book
//
//  Created by Jack Smith on 9/19/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface UIPost : UIView

@property NSString* postID;
@property NSString* creatorID;
@property NSString* title;
@property NSString* body;
@property NSString* recipeID;
@property NSString* dateTime;
@property NSString* likeCount;
@property NSString* commentCount;
@property Recipe* recipe;

-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame
        withPostID:(NSString *)postID_
     withCreatorID:(NSString *)creatorID_
         withTitle:(NSString *)title_
          withBody:(NSString *)body_
      withRecipeID:(NSString *)recipeID_
      withDateTime:(NSString *)dateTime_
     withLikeCount:(NSString *)likeCount_
  withCommentCount:(NSString *)commentCount_;
@end
