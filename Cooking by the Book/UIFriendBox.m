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

float const LABEL_FRACTION = 1/6;

-(id) initWithFrame:(CGRect)frame withFriend:(Friend *)frd{
    self = [super initWithFrame:frame];
    
    if (self) {
        _frd = frd;
        
        [self loadInterface];
        [self configureAddImageCompletion];
       
        [Helper getImageWithName:frd.imageName withCompletion:self.addImageCompletion];
        
    }
    
    return self;
}

-(void) configureAddImageCompletion {
    CompletionWeb addImageCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.profileImageView.image = [UIImage imageWithData:postData];
        });
    };
    self.addImageCompletion = addImageCompletion;
}

-(void) addImageWeb {
    
}


-(void) loadInterface{
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    int imageHeight = height - (height * LABEL_FRACTION);
    
    self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, imageHeight)];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageHeight, width, height * LABEL_FRACTION)];
    self.nameLabel.text = self.frd.name;
    
    self.mutualFriendsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageHeight - (height * LABEL_FRACTION), width, (height * LABEL_FRACTION))];
    self.mutualFriendsLabel.backgroundColor = [UIColor transparentGrayColor];
    self.mutualFriendsLabel.textColor = [UIColor whiteColor];
    self.mutualFriendsLabel.text = [NSString stringWithFormat:@"%@ mutual",self.frd.mutualFriends];
}

@end
