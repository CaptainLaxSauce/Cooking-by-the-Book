//
//  UICookbookRecipeCell.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "UICookbookRecipeCell.h"
#import "UITagBox.h"
#import "Constants.h"

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
        int totalWidth = frame.size.width;
        int totalHeight = frame.size.height;
        int imageHeight = totalHeight - OBJECT_BREAK*2;
        int titleHeight = (totalHeight-OBJECT_BREAK*3)/3;
        int tagWidth = totalHeight;
        
        self.recipe = Recipe_;
        self.recipeID = Recipe_.recipeID;
        NSLog(@"recipeID of cookcell = %@",self.recipeID);
        self.backgroundColor = [UIColor whiteColor];
        
        UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showDelBtn:)];
        swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeL];
        
        UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideDelBtn:)];
        swipeR.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeR];
        
        UIImageView *imageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(OBJECT_BREAK, OBJECT_BREAK, imageHeight, imageHeight)];
         if (Recipe_.image != nil){
             imageView_.image = Recipe_.image;
                  }
         else {
             imageView_.image = [UIImage imageNamed:@"recipedefault.png"];
         }
        self.imageView = imageView_;
        [self addSubview:_imageView];
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageHeight+OBJECT_BREAK*2, OBJECT_BREAK, totalWidth - imageHeight - tagWidth - OBJECT_BREAK*2, titleHeight)];
        UIFontDescriptor * fontD = [titleLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        titleLabel.font = [UIFont fontWithDescriptor:fontD size:0];
        titleLabel.text = Recipe_.title;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:titleLabel];
        
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageHeight+OBJECT_BREAK*2, titleHeight+OBJECT_BREAK*2, totalWidth - imageHeight - tagWidth - OBJECT_BREAK*2, totalHeight - titleHeight - OBJECT_BREAK*3)];
        descLabel.text = Recipe_.desc;
        descLabel.numberOfLines = 3;
        descLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:descLabel];
        
        if (Recipe_.tagAry.count > 0){
            UITagBox *tagBox = [[UITagBox alloc]initWithFrame:CGRectMake(totalWidth - tagWidth, 0, tagWidth, totalHeight) withTags:Recipe_.tagAry];
            [self addSubview:tagBox];
        }
        
        UIButton *delButton_ = [[UIButton alloc]initWithFrame:CGRectMake(totalWidth- tagWidth, 0, tagWidth, totalHeight)];
        delButton_.backgroundColor = [UIColor redColor];
        [delButton_ addTarget:self action:@selector(delTouch:) forControlEvents:UIControlEventTouchUpInside];
        [delButton_ setTitle:@"X" forState:UIControlStateNormal];
        self.delButton = delButton_;
        [self addSubview:delButton_];
        [delButton_ setHidden:TRUE];
    }
    
    return self;

}

-(void)showDelBtn:(id)sender{
    if ((self.delButton.isHidden == TRUE) && (self.allowDelBtn)){
        [self.delButton setHidden:FALSE];
    }
    
}

-(void)hideDelBtn:(id)sender{
    if (self.delButton.isHidden == FALSE){
        [self.delButton setHidden:TRUE];
    }
}

-(id)delTouch:(id)sender{
   // [self removeFromSuperview];
    return self;
}



@end
