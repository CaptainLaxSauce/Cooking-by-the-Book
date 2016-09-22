//
//  UIPost.m
//  Cooking by the Book
//
//  Created by Jack Smith on 9/19/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "UIPost.h"
#import "DataClass.h"
#import "Recipe.h"
#import "UICookbookRecipeCell.h"

@implementation UIPost
{
    int objectBreak;
    int totWidth;
    int totHeight;
    int textHeight;
    int objectWidth;
    DataClass *obj;
}

-(id)init{
    self = [self initWithFrame:CGRectMake(0, 0, 0, 0)];
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [self initWithFrame:frame
                    withPostID:nil
                 withCreatorID:nil
                     withTitle:nil
                      withBody:nil
                  withRecipeID:nil
                  withDateTime:nil
                 withLikeCount:nil
              withCommentCount:nil];
    return self;
}

-(id)initWithFrame:(CGRect)frame
         withPostID:(NSString *)postID_
      withCreatorID:(NSString *)creatorID_
          withTitle:(NSString *)title_
           withBody:(NSString *)body_
       withRecipeID:(NSString *)recipeID_
       withDateTime:(NSString *)dateTime_
      withLikeCount:(NSString *)likeCount_
   withCommentCount:(NSString *)commentCount_
{
    self = [super initWithFrame:frame];
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
        
        
        objectBreak = 3;
        totWidth = self.frame.size.width;
        totHeight = self.frame.size.height;
        textHeight = (totHeight - objectBreak*9)/8;
        objectWidth =  totWidth - objectBreak*2;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak, objectWidth, textHeight)];
        UIFontDescriptor * fontD = [titleLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        titleLabel.font = [UIFont fontWithDescriptor:fontD size:0];
        [titleLabel setText:title_];
        [self addSubview:titleLabel];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak + textHeight, objectWidth/4, textHeight)];
        [timeLabel setText:dateTime_];
        timeLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:timeLabel];
        
        obj = [DataClass getInstance];
        Recipe *recipe = [obj getRecipe:recipeID_];
        UICookbookRecipeCell *recipeCell = [[UICookbookRecipeCell alloc]initWithFrame:CGRectMake(objectBreak, objectBreak + textHeight*2, objectWidth, textHeight*3 + objectBreak*2) withRecipe:recipe];
        [self addSubview:recipeCell];
        
        UILabel *bodyLabel = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak*4 + textHeight*5, objectWidth, textHeight*2)];
        [bodyLabel setText:body_];
        [self addSubview:bodyLabel];
        
        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak*5 + textHeight*7, objectWidth/2, textHeight)];
        [likesLabel setText:[NSString stringWithFormat:@"Likes: %@",likeCount_]];
        [self addSubview:likesLabel];
        
        UILabel *commentsLabel = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak + objectWidth/2, objectBreak*5 + textHeight*7, objectWidth/2, textHeight)];
        [commentsLabel setText:[NSString stringWithFormat:@"Comments: %@",commentCount_]];
        [self addSubview:commentsLabel];

    }
    return self;
}


@end
