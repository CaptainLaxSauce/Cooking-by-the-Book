//
//  UIFriendBox.h
//  Cooking by the Book
//
//  Created by Jack Smith on 2/11/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "Constants.h"


@interface UIFriendBox : UIView

@property (nonatomic,strong) Friend *frd;
@property (nonatomic,strong) UIImageView *profileImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *mutualFriendsLabel;

-(id) initWithFrame:(CGRect)frame withFriend:(Friend *)frd;

@end
