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
    UITableView *postTableView;
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
        
        for (int i = 0; i < jsonPostAry.count; i++)
        {
            NSDictionary *postDict = [jsonPostAry objectAtIndex:i];
            Post *post = [[Post alloc]initWithPostID:[postDict objectForKey:@"postID"]
                                          withCreatorID:[postDict objectForKey:@"postCreatorID"]
                                              withTitle:[postDict objectForKey:@"postTitle"]
                                               withBody:[postDict objectForKey:@"postBody"]
                                           withRecipeID:[postDict objectForKey:@"postRecipeID"]
                                           withDateTime:[Helper fromUTC:[postDict objectForKey:@"postDateTime"]]
                                          withLikeCount:[postDict objectForKey:@"postLikesNumber"]
                                       withCommentCount:[postDict objectForKey:@"postCommentsNumber"]];
            
            
            [self.postAry addObject:post];
        }
    };
    
    return userPostCompletion;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self refreshPosts];
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
    
    //UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editProfileTouch:)];
    //self.navigationItem.leftBarButtonItem = editButton;
    
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
    
    UIAchievementBar *achBar = [[UIAchievementBar alloc]initWithFrame:CGRectMake(OBJECT_BREAK, OBJECT_BREAK*3 + imageWidth + textHeight, objectWidth, acheivementHeight)];
    
}

-(void)addPost:(NSDictionary *)postDict{
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.postAry count];
    //return the number of recipes found or max 20
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *SimpleIdentifier = @"SimpleIdentifier";
    UITableViewCell *cell = [postTableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleIdentifier];
    }
    
    Post *post = self.postAry[indexPath.row];
    
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.body;
    cell.imageView.image = [UIImage imageNamed:@"recipedefault.png"];
    
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
