//
//  UICustomScrollView.h
//  Cooking by the Book
//
//  Created by Jack Smith on 1/23/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICustomScrollView : UIScrollView

-(id)initWithFrame:(CGRect)frame withObjectHeight:(int)height withObjectBreak:(int)objectBreak_;
-(void)add:(id)object;


@end
