//
//  UITagBox.m
//  Cooking by the Book
//
//  Created by Jack Smith on 7/10/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "UITagBox.h"
#import "UIColor+CustomColors.h"

@implementation UITagBox

-(id)init{
    return [self initWithFrame:CGRectMake(0, 0, 100, 100)];
}

-(id)initWithFrame:(CGRect)frame_{
    return [self initWithFrame:frame_ withTags:nil];
}

-(id)initWithFrame:(CGRect)frame_ withTags:(NSArray *)tagAry_{
    self = [super initWithFrame:frame_];
    
    if (self){
        [self addTags:tagAry_];
    }
    
    return self;
}

-(void)addTags:(NSArray *)tagAry_{
    _tagAry = tagAry_;
    
    int objectBreak = 3;
    int totalWidth = self.frame.size.width;
    int totalHeight = self.frame.size.height;
    int tagHeight = (totalHeight - objectBreak*5)/4;
    int tagWidth = totalWidth - objectBreak*2;
    UIColor *tagColor;
    NSString *tagStr;
    
    for (int i = 0; i < _tagAry.count; i++){
        /*
         int xstart;
         int ystart;
         if (i < 2) {
         xstart = objectBreak*2 + tagWidth;
         }
         else{
         xstart = objectBreak;
         }
         
         if (i % 2 == 0){
         ystart = objectBreak;
         NSLog(@"i = %d, modulo = 0",i);
         }
         else{
         ystart = objectBreak*2 + tagHeight;
         NSLog(@"i = %d, modulo != 0",i);
         }
         */
     
        /*
        NSMutableArray *newAry = [[NSMutableArray alloc]initWithArray:tagAry_];
        for (int i=0;i<tagAry_.count;i++){
            NSString *str = [newAry objectAtIndex:i];
            if ([str  isEqual: @"quick"]){
                int ii = 1;
                [newAry removeObjectAtIndex:i];
                [newAry insertObject:ii atIndex:i];
            }
            
        }
        */
        
        
        
        TagType tagType = [[tagAry_ objectAtIndex:i] intValue];
        
        switch(tagType){
            case quick:
                tagColor = [UIColor tagQuickColor];
                tagStr = @"Quick";
                NSLog(@"tag quick");
                break;
            case simple:
                tagColor = [UIColor tagSimpleColor];
                tagStr = @"Simple";
                NSLog(@"tag simple");
                break;
            case vegetarian:
                tagColor = [UIColor tagVegetarianColor];
                tagStr = @"Vegetarian";
                NSLog(@"tag vegetarian");
                break;
            case vegan:
                tagColor = [UIColor tagVeganColor];
                tagStr = @"Vegan";
                NSLog(@"tag vegan");
                break;
            default:
                NSLog(@"didn't hit a tag case");
                break;
        }
        
        UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak+(tagHeight+objectBreak)*i, tagWidth, tagHeight)];
        tagLabel.layer.cornerRadius = 3;
        tagLabel.text = tagStr;
        [tagLabel setTextColor:tagColor];
        tagLabel.backgroundColor = [UIColor lightColorVersion:tagColor];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.adjustsFontSizeToFitWidth = YES;
        [[tagLabel layer] setBorderWidth:2.0f];
        [[tagLabel layer] setBorderColor:tagColor.CGColor];
        [self addSubview:tagLabel];
    }
    
}

@end
