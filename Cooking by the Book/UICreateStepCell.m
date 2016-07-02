//
//  UICreateStepCell.m
//  Cooking by the Book
//
//  Created by Jack Smith on 7/1/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "UICreateStepCell.h"

@implementation UICreateStepCell

-(id)init{
    return[self initWithFrame:CGRectMake(0, 0, 100, 20) withNumber:1 withDelBtn:FALSE];
}

-(id)initWithFrame:(CGRect)frame withNumber:(NSInteger)number withDelBtn:(BOOL)delBtn{
    
    self = [super initWithFrame:frame];
    
    if (self){
        [self loadInterface:delBtn];
        [self updateNum:number];
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)updateNum:(NSInteger)number{
    self.numLabel.text = [NSString stringWithFormat:@"%ld.",(long)number];
}

-(id)delTouch{
    [self removeFromSuperview];
    return self;
}

-(void)loadInterface:(BOOL)delBtn{
    int totalWidth = self.frame.size.width;
    int totalHeight = self.frame.size.height;
    int labelWidth = totalWidth/16;
    int buttonWidth = totalWidth/8;
    int textWidth;
    
    UILabel *numLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelWidth, totalHeight)];
    numLabel_.backgroundColor = [UIColor whiteColor];
    [self addSubview:numLabel_];
    self.numLabel = numLabel_;
    
    if (delBtn == TRUE){
        
        UIButton *delButton_ = [[UIButton alloc]initWithFrame:CGRectMake(totalWidth - buttonWidth, 0, buttonWidth, totalHeight)];
        [delButton_ addTarget:self action:@selector(delTouch) forControlEvents:UIControlEventTouchUpInside];
        [delButton_ setTitle:@"X" forState:UIControlStateNormal];
        delButton_.backgroundColor = [UIColor redColor];
        [self addSubview:delButton_];
        self.delButton = delButton_;
        
        textWidth = totalWidth - labelWidth - buttonWidth;
    }
    else{
        textWidth = totalWidth - labelWidth;
    }
    
    UITextField *textField_ = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth, 0, textWidth, totalHeight)];
    textField_.placeholder = @"Step";
    textField_.backgroundColor = [UIColor whiteColor];
    [self addSubview:textField_];
    self.textField = textField_;
    
}

@end
