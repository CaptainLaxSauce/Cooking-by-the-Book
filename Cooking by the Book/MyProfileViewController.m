//
//  MyProfileViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "MyProfileViewController.h"
#import "DetailedPostViewController.h"
#import "UIColor+CustomColors.h"
#import "DataClass.h"
#import "Helper.h"
#import "UIPost.h"
#import "Post.h"
#import "UIAchievementBar.h"
#import "Constants.h"
#import "UIPostTableViewCell.h"

@implementation MyProfileViewController
{
    int screenHeight;
    int screenWidth;
    int statusBarHeight;
    int navBarHeight;
    int textHeight;
    int objectWidth;
    int scrollHeight;
    int tabHeight;
    int imageWidth;
    int postHeight;
    int acheivementHeight;
    int currPostPos;
    UIImageView *imageSelectView;
    DataClass *obj;
}

-(void)refreshPosts{
    [self.postAry removeAllObjects];
    [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"userID=%@",obj.userId] withURLEnd:@"getUserPosts" withCompletionHandler:[self getUserPostsCompletion]];
    
}

-(CompletionWeb) getUserPostsCompletion {
    CompletionWeb userPostCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonPostDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSArray *jsonPostAry = [jsonPostDict objectForKey:@"postsInfo"];
        
        NSLog(@"jsonPostAry = %@",jsonPostAry);
        
        for (int i = 0; i < jsonPostAry.count; i++)
        {
            NSDictionary *postDict = [jsonPostAry objectAtIndex:i];
            Post *post = [[Post alloc]initWithJSONDict:postDict];
            NSLog(@"post title = %@",post.title);
            
            [self.postAry addObject:post];
        }
        
        NSLog(@"postAry before reloading table data = %@", self.postAry);
        [self reloadTableDataAsync];
        
    };
    
    return userPostCompletion;
}

-(void)reloadTableDataAsync{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.postTableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    
}

-(void)editProfileTouch:(id)sender {
    NSLog(@"EDIT");
}

-(void)imageTouch:(id)sender{
    NSLog(@"Image Touch");
    
    //[self performSegueWithIdentifier:@"ImagePickerViewController" sender:sender];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)cameraTouch:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageSelectView.image = chosenImage;
    imageSelectView.contentMode = UIViewContentModeScaleAspectFit;
    
    [picker dismissViewControllerAnimated:YES completion:^(void){
        [Helper submitImage:obj.userId withURLEnd:@"addImageToProfile" withImage:imageSelectView.image];
    } ];
}

-(void)friendsTouch:(id)sender{
    [self performSegueWithIdentifier:@"MyFriendsViewController" sender:sender];
}


