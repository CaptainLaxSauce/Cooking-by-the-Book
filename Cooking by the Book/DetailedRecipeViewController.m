//
//  DetailedRecipeViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 8/10/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "DetailedRecipeViewController.h"
#import "DataClass.h"
#import "Helper.h"
#import "UIColor+CustomColors.h"

@interface DetailedRecipeViewController ()

@end

@implementation DetailedRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadInterface{
    int objectBreak=8;
    int cornerRadius=3;
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    int objectWidth = screenWidth - objectBreak*2;
    int textHeight = screenHeight/20;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    int navBarHeight = self.navigationController.navigationBar.frame.size.height;
    int tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    int scrollHeight = screenHeight-statusBarHeight-navBarHeight-textHeight-objectBreak*2-tabBarHeight;
    
    DataClass *obj = [DataClass getInstance];
    self.recipe = [obj getRecipe:obj.currDetailedRecipeId];
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.recipe.title];
    NSString *post = [NSString stringWithFormat:@"recipeID=%@",obj.currDetailedRecipeId];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"getRecipe"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSString *ret_ = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"ret = %@",ret_);
        
    }];
    [dataTask resume];
    NSLog(@"Detailed Recipe ID = %@",obj.currDetailedRecipeId);
    
    UIScrollView *scrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight+navBarHeight, screenWidth, screenHeight-statusBarHeight-navBarHeight-tabBarHeight)];
    scrollView_.backgroundColor = [UIColor customGrayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = scrollView_;
    [self.view addSubview:scrollView_];
    
    UIImageView *recipeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(objectBreak, objectBreak, objectWidth, objectWidth)];
    [recipeImageView setImage:self.recipe.image];
    recipeImageView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:recipeImageView];
    
                                    
    
}

@end
