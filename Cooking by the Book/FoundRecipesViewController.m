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
#import "DataClass.h"
#import "Helper.h"

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
    //UIScrollView *recipeScrollView;
    UITableView *recipeTableView;
    int scrollBottom;
    DataClass *obj;

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

-(void)loadSearchByTitle {
    
}

-(void)loadSearchByIngredient {
    NSDictionary *ingredient1Dict = [[NSDictionary alloc]initWithObjectsAndKeys:self.ingAry[0],@"ingredientID",nil];
    NSDictionary *ingredient2Dict = [[NSDictionary alloc]initWithObjectsAndKeys:self.ingAry[1],@"ingredientID",nil];
    NSDictionary *ingredient3Dict = [[NSDictionary alloc]initWithObjectsAndKeys:self.ingAry[2],@"ingredientID",nil];
    
    NSArray *dictAry = [[NSArray alloc]initWithObjects:ingredient1Dict, ingredient2Dict, ingredient3Dict, nil];
    
    NSDictionary *postDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              dictAry, @"ingredients",
                              nil];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [NSString stringWithFormat:@"userID=%@&ingredients=%@",obj.userId, jsonStr];
    NSLog(@"send JSON = %@",jsonStr);
    NSData *postData = [jsonStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"getSearchRecipes"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        
        NSString *ret = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"search recipe ret = %@",ret);
        /*
        NSDictionary *recipeDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSDictionary *recipeInfoDict = [recipeDict objectForKey:@"recipeInfo"];
        NSArray *ingredientAry = [recipeDict objectForKey:@"ingredientInfo"];
        NSArray *tagAry = [recipeDict objectForKey:@"tagInfo"];
        NSArray *stepAry = [recipeDict objectForKey:@"stepInfo"];
        */
        
    }];
        
    [dataTask resume];

        
    
}
                                      
                                      

- (void) loadSearchRecipes {
    if (self.searchByIngredient == YES){
        [self loadSearchByIngredient];
    }
    else {
        [self loadSearchByTitle];
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
    //return the number of recipes found or max 20
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *SimpleIdentifier = @"SimpleIdentifier";
    
    UITableViewCell *cell = [recipeTableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleIdentifier];
    }
    
    //cell.textLabel.text = self.recipeArray[indexPath.row].title;
    
    return cell;
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
    
    obj = [DataClass getInstance];
    
    /*
    UICustomScrollView *scrollView = [[UICustomScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, screenWidth, scrollHeight) withObjectHeight:textHeight*3 withObjectBreak:objectBreak];
    scrollView.backgroundColor = [UIColor customGrayColor];
    [self.view addSubview:scrollView];
    */
    
    recipeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, screenWidth, scrollHeight) style:UITableViewStylePlain];
    recipeTableView.delegate = self;
    recipeTableView.dataSource = self;
    
    
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
