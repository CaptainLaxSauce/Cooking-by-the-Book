//
//  UICookbookRecipeCell.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CookbookRecipe.h"

@interface UICookbookRecipeCell : UIView

@property UIImage *image;
@property UIImageView *imageView;
@property NSString *title;
@property NSString *desc;
@property NSArray *tagAry;


-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame withCookbookRecipe:(CookbookRecipe*)cookbookRecipe_;
-(id)initWithFrame:(CGRect)frame withImage:(UIImage*)image_ withTitle:(NSString*)title_ withDesc:(NSString *)desc_ withTags:(NSArray *)tagAry_;

@end
