//
//  CreatePostViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 1/8/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePostViewController : UIViewController

typedef void (^completionWeb)(NSData *postData, NSURLResponse *response, NSError *error);

@property (nonatomic,strong) NSString *recipeID;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@property (copy) completionWeb postCompletion;
@property (copy) completionWeb ratingCompletion;

@end

