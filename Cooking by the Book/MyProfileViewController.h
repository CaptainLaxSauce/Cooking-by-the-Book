//
//  MyProfileViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *titleLabel;

-(void)refreshPosts;

@end
