//
//  UICreateIngredientCell.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICreateIngredientCell : UIView

@property (nonatomic,strong) UITextField *quantityTextField;
@property (nonatomic,strong) UITextField *unitTextField;
@property (nonatomic,strong) UITextField *titleTextField;
@property (nonatomic,strong) UIButton *delButton;
@property (nonatomic) int index;

-(id)init;
-(id)initWithFrame:(CGRect)frame withDelBtn:(BOOL)delBtn;
-(id)delTouch;
-(void)loadInterface:(BOOL)delBtn;
@end
