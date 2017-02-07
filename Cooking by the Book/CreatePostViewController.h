//
//  CreatePostViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 1/8/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePostViewController : UIViewController

@property NSString *recipeID;
@property (copy) void (^postCompletion)(NSData *postData, NSURLResponse *response, NSError *error);
@property (copy) void (^ratingCompletion)(NSData *postData, NSURLResponse *response, NSError *error);

@end

