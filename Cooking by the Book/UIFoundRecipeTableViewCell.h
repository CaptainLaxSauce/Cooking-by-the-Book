//
//  UIFoundRecipeTableViewCell.h
//  Cooking by the Book
//
//  Created by Jack Smith on 5/7/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface UIFoundRecipeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipeDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipeChefLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;



@end
