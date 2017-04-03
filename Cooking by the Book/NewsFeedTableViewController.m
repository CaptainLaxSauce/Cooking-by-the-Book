//
//  NewsFeedTableViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 4/2/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "UINewsFeedTableViewCell.h"
#import "Helper.h"
#import "DataClass.h"
#import "DetailedPostViewController.h"

@interface NewsFeedTableViewController ()

@end

@implementation NewsFeedTableViewController
{
    DataClass *obj;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.title = @"News Feed";
    
    obj = [DataClass getInstance];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshPosts) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.refreshControl = refreshControl;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    
    self.postAry = [[NSMutableArray alloc]init];
    
    [self refreshPosts];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)refreshPosts{
    [self.postAry removeAllObjects];
    [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"userID=%@",obj.userId] withURLEnd:@"getNewsFeed" withCompletionHandler:[self getNewsFeedCompletion]];
    
}

-(CompletionWeb) getNewsFeedCompletion {
    CompletionWeb userPostCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonPostDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSArray *jsonPostAry = [jsonPostDict objectForKey:@"newsFeedInfo"];
        
        for (int i = 0; i < jsonPostAry.count; i++)
        {
            NSDictionary *postDict = [jsonPostAry objectAtIndex:i];
            Post *post = [[Post alloc]initWithNewsFeedJSONDict:postDict];
            
            [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"userID=%@",post.creatorID] withURLEnd:@"getProfile" withCompletionHandler:[self getUserCompletion:post]];
            [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"recipeID=%@",post.recipe.recipeID] withURLEnd:@"getImageThumbnail" withCompletionHandler:[self getRecipeImageCompletion:post.recipe]];
            
            [self.postAry addObject:post];
        }
        
        [self reloadTableDataAsync];
        
    };
    
    return userPostCompletion;
}

-(CompletionWeb)getUserCompletion:(Post*)post{
    CompletionWeb userCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonUserDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        
        User *user = [[User alloc]initWithDict:jsonUserDict];
        post.user = user;
        
        if(![user.imageName isEqual:@""]){
            [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"imageName=%@",user.imageName] withURLEnd:@"getImageThumbnail" withCompletionHandler:[self getPosterImageCompletion:user]];
        }
    };
    
    return userCompletion;
}

-(CompletionWeb)getPosterImageCompletion:(User *)user{
    CompletionWeb imageCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error) {
        UIImage *image = [UIImage imageWithData:postData];
        
        if (image){
            user.profileImage = image;
        }
        
        [self reloadTableDataAsync];
    };
    return imageCompletion;
}

-(CompletionWeb)getRecipeImageCompletion:(Recipe*)recipe{
    CompletionWeb imageCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error) {
        UIImage *image = [UIImage imageWithData:postData];
        
        if (image){
            recipe.image = image;
        }
        
        [self reloadTableDataAsync];
    };
    return imageCompletion;
}

-(void)reloadTableDataAsync{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    });
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleIdentifier = @"SimpleIdentifier";
    UINewsFeedTableViewCell *cell = (UINewsFeedTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[UINewsFeedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    Post *post = [self.postAry objectAtIndex:indexPath.row];
    cell.userImageView.image = post.user.profileImage;
    cell.bodyLabel.text = post.body;
    cell.chefLabel.text = [Helper chefName:post.user.chefLevelName
                                  withName:post.user.userName];
    cell.timeLabel.text = post.dateTime;
    cell.titleLabel.text = post.title;
    cell.recipeTitleLabel.text = post.recipe.title;
    cell.recipeDescLabel.text = post.recipe.desc;
    cell.starRatingView.value = 3; //TODO add user rating value to the posts
    //[cell.likeButton setTitle:[NSString stringWithFormat:@"%@ likes",post.likeCount] forState:UIControlStateNormal];
    //[cell.commentButton setTitle:[NSString stringWithFormat:@"%@ comments",post.commentCount] forState:UIControlStateNormal];

    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    Post *post = self.postAry[indexPath.row];
    id sender = post;
    [self performSegueWithIdentifier:@"DetailedPostViewController" sender:sender];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"DetailedPostViewController"]){
        DetailedPostViewController *controller = (DetailedPostViewController *)segue.destinationViewController;
        controller.post = ((Post *)sender);
        controller.postId = ((Recipe *)sender).recipeID;
    }
    
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
