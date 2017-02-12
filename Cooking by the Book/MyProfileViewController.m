//
//  MyProfileViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "MyProfileViewController.h"
#import "UIColor+CustomColors.h"
#import "DataClass.h"
#import "Helper.h"
#import "UIPost.h"
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
    NSMutableArray *postAry;
    UIImageView *imageSelectView;
    DataClass *obj;
}

-(void)refreshPosts{
    
    [self resetcurrPostPos];
    
    for (int i = 0; i < postAry.count; i++){
        [[postAry objectAtIndex:i] removeFromSuperview];
        [postAry removeObject:[postAry objectAtIndex:i]];
        i = i - 1;
    }
    
    NSString *post = [NSString stringWithFormat:@"userID=%@" ,obj.userId];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"getUserPosts"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSString *ret = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"post return = %@",ret);
        

        NSDictionary *jsonPostDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSLog(@"postDict count = %lu",(unsigned long)jsonPostDict.count);
        NSArray *jsonPostAry = [jsonPostDict objectForKey:@"postsInfo"];
        NSLog(@"postAry count = %lu",(unsigned long)jsonPostAry.count);

            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                for (int i = 0; i < jsonPostAry.count; i++)
                {
                    NSDictionary *postDict = [jsonPostAry objectAtIndex:i];
                    [self addPost:postDict];
                }
            });
    }];
    
    [dataTask resume];

}

-(void)viewDidAppear:(BOOL)animated{
    [self refreshPosts];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    objectWidth = screenWidth - objectBreak*2;
    textHeight = screenHeight/20;
    acheivementHeight = textHeight; //this will need to change, just using for testing
    tabHeight = self.tabBarController.tabBar.frame.size.height;
    scrollHeight = screenHeight-tabHeight-navBarHeight-statusBarHeight;
    postHeight = textHeight*6;
    obj = [DataClass getInstance];
    
    self.view.backgroundColor = [UIColor primaryColor];
    self.navigationItem.title = @"Profile";
    //UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editProfileTouch:)];
    //self.navigationItem.leftBarButtonItem = editButton;
    
    //add scroll view
    UIScrollView *scrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, screenWidth, scrollHeight)];
    scrollView_.backgroundColor = [UIColor customGrayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [scrollView_ setContentSize:CGSizeMake(objectWidth, objectBreak*3 + imageWidth + textHeight*2)];
    self.scrollView = scrollView_;
    [self.view addSubview:scrollView_];
    
    /*
    UIImageView *profileImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2 - imageWidth/2, objectBreak, imageWidth, imageWidth)];
    [profileImageView_ setImage:[UIImage imageNamed:@"blankface.png"]];
    self.profileImageView = profileImageView_;
    [self.scrollView addSubview:profileImageView_];
    */
    
    imageSelectView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2 - imageWidth/2, objectBreak, imageWidth, imageWidth)];
    [imageSelectView setImage:[UIImage imageNamed:@"addimage.png"]];
    imageSelectView.contentMode = UIViewContentModeCenter;
    imageSelectView.userInteractionEnabled = YES;
    [[imageSelectView layer] setBorderWidth:2.0];
    [[imageSelectView layer] setBorderColor:[UIColor blackColor].CGColor];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTouch:)];
    [imageSelectView addGestureRecognizer:imageTap];
    [self.scrollView addSubview:imageSelectView];
    
    UIImageView *cameraImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageSelectView.frame.size.width - imageSelectView.frame.size.width/8 - 5, 0, imageSelectView.frame.size.width/8, imageSelectView.frame.size.width/8)];
    [cameraImageView setImage:[UIImage imageNamed:@"cameraicon.png"]];
    cameraImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *cameraTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraTouch:)];
    [cameraImageView addGestureRecognizer:cameraTap];
    [imageSelectView addSubview:cameraImageView];
    
    UILabel *titleLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak*2 + imageWidth, objectWidth, textHeight)];
    titleLabel_.textAlignment = NSTextAlignmentCenter;
    titleLabel_.text = [NSString stringWithFormat:@"Chef %@",[obj.profileDict objectForKey:@"userName"]];
    UIFontDescriptor * fontD = [titleLabel_.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    titleLabel_.font = [UIFont fontWithDescriptor:fontD size:20];
    [self.scrollView addSubview:titleLabel_];
    
    UIAchievementBar *achBar = [[UIAchievementBar alloc]initWithFrame:CGRectMake(objectBreak, objectBreak*3 + imageWidth + textHeight, objectWidth, acheivementHeight)];
    [self.scrollView addSubview:achBar];
    
    UIBarButtonItem *friendsButton = [[UIBarButtonItem alloc] initWithTitle:@"Friends" style:UIBarButtonItemStylePlain target:self action:@selector(friendsTouch:)];
    self.navigationItem.rightBarButtonItem = friendsButton;
    
    [self resetcurrPostPos];
    
}

-(void)addPost:(NSDictionary *)postDict{
    
    UIPost *post = [[UIPost alloc]initWithFrame:CGRectMake(0, currPostPos, screenWidth, postHeight)
                                     withPostID:[postDict objectForKey:@"postID"]
                                  withCreatorID:[postDict objectForKey:@"postCreatorID"]
                                      withTitle:[postDict objectForKey:@"postTitle"]
                                       withBody:[postDict objectForKey:@"postBody"]
                                   withRecipeID:[postDict objectForKey:@"postRecipeID"]
                                   withDateTime:[Helper fromUTC:[postDict objectForKey:@"postDateTime"]]
                                  withLikeCount:[postDict objectForKey:@"postLikesNumber"]
                               withCommentCount:[postDict objectForKey:@"postCommentsNumber"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchPost:)];
    [post addGestureRecognizer:tap];
     
    [postAry addObject:post];
    [self.scrollView addSubview:post];
    
    currPostPos = currPostPos + post.frame.size.height + objectBreak;
    [self.scrollView setContentSize:CGSizeMake(objectWidth, currPostPos)];
    
}

-(void)touchPost:(UITapGestureRecognizer *)sender{
    UIPost *post = (UIPost *)sender.view;
    obj.currDetailedPost = post;
    
    [self performSegueWithIdentifier:@"DetailedPostViewController" sender:sender];
    
}

-(void)resetcurrPostPos{
    currPostPos = objectBreak*4 + imageWidth + acheivementHeight + textHeight;
}

@end
