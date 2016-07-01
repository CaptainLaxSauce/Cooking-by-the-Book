//
//  UICreateIngredientCell.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICreateIngredientCell : UIView

@property UITextField *quantityTextField;
@property UITextField *unitTextField;
@property UITextField *titleTextField;
@property UIButton *delButton;
@property int index;

-(id)init;
-(id)initWithFrame:(CGRect)frame withDelBtn:(BOOL)delBtn;
-(id)delTouch;
-(void)loadInterface:(BOOL)delBtn;
@end
