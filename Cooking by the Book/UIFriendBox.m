//
//  UIFriendBox.m
//  Cooking by the Book
//
//  Created by Jack Smith on 2/11/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "UIFriendBox.h"
#import "UIColor+CustomColors.h"
#import "Helper.h"

@implementation UIFriendBox

-(id) initWithFrame:(CGRect)frame withFriend:(Friend *)frd_{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frd = frd_;
        [self loadInterface];

    }
    
    return self;
}



-(void) loadInterface{
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    int imageHeight = height - (height * FRIEND_LABEL_FRACTION);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, imageHeight)];
    imageView.image = [UIImage imageNamed:@"blankface.png"];
    [self addSubview:imageView];
    self.profileImageView = imageView;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageHeight, width, height * FRIEND_LABEL_FRACTION)];
    nameLabel.text = self.frd.username;
    NSLog(@"adding Name label %@",self.frd.username);
    [self addSubview:nameLabel];
     self.nameLabel = nameLabel;
    
    UILabel *mutualLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageHeight - (height * FRIEND_LABEL_FRACTION), width, (height * FRIEND_LABEL_FRACTION))];
    mutualLabel.backgroundColor = [UIColor transparentGrayColor];
    mutualLabel.textColor = [UIColor whiteColor];
    mutualLabel.text = [NSString stringWithFormat:@"%@ mutual",self.frd.mutualFriends];
    [self addSubview:mutualLabel];
    self.mutualFriendsLabel = mutualLabel;
}

@end