-(void)loadInterface{
    //declare constants
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    navBarHeight = self.navigationController.navigationBar.frame.size.height;
    imageWidth = screenWidth/3;
    objectWidth = screenWidth - OBJECT_BREAK*2;
    textHeight = screenHeight/20;
    acheivementHeight = textHeight; //this will need to change, just using for testing
    tabHeight = self.tabBarController.tabBar.frame.size.height;
    scrollHeight = screenHeight-tabHeight-navBarHeight-statusBarHeight;
    postHeight = textHeight*6;
    obj = [DataClass getInstance];
    
    self.navigationItem.title = @"Profile";
    
    UIBarButtonItem *friendsButton = [[UIBarButtonItem alloc] initWithTitle:@"Friends" style:UIBarButtonItemStylePlain target:self action:@selector(friendsTouch:)];
    self.navigationItem.rightBarButtonItem = friendsButton;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.postTableView = tableView;
    
    /*
    UIImageView *profileImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2 - imageWidth/2, OBJECT_BREAK, imageWidth, imageWidth)];
    [profileImageView_ setImage:[UIImage imageNamed:@"blankface.png"]];
    self.profileImageView = profileImageView_;
    [self.scrollView addSubview:profileImageView_];
    */
    
    imageSelectView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2 - imageWidth/2, OBJECT_BREAK, imageWidth, imageWidth)];
    [imageSelectView setImage:[UIImage imageNamed:@"addimage.png"]];
    imageSelectView.contentMode = UIViewContentModeCenter;
    imageSelectView.userInteractionEnabled = YES;
    [[imageSelectView layer] setBorderWidth:2.0];
    [[imageSelectView layer] setBorderColor:[UIColor blackColor].CGColor];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTouch:)];
    [imageSelectView addGestureRecognizer:imageTap];
    
    UIImageView *cameraImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageSelectView.frame.size.width - imageSelectView.frame.size.width/8 - 5, 0, imageSelectView.frame.size.width/8, imageSelectView.frame.size.width/8)];
    [cameraImageView setImage:[UIImage imageNamed:@"cameraicon.png"]];
    cameraImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *cameraTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraTouch:)];
    [cameraImageView addGestureRecognizer:cameraTap];
    [imageSelectView addSubview:cameraImageView];
    
    UILabel *titleLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(OBJECT_BREAK, OBJECT_BREAK*2 + imageWidth, objectWidth, textHeight)];
    titleLabel_.textAlignment = NSTextAlignmentCenter;
    titleLabel_.text = [NSString stringWithFormat:@"Chef %@",[obj.profileDict objectForKey:@"userName"]];
    UIFontDescriptor * fontD = [titleLabel_.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    titleLabel_.font = [UIFont fontWithDescriptor:fontD size:20];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, imageWidth + textHeight + OBJECT_BREAK * 3 + 10)];
    [headerView addSubview:imageSelectView];
    [headerView addSubview:titleLabel_];
    
    self.postTableView.tableHeaderView = headerView;
    self.postTableView.dataSource = self;
    self.postTableView.delegate = self;
    self.postTableView.rowHeight = self.postTableView.frame.size.height / 2;
    self.postTableView.backgroundColor = [UIColor lightGrayColor];
    
    self.postAry = [[NSMutableArray alloc]init];
    
    [self refreshPosts];
    //UIAchievementBar *achBar = [[UIAchievementBar alloc]initWithFrame:CGRectMake(OBJECT_BREAK, OBJECT_BREAK*3 + imageWidth + textHeight, objectWidth, acheivementHeight)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"count of postAry = %lu",(unsigned long)self.postAry.count);
    return self.postAry.count;
    //return the number of recipes found or max 20
    
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.postTableView.frame.size.height / 3;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *SimpleIdentifier = @"SimpleIdentifier";
    UIPostTableViewCell *cell = [self.postTableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    
    if (cell == nil) {
        cell = [[UIPostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleIdentifier];
        
        Post *post = self.postAry[indexPath.section];
    
        cell.titleLabel.text = post.title;
        cell.bodyLabel.text = post.body;
        cell.recipeTitleLabel.text = post.recipe.title;
        cell.recipeDescLabel.text = post.recipe.desc;
        cell.starRatingView.value = 3; //TODO add user rating value to posts
        [cell.likeButton setTitle:[NSString stringWithFormat:@"%@ likes",post.likeCount] forState:UIControlStateNormal];
        [cell.commentButton setTitle:[NSString stringWithFormat:@"%@ comments",post.commentCount] forState:UIControlStateNormal];
        
        NSLog(@"post.title = %@",post.title);
    //cell.detailTextLabel.text = post.body;
    //cell.imageView.image = [UIImage imageNamed:@"recipedefault.png"];
    
    //retrieve image from server if it hasn't been already
    /*
    if (![post.imageName  isEqual: @""] && recipe.image == nil){
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
    */
    
    //[cell.contentView addSubview:starView];
    }
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    Post *post = self.postAry[indexPath.section];
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

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                 {
                                     //delete post from server and remove it from view
                                     //[obj addRecipe:self.recipeAry[indexPath.row]];
                                     
                                     //retract the button
                                     [tableView beginUpdates];
                                     [tableView setEditing:NO animated:NO];
                                     [tableView endUpdates];
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

@end
