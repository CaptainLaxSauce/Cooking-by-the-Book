//
//  UIFriendCollectionViewCell.h
//  Cooking by the Book
//
//  Created by Jack Smith on 4/4/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface UIFriendCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *mutualLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) Friend *frd;


@end
