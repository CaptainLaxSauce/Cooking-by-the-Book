//
//  CookbookViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "CookbookViewController.h"
#import "Recipe.h"
#import "UIColor+CustomColors.h"
#import "TabBarControllerDelegate.h"
#import "DataClass.h"
#import "DetailedRecipeViewController.h"
#import "Helper.h"
#import "HCSStarRatingView.h"

@interface CookbookViewController()

@end

@implementation CookbookViewController
{
    
    DataClass *obj;
    UITableView *recipeTableView;
}

typedef void (^completionBlock)(NSData *postData, NSURLResponse *response, NSError *error);

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    
}

-(void)deleteRecipe:(NSIndexPath *) indexPath{
    Recipe *recipe = ((Recipe*)self.recipeAry[indexPath.row]);
    NSString *post = [NSString stringWithFormat:@"recipeID=%@" ,recipe.recipeID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"deleteRecipe"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSString *ret = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
        if ([ret isEqual:@"1"]){
            [obj deleteRecipe:recipe];
            [self reloadTableDataAsync];

        }
        else{
            [self invalidDeletionAlert];
        }
    }];
    
    [dataTask resume];
    
    NSLog(@"deleted recipe %@",recipe.title);
}

-(void)reloadTableDataAsync{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [recipeTableView reloadData];
    });
}

-(void)invalidDeletionAlert{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Invalid Deletion"
                                    message:[NSString stringWithFormat:@"The recipe deletion was unsuccessful"]
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

    });
}
                   
-(void)createRecipeTouch:(id)sender{
    [self performSegueWithIdentifier:@"CreateRecipeViewController" sender:sender];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recipeAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 93;
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
    
    //retrieve image from server if it hasn't been already
    if (![recipe.imageName  isEqual: @""] && recipe.image == nil){
        completionBlock addImageCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
            recipe.image = [UIImage imageWithData:postData];

            if (recipe.image) {
                cell.imageView.image = recipe.image;
            }
            
            [self reloadTableDataAsync];
    
        };
        
        [Helper getImageWithName:recipe.imageName withCompletion:addImageCompletion];
    }
    else if (recipe.image){
        cell.imageView.image = recipe.image;
    }
    
    HCSStarRatingView *starView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(120, 65, 120, 27)];
    starView.maximumValue = 5;
    starView.minimumValue = 0;
    starView.value = [recipe.rating doubleValue];
    starView.allowsHalfStars = YES;
    starView.accurateHalfStars = YES;
    starView.userInteractionEnabled = NO;
    starView.tintColor = [UIColor starColor];
    [cell.contentView addSubview:starView];
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    Recipe *recipe = self.recipeAry[indexPath.row];
    id sender = recipe;
    [self performSegueWithIdentifier:@"DetailedRecipeViewController" sender:sender];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"DetailedRecipeViewController"]){
        DetailedRecipeViewController *controller = (DetailedRecipeViewController *)segue.destinationViewController;
        controller.recipe = ((Recipe *)sender);
        controller.recipeID = ((Recipe *)sender).recipeID;
    }
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                 {
                                     [self deleteRecipe:indexPath];
                                 }];
    delete.backgroundColor = [UIColor redColor];
    
    return @[delete];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Nothing gets called here if you invoke `tableView:editActionsForRowAtIndexPath:` according to Apple docs so just leave this method blank
}

-(void)loadInterface{
    //declare constants
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width; 
    self.view.backgroundColor = [UIColor primaryColor];
    self.navigationItem.title = @"Cookbook";
    
    obj = [DataClass getInstance];
    self.recipeAry = obj.cookbookAry;
    
    recipeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    recipeTableView.delegate = self;
    recipeTableView.dataSource = self;
    [self.view addSubview:recipeTableView];

    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(createRecipeTouch:)];
    self.navigationItem.rightBarButtonItem = createButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
