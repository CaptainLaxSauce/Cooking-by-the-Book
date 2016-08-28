//
//  UICookbookRecipeCell.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "UICookbookRecipeCell.h"
#import "UITagBox.h"

@implementation UICookbookRecipeCell



-(id)init{
    return [self initWithFrame:CGRectMake(0,0,0,0)];
}

-(id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame withRecipe:nil];
}

-(id)initWithFrame:(CGRect)frame withRecipe:(Recipe*)Recipe_{
  
    self = [super initWithFrame:frame];
    
    if (self) {
        int objectBreak = 8;
        int totalWidth = frame.size.width;
        int totalHeight = frame.size.height;
        int imageHeight = totalHeight - objectBreak*2;
        int titleHeight = (totalHeight-objectBreak*3)/3;
        int tagWidth = totalHeight;
        
        self.recipe = Recipe_;
        self.recipeID = Recipe_.recipeID;
        NSLog(@"recipeID of cookcell = %@",self.recipeID);
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(objectBreak, objectBreak, imageHeight, imageHeight)];
         if (Recipe_.image != nil){
             imageView_.image = Recipe_.image;
                  }
         else {
             imageView_.image = [UIImage imageNamed:@"recipedefault.png"];
         }
        self.imageView = imageView_;
        [self addSubview:_imageView];
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageHeight+objectBreak*2, objectBreak, totalWidth - imageHeight - tagWidth - objectBreak*2, titleHeight)];
        UIFontDescriptor * fontD = [titleLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        titleLabel.font = [UIFont fontWithDescriptor:fontD size:0];
        titleLabel.text = Recipe_.title;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:titleLabel];
        
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageHeight+objectBreak*2, titleHeight+objectBreak*2, totalWidth - imageHeight - tagWidth - objectBreak*2, totalHeight - titleHeight - objectBreak*3)];
        descLabel.text = Recipe_.desc;
        descLabel.numberOfLines = 3;
        descLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:descLabel];
        
        UITagBox *tagBox = [[UITagBox alloc]initWithFrame:CGRectMake(totalWidth - tagWidth, 0, tagWidth, totalHeight) withTags:Recipe_.tagAry];
        [self addSubview:tagBox];

    }
    
    return self;

}




@end
