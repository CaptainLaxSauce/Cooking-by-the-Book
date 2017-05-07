//
//  FoundRecipesTableViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 5/7/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "FoundRecipesTableViewController.h"
#import "DataClass.h"
#import "UIFoundRecipeTableViewCell.h"
#import "Helper.h"
#import "DetailedRecipeViewController.h"

@interface FoundRecipesTableViewController ()
@property (nonatomic,strong) DataClass* data;

@end

@implementation FoundRecipesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.data = [DataClass getInstance];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    //clear the recipeAry if popping the view to SearchRecipeViewController
    if (self.isMovingFromParentViewController == YES){
        [self.recipeAry removeAllObjects];
    }
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recipeAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.frame.size.height / 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"RecipeCell";
    UIFoundRecipeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UIFoundRecipeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Recipe *recipe = self.recipeAry[indexPath.row];
    
    cell.recipeTitleLabel.text = recipe.title;
    cell.recipeDescriptionLabel.text = recipe.desc;
    cell.imageView.image = [UIImage imageNamed:@"recipedefault.png"];
    cell.starRatingView.value = [recipe.rating doubleValue];
    
    if ([recipe.recipeCreateUserName isEqual:@""]){
        cell.recipeChefLabel.text = @"By Unknown Chef";
        CompletionWeb getProfileCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
            NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
            recipe.recipeCreateUserName = [userDict objectForKey:@"userName"];
            cell.recipeChefLabel.text = recipe.recipeCreateUserName;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.tableView reloadData];
            });
        };
        
        [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"userID=%@",recipe.recipeCreateUser] withURLEnd:@"getProfile" withCompletionHandler:getProfileCompletion];
    }
    else{
        cell.recipeChefLabel.text = recipe.recipeCreateUserName;
    }
    
    //retrieve image from server if it hasn't been already
    if (![recipe.imageName  isEqual: @""] && recipe.image == nil){
        
        CompletionWeb addImageCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
            UIImage *retImage = [UIImage imageWithData:postData];
            NSLog(@"in completion handler for addImage");
            if (retImage != nil){
                NSLog(@"adding image with imagename = %@ with title %@ with indexPath %ld",recipe.imageName, recipe.title, (long)indexPath.row);
                recipe.image = retImage;
                cell.imageView.image = recipe.image;
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.tableView reloadData];
                });
            }
            
        };
        
        [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"imageName=%@",recipe.imageName] withURLEnd:@"getImageThumbnail" withCompletionHandler:addImageCompletion];
        
    }
    else if (recipe.image){
        cell.imageView.image = recipe.image;
    }
    
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
                                     [self.data addRecipe:self.recipeAry[indexPath.row]];
                                     
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
