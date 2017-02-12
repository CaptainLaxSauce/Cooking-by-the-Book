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

@interface MyFriendsViewController ()

@end

@implementation MyFriendsViewController
{
    DataClass *obj;
    UIScrollView *scrollView;
    int friendCnt;
    int friendWidth;
    int friendHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    [self configureGetFriendsCompletion];
    [self getFriendsWeb];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGRect)getCurrFrame{
    int x;
    int y;
    
    //even numbers are in left column
    if (friendCnt % 2 == 0){
        x = objectBreak;
    }
    //odd numbers in right column
    else {
        x = objectBreak*2 + friendWidth;
    }
    
    y = objectBreak + friendCnt/2 * (friendHeight + objectBreak);
    
    return(CGRectMake(x, y, friendWidth, friendHeight));
    
}

-(void)getFriendsWeb {
    [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"userID=%@",obj.userId]
                          withURLEnd:@"getAllFriends"
               withCompletionHandler:self.getAllFriendsCompletion];
}

-(void)configureGetFriendsCompletion{
    CompletionWeb getFriendsCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
        NSString *ret = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"get all friends ret = %@",ret);
        
        NSDictionary *retDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSArray *friendAry = [retDict objectForKey:@"friends"];
        
        for (int i = 0; i < friendAry.count; i++) {
            NSDictionary *friendDict = [friendAry objectAtIndex:i];
            Friend *frd = [[Friend alloc]initWithName:[friendDict objectForKey:@"userName"]
                                           withUserId:[friendDict objectForKey:@"friendUserID"]
                                        withImageName:[friendDict objectForKey:@"userImage"]
                                    withMutualFriends:[friendDict objectForKey:@"mutualFriends"]];
            
            [self.friendAry addObject:frd];
            
            CGRect currFrame = [self getCurrFrame];
            UIFriendBox *frdBox = [[UIFriendBox alloc]initWithFrame:currFrame withFriend:frd];
            frdBox.backgroundColor = [UIColor orangeColor];
            [scrollView addSubview:frdBox];
            
            friendCnt++;
            
        }
        

    };
    self.getAllFriendsCompletion = getFriendsCompletion;
}



-(void)loadInterface{
    self.navigationItem.title = @"Friends";
    
    obj = [DataClass getInstance];
    
    friendWidth = (self.view.frame.size.width - objectBreak * 3) / 2;
    friendHeight = friendWidth + (friendWidth * LABEL_FRACTION);
    friendCnt = 0;
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:scrollView];
    
}

@end
