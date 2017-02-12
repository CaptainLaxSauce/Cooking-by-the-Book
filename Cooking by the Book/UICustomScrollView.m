//
//  UICustomScrollView.m
//  Cooking by the Book
//
//  Created by Jack Smith on 1/23/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "UICustomScrollView.h"
#import "Constants.h"

@implementation UICustomScrollView
{
    int objectHeight;
    int bottom;
    
}

-(id)initWithFrame:(CGRect)frame withObjectHeight:(int)height withObjectBreak:(int)objectBreak_{
    bottom = objectBreak;
    objectHeight = height;
    //[self inset]
    
    return [self initWithFrame:frame];
    
}

-(void)add:(id)object{
    UIView *new = (UIView *)object;
    new.frame = CGRectMake(objectBreak, bottom, self.frame.size.width - objectBreak * 2, objectHeight);
    NSLog(@"bottom = %d",bottom);
    [self addSubview:new];
    
    bottom += objectHeight + objectBreak;
    
}


@end
