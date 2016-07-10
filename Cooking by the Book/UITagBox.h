//
//  UITagBox.h
//  Cooking by the Book
//
//  Created by Jack Smith on 7/10/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITagBox : UIView

typedef enum TagType : int{
    quick = 0,
    simple = 1,
    vegetarian = 2,
    vegan = 3
    
} TagType;

@property NSArray *tagAry;

-(id)init;
-(id)initWithFrame:(CGRect)frame_;
-(id)initWithFrame:(CGRect)frame_ withTags:(NSArray *)tagAry_;

@end
