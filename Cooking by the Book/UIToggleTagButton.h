//
//  UIToggleTagButton.h
//  Cooking by the Book
//
//  Created by Jack Smith on 7/2/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToggleTagButton : UIButton

typedef enum TagType : int{
    quick = 0,
    simple = 1,
    vegetarian = 2,
    vegan = 3
    
} TagType;

@property (nonatomic) TagType tagType;
@property (nonatomic) bool tagged;

-(id)init;
-(id)initWithFrame:(CGRect)frame withTagType:(TagType)tagType_ withTagged:(BOOL)tagged_;
-(void)updateColor;
-(void)toggleTag;
-(void)buttonTouch;
@end
