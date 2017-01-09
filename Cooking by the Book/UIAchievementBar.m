//
//  UIAchievementBar.m
//  Cooking by the Book
//
//  Created by Jack Smith on 1/8/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "UIAchievementBar.h"

@implementation UIAchievementBar

NSMutableArray *achAry;

-(id)init{
    return [self initWithFrame:CGRectMake(0, 0, 100, 100)];
}
-(id)initWithFrame:(CGRect)frame_{
    return [self initWithFrame:frame_ withAch:nil];
}
-(id)initWithFrame:(CGRect)frame_ withAch:(NSArray *)achAry_{
    self = [super initWithFrame:frame_];
    achAry = (NSMutableArray *) achAry_;
    
    if (achAry.count == 0){
        NSLog(@"there are no achievements");
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [label setText:[NSString stringWithFormat:@"You currently have no achievements"]];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    else{
        NSLog(@"there are achievements!");
        //add achievements here
    }
    
    return self;
}


@end
