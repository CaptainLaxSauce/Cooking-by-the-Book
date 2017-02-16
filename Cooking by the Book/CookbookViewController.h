//
//  CookbookViewController.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookbookViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>

typedef enum TagType : int{
    quick = 0,
    simple = 1,
    vegetarian = 2,
    vegan = 3
    
} TagType;

@property (nonatomic,strong) NSMutableArray *recipeAry;
@property (nonatomic,strong) UITableView *recipeTableView;
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) NSArray *searchResults;
@property (nonatomic,strong) UIButton *createRecipeButton;

-(void)createRecipeTouch:(id)sender;
-(void)deleteRecipe:(NSIndexPath *)indexPath;

@end
