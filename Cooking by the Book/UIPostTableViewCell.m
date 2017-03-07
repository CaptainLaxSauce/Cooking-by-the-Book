//
//  UIPostTableViewCell.m
//  Cooking by the Book
//
//  Created by Jack Smith on 3/5/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "UIPostTableViewCell.h"
#import "Constants.h"
#import "UIColor+CustomColors.h"

@implementation UIPostTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.postersImageView = [[UIImageView alloc]init];
        [self.postersImageView setImage:[UIImage imageNamed:@"blankface.png"]];
        
        self.titleLabel = [[UILabel alloc]init];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        
        self.bodyLabel = [[UILabel alloc]init];
        self.bodyLabel.numberOfLines = 0;
        
        self.recipeImageView = [[UIImageView alloc]init];
        [self.recipeImageView setImage:[UIImage imageNamed:@"recipedefault.png"]];
        
        self.recipeTitleLabel = [[UILabel alloc]init];
        [self.recipeTitleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        
        self.recipeDescLabel = [[UILabel alloc]init];
        self.recipeDescLabel.numberOfLines = 0;
        
        self.starRatingView = [[HCSStarRatingView alloc]init];
        self.starRatingView.allowsHalfStars = YES;
        self.starRatingView.accurateHalfStars = YES;
        self.starRatingView.userInteractionEnabled = NO;
        self.starRatingView.tintColor = [UIColor starColor];
        
        
        self.likeButton = [[UIButton alloc]init];
        [self.likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        self.commentButton = [[UIButton alloc]init];
        [self.commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        

    }
    return self;
}

-(void)layoutSubviews {
    CGSize size = self.contentView.frame.size;
    int posterImageWidth = size.width / 6;
    int titleHeight = posterImageWidth / 2;
    int titleWidth = size.width - posterImageWidth - OBJECT_BREAK*3;
    int bodyHeight = posterImageWidth;
    int buttonHeight = size.height / 10;
    int buttonWidth = (size.width + self.accessoryView.frame.size.width) / 2;
    int imageHeight = size.height - titleHeight - bodyHeight - buttonHeight - OBJECT_BREAK * 4;
    
    [self.postersImageView setFrame:CGRectMake(OBJECT_BREAK, OBJECT_BREAK, posterImageWidth, posterImageWidth)];
    [self.contentView addSubview: self.postersImageView];
    
    [self.titleLabel setFrame:CGRectMake(posterImageWidth + OBJECT_BREAK * 2, OBJECT_BREAK, titleWidth, titleHeight)];
    [self.contentView addSubview: self.titleLabel];
    
    [self.bodyLabel setFrame:CGRectMake(posterImageWidth + OBJECT_BREAK * 2, titleHeight + OBJECT_BREAK * 2, titleWidth, bodyHeight)];
    [self.contentView addSubview: self.bodyLabel];
    
    [self.recipeImageView setFrame:CGRectMake(OBJECT_BREAK, titleHeight + bodyHeight + OBJECT_BREAK * 3, imageHeight, imageHeight)];
    [self.contentView addSubview: self.recipeImageView];
    
    [self.recipeTitleLabel setFrame:CGRectMake(OBJECT_BREAK*2 + imageHeight, titleHeight + bodyHeight + OBJECT_BREAK + imageHeight/4, size.width - imageHeight - OBJECT_BREAK*3, imageHeight/4)];
    [self.contentView addSubview: self.recipeTitleLabel];
    
    [self.recipeDescLabel setFrame:CGRectMake(OBJECT_BREAK*2 + imageHeight, titleHeight + bodyHeight + OBJECT_BREAK*2 + imageHeight/2, size.width - imageHeight - OBJECT_BREAK*3, imageHeight/4)];
    [self.contentView addSubview: self.recipeDescLabel];
    
    [self.starRatingView setFrame:CGRectMake(OBJECT_BREAK*2 + imageHeight, titleHeight + bodyHeight + OBJECT_BREAK*3 + imageHeight *3/4, size.width - imageHeight - OBJECT_BREAK*3, imageHeight/4)];
    [self.contentView addSubview: self.starRatingView];
    
    [self.likeButton setFrame:CGRectMake(0, size.height - buttonHeight, buttonWidth, buttonHeight)];
    [self.contentView addSubview: self.likeButton];
    
    [self.commentButton setFrame:CGRectMake(buttonWidth, size.height - buttonHeight, buttonWidth, buttonHeight)];
    [self.contentView addSubview: self.commentButton];
    
    UIView *buttonSeparator = [[UIView alloc]initWithFrame:CGRectMake(buttonWidth, size.height - buttonHeight, 1, buttonHeight)];
    buttonSeparator.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:buttonSeparator];
    
    /*
    self.postersImageView.backgroundColor = [UIColor orangeColor];
    self.titleLabel.backgroundColor = [UIColor redColor];
    self.bodyLabel.backgroundColor = [UIColor blueColor];
    self.likeButton.backgroundColor = [UIColor purpleColor];
    self.commentButton.backgroundColor = [UIColor grayColor];
    self.recipeImageView.backgroundColor = [UIColor blackColor];
    self.recipeDescLabel.backgroundColor = [UIColor yellowColor];
    self.recipeTitleLabel.backgroundColor = [UIColor greenColor];
    self.starRatingView.backgroundColor = [UIColor brownColor];
    */
    
    [super layoutSubviews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
