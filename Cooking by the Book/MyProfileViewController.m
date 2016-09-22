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

@implementation MyProfileViewController
{
    int screenHeight;
    int screenWidth;
    int statusBarHeight;
    int navBarHeight;
    int objectBreak;
    int textHeight;
    int objectWidth;
    int scrollHeight;
    int tabHeight;
    int imageWidth;
    int postHeight;
    int acheivementHeight;
    int currPostPos;
    NSMutableArray *postAry;
}

-(void)refreshPosts{
    
    [self resetcurrPostPos];
    
    for (int i = 0; i < postAry.count; i++){
        [[postAry objectAtIndex:i] removeFromSuperview];
        [postAry removeObject:[postAry objectAtIndex:i]];
        i = i - 1;
    }
    
    DataClass *obj = [DataClass getInstance];
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

-(void)loadInterface{
    //declare constants
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    navBarHeight = self.navigationController.navigationBar.frame.size.height;
    objectBreak = 8;
    imageWidth = screenWidth/3;
    objectWidth = screenWidth - objectBreak*2;
    textHeight = screenHeight/20;
    acheivementHeight = textHeight; //this will need to change, just using for testing
    tabHeight = self.tabBarController.tabBar.frame.size.height;
    scrollHeight = screenHeight-tabHeight-navBarHeight-statusBarHeight;
    postHeight = textHeight*6;
    
    self.view.backgroundColor = [UIColor primaryColor];
    self.navigationItem.title = @"Profile";
    
    //add scroll view
    UIScrollView *scrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, screenWidth, scrollHeight)];
    scrollView_.backgroundColor = [UIColor primaryColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [scrollView_ setContentSize:CGSizeMake(objectWidth, objectBreak*3 + imageWidth + textHeight*2)];
    self.scrollView = scrollView_;
    [self.view addSubview:scrollView_];
    
    UIImageView *profileImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2 - imageWidth/2, objectBreak, imageWidth, imageWidth)];
    [profileImageView_ setImage:[UIImage imageNamed:@"blankface.png"]];
    self.profileImageView = profileImageView_;
    [self.scrollView addSubview:profileImageView_];
    
    UILabel *titleLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak*2 + imageWidth, objectWidth, textHeight)];
    titleLabel_.textAlignment = NSTextAlignmentCenter;
    UIFontDescriptor * fontD = [titleLabel_.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    titleLabel_.font = [UIFont fontWithDescriptor:fontD size:0];
    titleLabel_.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:titleLabel_];
    
    UILabel *descLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak*4 + imageWidth + acheivementHeight, objectWidth, textHeight)];
    descLabel_.backgroundColor = [UIColor orangeColor];
    [self.scrollView addSubview:descLabel_];
    
    [self resetcurrPostPos];
    
}

-(void)addPost:(NSDictionary *)postDict{
    
    UIPost *post = [[UIPost alloc]initWithFrame:CGRectMake(objectBreak, currPostPos, objectWidth, postHeight)
                                     withPostID:[postDict objectForKey:@"postID"]
                                  withCreatorID:[postDict objectForKey:@"postCreatorID"]
                                      withTitle:[postDict objectForKey:@"postTitle"]
                                       withBody:[postDict objectForKey:@"postBody"]
                                   withRecipeID:[postDict objectForKey:@"postRecipeID"]
                                   withDateTime:[Helper fromUTC:[postDict objectForKey:@"postDateTime"]]
                                  withLikeCount:[postDict objectForKey:@"postLikesNumber"]
                               withCommentCount:[postDict objectForKey:@"postCommentsNumber"]];
     
    [postAry addObject:post];
    [self.scrollView addSubview:post];
    
    currPostPos = currPostPos + post.frame.size.height + objectBreak;
    [self.scrollView setContentSize:CGSizeMake(objectWidth, currPostPos)];
    
}

-(void)resetcurrPostPos{
    currPostPos = objectBreak*5 + imageWidth + acheivementHeight + textHeight;
}

@end
