//
//  DetailedPostViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 9/21/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface DetailedPostViewController : UIViewController

@property (nonatomic,strong) NSString *postId;
@property (nonatomic,strong) Post *post;


@end
