//
//  FoundRecipesViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 1/15/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundRecipesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *recipeAry;

@end
