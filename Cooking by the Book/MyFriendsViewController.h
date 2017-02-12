//
//  MyFriendsViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 2/11/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface MyFriendsViewController : UIViewController


@property (nonatomic,strong) NSMutableArray *friendAry;
@property (copy) CompletionWeb getAllFriendsCompletion;

@end
