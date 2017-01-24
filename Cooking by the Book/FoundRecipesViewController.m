//
//  FoundRecipesViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 1/15/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "FoundRecipesViewController.h"
#import "UIColor+CustomColors.h"
#import "UICustomScrollView.h"

@interface FoundRecipesViewController ()

@end

@implementation FoundRecipesViewController
{
    int objectBreak;
    int objectWidth;
    int cornerRadius;
    int screenHeight;
    int screenWidth;
    int statusBarHeight;
    int navBarHeight;
    int textHeight;
    int tabHeight;
    int scrollHeight;
    UIScrollView *recipeScrollView;
    int scrollBottom;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    [self loadSearchRecipes];
    NSLog(@"search by ing? %d",_searchByIngredient);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) loadSearchRecipes {
    
}

- (void)loadInterface {
    //declare constants
    objectBreak = 8;
    cornerRadius = 3;
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    navBarHeight = self.navigationController.navigationBar.frame.size.height;
    objectWidth = screenWidth - objectBreak*2;
    textHeight = screenHeight/20;
    tabHeight = self.tabBarController.tabBar.frame.size.height;
    scrollHeight = screenHeight-tabHeight-objectBreak-navBarHeight-statusBarHeight;
    
    /*
    UICustomScrollView *scrollView = [[UICustomScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, screenWidth, scrollHeight) withObjectHeight:textHeight*3 withObjectBreak:objectBreak];
    scrollView.backgroundColor = [UIColor customGrayColor];
    [self.view addSubview:scrollView];
    */
    
    UITableView *recipeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, screenWidth, scrollHeight) style:UITableViewStylePlain];
    
    UIView *testView = [[UIView alloc]init];
    testView.backgroundColor = [UIColor orangeColor];
    
    UIView *testView2 = [[UIView alloc]init];
    testView.backgroundColor = [UIColor blueColor];
    
    [recipeTableView addSubview:testView];
    
    
    //add scroll view
    /*
    recipeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, screenWidth, scrollHeight)];
    recipeScrollView.backgroundColor = [UIColor customGrayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    scrollBottom = objectBreak;
    [self.view addSubview:recipeScrollView];
    */
    
}


@end
