//
//  UICreateIngredientCell.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "UICreateIngredientCell.h"
#import "HTAutocompleteTextField.h"
#import "HTAutocompleteManager.h"
#import "Constants.h"

@implementation UICreateIngredientCell

-(id)init{
    return [self initWithFrame:CGRectMake(0, 0, 100, 20) withDelBtn:FALSE];
}

-(id)initWithFrame:(CGRect)frame withDelBtn:(BOOL)delBtn{
    self = [super initWithFrame:frame];
    
    if (self){
        [self loadInterface:delBtn];
        self.layer.cornerRadius = CORNER_RADIUS;
        self.clipsToBounds = YES;
    }
    return self;
}

-(id)delTouch{
    [self removeFromSuperview];
    return self;
}

-(void)loadInterface:(BOOL)delBtn{
    int totalWidth = self.frame.size.width;
    int totalHeight = self.frame.size.height;
    int quantityWidth = (totalWidth-OBJECT_BREAK*2)/8;
    int unitWidth = quantityWidth*2;
    int titleWidth = totalWidth-unitWidth-quantityWidth*2;
    
    //load text fields
    UITextField *quantityTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, quantityWidth, totalHeight)];
    quantityTextField_.placeholder = @"#";
    quantityTextField_.backgroundColor = [UIColor whiteColor];
    [quantityTextField_ setKeyboardType:UIKeyboardTypeNumberPad];
    [self addSubview:quantityTextField_];
    self.quantityTextField = quantityTextField_;
    
    UITextField *unitTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(quantityWidth, 0, unitWidth, totalHeight)];
    unitTextField_.placeholder = @"Unit";
    unitTextField_.backgroundColor = [UIColor whiteColor];
    unitTextField_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [unitTextField_ setKeyboardType:UIKeyboardTypeDefault];
    [self addSubview:unitTextField_];
    self.unitTextField = unitTextField_;
    
    HTAutocompleteTextField *titleTextField_ = [[HTAutocompleteTextField alloc]initWithFrame:CGRectMake(quantityWidth+unitWidth, 0, titleWidth, totalHeight)];
    titleTextField_.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    titleTextField_.autocompleteType = HTAutocompleteTypeIngredient;
    titleTextField_.placeholder = @"Ingredient";
    titleTextField_.backgroundColor = [UIColor whiteColor];
    titleTextField_.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [titleTextField_ setKeyboardType:UIKeyboardTypeDefault];
    [self addSubview:titleTextField_];
    self.titleTextField = titleTextField_;
    
     
     
    //load delete button
    if (delBtn == TRUE){
        
        
        UIButton *delButton_ = [[UIButton alloc]initWithFrame:CGRectMake(totalWidth - quantityWidth, 0, quantityWidth, totalHeight)];
        [delButton_ addTarget:self action:@selector(delTouch) forControlEvents:UIControlEventTouchUpInside];
        [delButton_ setTitle:@"X" forState:UIControlStateNormal];
        delButton_.backgroundColor = [UIColor redColor];
        [self addSubview:delButton_];
        self.delButton = delButton_;
    }
    else{
        self.titleTextField.frame = CGRectMake(quantityWidth+unitWidth, 0, titleWidth+quantityWidth, totalHeight);
    }
}

@end
