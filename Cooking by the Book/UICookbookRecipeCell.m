//
//  UICookbookRecipeCell.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "UICookbookRecipeCell.h"

@implementation UICookbookRecipeCell

-(id)init{
    return [self initWithFrame:CGRectMake(0, 0, 100, 20)];
}

-(id)initWithFrame:(CGRect)frame_{
    return [self initWithFrame:frame_ withImage:nil withTitle:@"Title" withDesc:@"Description" withTags:nil];
}

-(id)initWithFrame:(CGRect)frame_ withImage:(UIImage *)image_ withTitle:(NSString *)title_ withDesc:(NSString *)desc_ withTags:(NSArray *)tagAry_{
    self = [super initWithFrame:frame_];
    if (self) {
        self.frame = &(frame_);
        self.image = image_;
        self.title = title_;
        self.desc = desc_;
        self.tagAry = tagAry_;
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end
