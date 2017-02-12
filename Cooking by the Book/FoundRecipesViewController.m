//
//  FoundRecipesViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 1/15/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "FoundRecipesViewController.h"
#import "UIColor+CustomColors.h"
#import "DataClass.h"
#import "Helper.h"
#import "HCSStarRatingView.h"
#import "DetailedRecipeViewController.h"
#import "Constants.h"

@interface FoundRecipesViewController ()

@end

@implementation FoundRecipesViewController
{
    UITableView *recipeTableView;
    DataClass *obj;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
}

-(void)viewDidDisappear:(BOOL)animated{
    //clear the recipeAry if popping the view to SearchRecipeViewController
    if (self.isMovingFromParentViewController == YES){
        [self.recipeAry removeAllObjects];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recipeAry count];
    //return the number of recipes found or max 20
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
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
            CompletionWeb addImageCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
            recipe.image = [UIImage imageWithData:postData];
            NSLog(@"adding image with imagename = %@",recipe.imageName);
            if (recipe.image) {
                cell.imageView.image = recipe.image;
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [recipeTableView reloadData];
            });
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
    UITableViewRowAction *add = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Add to Cookbook" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        [obj addRecipe:self.recipeAry[indexPath.row]];
                                        
                                        //retract the button
                                        [tableView beginUpdates];
                                        [tableView setEditing:NO animated:NO];
                                        [tableView endUpdates];
                                    }];
    add.backgroundColor = [UIColor greenColor];
    
    return @[add];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Nothing gets called here if you invoke `tableView:editActionsForRowAtIndexPath:` according to Apple docs so just leave this method blank
}
                                      

- (void)loadInterface {
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;

    
    obj = [DataClass getInstance];
    
    recipeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    recipeTableView.delegate = self;
    recipeTableView.dataSource = self;
    [self.view addSubview:recipeTableView];
    
}


@end
