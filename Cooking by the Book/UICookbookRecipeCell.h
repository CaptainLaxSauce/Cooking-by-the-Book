//
//  UICookbookRecipeCell.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface UICookbookRecipeCell : UIView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) Recipe *recipe;
@property (nonatomic,strong) NSString *recipeID; //used so this object can be found using NSPredicate
@property (nonatomic,strong) UIButton *delButton;
@property (nonatomic) BOOL allowDelBtn;

-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame withRecipe:(Recipe*)Recipe_;
-(id)delTouch:(id)sender;
-(void)showDelBtn:(id)sender;
-(void)hideDelBtn:(id)sender;
@end
