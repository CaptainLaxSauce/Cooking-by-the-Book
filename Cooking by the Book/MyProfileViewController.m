//
//  MyProfileViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "MyProfileViewController.h"
#import "UIColor+CustomColors.h"

@implementation MyProfileViewController
{
    int screenHeight;
    int screenWidth;
    int statusBarHeight;
    int navBarHeight;
    int objectBreak;
    int textHeight;
    int scrollHeight;
    int tabHeight;
    int imageWidth;
    int acheivementHeight;
}

-(void)refreshPosts{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadInterface];
    
}

-(void)loadInterface{
    //declare constants
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    navBarHeight = self.navigationController.navigationBar.frame.size.height;
    objectBreak = 8;
    imageWidth = screenWidth/3;
    int objectWidth = screenWidth - objectBreak*2;
    textHeight = screenHeight/20;
    acheivementHeight = textHeight; //this will need to change, just using for testing
    tabHeight = self.tabBarController.tabBar.frame.size.height;
    scrollHeight = screenHeight-tabHeight-navBarHeight-statusBarHeight;
    
    self.view.backgroundColor = [UIColor primaryColor];
    self.navigationItem.title = @"Profile";
    
    //add scroll view
    UIScrollView *scrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, screenWidth, scrollHeight)];
    scrollView_.backgroundColor = [UIColor primaryColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = scrollView_;
    [self.view addSubview:scrollView_];
    
    UIImageView *profileImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2 - imageWidth/2, objectBreak, imageWidth, imageWidth)];
    [profileImageView_ setImage:[UIImage imageNamed:@"blankface.png"]];
    self.profileImageView = profileImageView_;
    [self.scrollView addSubview:profileImageView_];
    
    UILabel *titleLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak*2 + imageWidth, objectWidth, textHeight)];
    titleLabel_.textAlignment = NSTextAlignmentCenter;
    UIFontDescriptor * fontD = [titleLabel_.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    titleLabel_.font = [UIFont fontWithDescriptor:fontD size:0];
    titleLabel_.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:titleLabel_];
    
    UILabel *descLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak*4 + imageWidth + acheivementHeight, objectWidth, textHeight)];
    descLabel_.backgroundColor = [UIColor orangeColor];
    [self.scrollView addSubview:descLabel_];
    
    
    
    
    
    
    
}


@end
