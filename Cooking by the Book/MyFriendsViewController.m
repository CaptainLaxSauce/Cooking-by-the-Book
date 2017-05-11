//
//  MyFriendsViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 2/11/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "DataClass.h"
#import "Friend.h"
#import "UIFriendBox.h"
#import "Helper.h"
#import "ProfileTableViewController.h"

@interface MyFriendsViewController ()

@end

@implementation MyFriendsViewController
{
    DataClass *obj;
    int friendWidth;
    int friendHeight;
    int scrollHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    [self getFriendsWeb];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGRect)getCurrFrame:(int)i{
    int x;
    int y;
    
    //even numbers are in left column
    if (i % 2 == 0){
        x = OBJECT_BREAK;

    }
    //odd numbers in right column
    else {
        x = OBJECT_BREAK*2 + friendWidth;
    }
    
    y = OBJECT_BREAK + i/2 * (friendHeight + OBJECT_BREAK);
    
    return(CGRectMake(x, y, friendWidth, friendHeight));
    
}

-(void)resizeScrollView{
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
}

-(void)getFriendsWeb {
    [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"userID=%@",obj.authData.userId]
                          withURLEnd:@"getAllFriends"
                            withAuth:YES
               withCompletionHandler:[self getFriendsCompletion]];
}

-(CompletionWeb)getFriendsCompletion{
    CompletionWeb getFriendsCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
        NSDictionary *retDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSArray *jsonFriendAry = [retDict objectForKey:@"friends"];
        
        NSMutableArray *friendAry_ = [[NSMutableArray alloc]init];
        self.friendAry = friendAry_;
        
        //create friend arrays
        for (int i = 0; i < jsonFriendAry.count; i++) {
            NSDictionary *friendDict = [jsonFriendAry objectAtIndex:i];
            Friend *frd = [[Friend alloc]initWithName:[friendDict objectForKey:@"userName"]
                                           withUserId:[friendDict objectForKey:@"friendUserID"]
                                        withImageName:[friendDict objectForKey:@"userImage"]
                                    withMutualFriends:[friendDict objectForKey:@"mutualFriends"]];
            
            [self.friendAry addObject:frd];
   
        }
        
        [self addFriendBoxesToViewAsync];

    };
    return getFriendsCompletion;
}

-(void) addFriendBoxesToViewAsync {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        for (int i = 0; i < self.friendAry.count; i++){
            CGRect currFrame = [self getCurrFrame:i];
            UITapGestureRecognizer *friendTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(friendTouch:)];
            UIFriendBox *frdBox = [[UIFriendBox alloc]initWithFrame:currFrame withFriend:(Friend *)self.friendAry[i]];
            [frdBox addGestureRecognizer:friendTap];
            if (![((Friend*)self.friendAry[i]).imageName  isEqual: @""]){
                [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"imageName=%@",((Friend*)self.friendAry[i]).imageName] withURLEnd:@"getImageThumbnail" withAuth:YES withCompletionHandler:[self getAddImageCompletion:frdBox]];
            }
            
            
            [self.scrollView addSubview:frdBox];
            [self resizeScrollView];
            
        }
    });
}

-(CompletionWeb) getAddImageCompletion:(UIFriendBox *)box{
    CompletionWeb addImageCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error) {
        if (postData)
        box.profileImageView.image = [UIImage imageWithData:postData];
    };
    return addImageCompletion;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ProfileTableViewController"]){
        ProfileTableViewController *controller = (ProfileTableViewController *)segue.destinationViewController;
        controller.frd = ((UIFriendBox *)sender).frd;
        
    }
}

-(void) friendTouch:(UIGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"ProfileTableViewController" sender:(UIFriendBox *)sender.view];
}

-(void) addFriendsTouch:(id)sender{
    [self performSegueWithIdentifier:@"AddFriendsViewController" sender:sender];
}

-(void)loadInterface{
    self.navigationItem.title = @"Friends";
    
    obj = [DataClass getInstance];
    
    friendWidth = (self.view.frame.size.width - OBJECT_BREAK * 3) / 2;
    friendHeight = friendWidth + (friendWidth * FRIEND_LABEL_FRACTION);
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addFriendsTouch:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIScrollView *scrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView = scrollView_;
    [self.view addSubview:scrollView_];
    
}

@end
