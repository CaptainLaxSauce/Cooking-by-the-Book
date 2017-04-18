//
//  ProfileTableViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 4/11/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface ProfileTableViewController : UITableViewController

@property (nonatomic,strong) Friend *frd;
@property (nonatomic,strong) NSMutableArray *postAry;

@end
