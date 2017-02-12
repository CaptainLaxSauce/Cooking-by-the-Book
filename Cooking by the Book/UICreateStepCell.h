//
//  UICreateStepCell.h
//  Cooking by the Book
//
//  Created by Jack Smith on 7/1/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICreateStepCell : UIView
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *delButton;

-(id)init;
-(id)initWithFrame:(CGRect)frame withNumber:(NSInteger)number withDelBtn:(BOOL)delBtn;
-(id)delTouch;
-(void)loadInterface:(BOOL)delBtn;
-(void)updateNum:(NSInteger)number;

@end
