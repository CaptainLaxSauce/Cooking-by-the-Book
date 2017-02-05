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
    UITableView *recipeTableView;
    int scrollBottom;
    DataClass *obj;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    [self loadSearchRecipes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) loadSearchRecipes {

    NSLog(@"recipeAry count in found controller = %lu",(unsigned long)self.recipeAry.count);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recipeAry count];
    //return the number of recipes found or max 20
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *SimpleIdentifier = @"SimpleIdentifier";
    
    UITableViewCell *cell = [recipeTableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleIdentifier];
    }
    
    Recipe *recipe = self.recipeAry[indexPath.row];
    
    cell.textLabel.text = recipe.title;
    cell.detailTextLabel.text = recipe.desc;
    cell.imageView.image = [UIImage imageNamed:@"recipedefault.png"];
    
   
    if (![recipe.imageName  isEqual: @""] && recipe.image == nil){
        void (^addImageCompletion)(NSData *postData, NSURLResponse *response, NSError *error);
        addImageCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
            recipe.image = [UIImage imageWithData:postData];
            NSLog(@"adding image with imagename = %@",recipe.imageName);
            if (recipe.image) {
                //UITableViewCell *cellToUpdate = [tableView cellForRowAtIndexPath:indexPath]; // create a copy of the cell to avoid keeping a strong pointer to "cell" since that one may have been reused by the time the block is ready to update it.
                cell.imageView.image = recipe.image;
            }
                
        };
        
        [Helper addImageToRecipe:recipe withCompletionHandler:addImageCompletion];
    }
    else if (recipe.image){
        cell.imageView.image = recipe.image;
    }
    
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
    scrollHeight = screenHeight-tabHeight;
    
    obj = [DataClass getInstance];
    
    /*
    UICustomScrollView *scrollView = [[UICustomScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, screenWidth, scrollHeight) withObjectHeight:textHeight*3 withObjectBreak:objectBreak];
    scrollView.backgroundColor = [UIColor customGrayColor];
    [self.view addSubview:scrollView];
    */
    
    recipeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, scrollHeight) style:UITableViewStylePlain];
    recipeTableView.delegate = self;
    recipeTableView.dataSource = self;
    [self.view addSubview:recipeTableView];
    
    
    UIView *testView = [[UIView alloc]init];
    testView.backgroundColor = [UIColor orangeColor];
    
    UIView *testView2 = [[UIView alloc]init];
    testView.backgroundColor = [UIColor blueColor];
    
    //[recipeTableView addSubview:testView];
    
    
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
