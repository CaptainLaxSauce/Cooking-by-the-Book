//
//  DetailedPostTableViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 4/13/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"


@interface DetailedPostTableViewController : UITableViewController

@property (nonatomic,strong) Post *post;
@property (nonatomic,strong) NSString *postId;
@property (nonatomic,strong) NSMutableArray *commentAry;



@end
