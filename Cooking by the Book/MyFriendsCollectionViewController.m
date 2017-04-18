//
//  MyFriendsCollectionViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 4/4/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "MyFriendsCollectionViewController.h"
#import "UIFriendCollectionViewCell.h"
#import "Friend.h"
#import "Constants.h"
#import "Helper.h"
#import "DataClass.h"
#import "ProfileTableViewController.h"

@interface MyFriendsCollectionViewController ()

@end

@implementation MyFriendsCollectionViewController
static NSString * const reuseIdentifier = @"Cell";
DataClass *obj;
int itemsPerRow = 2;
UIEdgeInsets insets;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    insets = UIEdgeInsetsMake(8, 4, 8, 4);
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.navigationItem.title = @"Friends";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addFriendTouch:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    obj = [DataClass getInstance];
    self.friendAry = [[NSMutableArray alloc]init];
    [self refreshFriends];
    
}

-(void) addFriendTouch:(id)sender{
    [self performSegueWithIdentifier:@"AddFriendsViewController" sender:sender];
    
}

-(void)refreshFriends{
    [self.friendAry removeAllObjects];
    [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"userID=%@",obj.userId]
                          withURLEnd:@"getAllFriends"
               withCompletionHandler:[self getFriendsCompletion]];
}

-(void)reloadCollectionDataAsync{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.collectionView reloadData];
    });
}

-(CompletionWeb)getFriendsCompletion{
    CompletionWeb getFriendsCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
        NSDictionary *retDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSLog(@"friend ret dict = %@", retDict);
        NSArray *jsonFriendAry = [retDict objectForKey:@"friends"];
        
        //create friend arrays
        for (int i = 0; i < jsonFriendAry.count; i++) {
            NSDictionary *friendDict = [jsonFriendAry objectAtIndex:i];
            Friend *frd = [[Friend alloc]initWithDict:friendDict];
            if(![frd.imageName  isEqual: @""]){
                NSLog(@"image is named %@",frd.imageName);
                [Helper submitHTTPPostWithString:[NSString stringWithFormat:@"imageName=%@",frd.imageName]
                                      withURLEnd:@"getImageThumbnail"
                           withCompletionHandler:[self getAddImageCompletion:frd]];
            }
            
            [self.friendAry addObject:frd];
            
        }
        
        [self reloadCollectionDataAsync];
        
    };
    return getFriendsCompletion;
}

-(CompletionWeb) getAddImageCompletion:(Friend *)frd{
    CompletionWeb addImageCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error) {
        UIImage *image = [UIImage imageWithData:postData];
        if (image){
            frd.image = image;
            NSLog(@"adding image");
            [self reloadCollectionDataAsync];
        }
    };
    
    return addImageCompletion;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.friendAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIFriendCollectionViewCell *cell = (UIFriendCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"friendCell" forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[UIFriendCollectionViewCell alloc]init];
    }
    
    
    Friend *friend = [self.friendAry objectAtIndex:indexPath.row];
    
    if (friend.image != nil)
        cell.imageView.image = friend.image;
    
    cell.mutualLabel.text = [NSString stringWithFormat:@"%d mutual",[friend.mutualFriends intValue]];
    cell.nameLabel.text = friend.username;
        
    // Configure the cell
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //CGFloat width = (self.view.frame.size.width / 2) - 12;
    //CGFloat height = width + 20;
    int paddingSpace = insets.left * (itemsPerRow + 3);
    int availableWidth = self.view.frame.size.width - paddingSpace;
    int widthPerItem = availableWidth / itemsPerRow;
    

    return CGSizeMake(widthPerItem, widthPerItem + 20);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return insets;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *) collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return insets.left;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    Friend *frd = [self.friendAry objectAtIndex:indexPath.row];
    id sender = frd;
    [self performSegueWithIdentifier:@"ProfileTableViewController" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ProfileTableViewController"]){
        ProfileTableViewController *controller = (ProfileTableViewController *)segue.destinationViewController;
        controller.frd = (Friend *)sender;
        
    }

}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

