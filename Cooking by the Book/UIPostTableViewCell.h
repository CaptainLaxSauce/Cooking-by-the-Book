//
//  UIPostTableViewCell.h
//  Cooking by the Book
//
//  Created by Jack Smith on 3/5/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "Post.h"

@interface UIPostTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *bodyLabel;
@property (nonatomic,strong) UIImageView *postersImageView;
@property (nonatomic,strong) UIImageView *recipeImageView;
@property (nonatomic,strong) UILabel *recipeTitleLabel;
@property (nonatomic,strong) UILabel *recipeDescLabel;
@property (nonatomic,strong) HCSStarRatingView *starRatingView;
@property (nonatomic,strong) UIButton *likeButton;
@property (nonatomic,strong) UIButton *commentButton;

@property (nonatomic,strong) Post *post;

@end
