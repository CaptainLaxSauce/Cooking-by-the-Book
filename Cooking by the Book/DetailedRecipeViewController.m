//
//  DetailedRecipeViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 8/10/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "DetailedRecipeViewController.h"
#import "CreatePostViewController.h"
#import "DataClass.h"
#import "Helper.h"
#import "UIColor+CustomColors.h"
#import "UITagBox.h"
#import "Constants.h"


@interface DetailedRecipeViewController ()

@end

@implementation DetailedRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"CreatePostViewController"]){
        CreatePostViewController *controller = (CreatePostViewController *)segue.destinationViewController;
        controller.recipeID = self.recipeID;
    }
}

-(void)cookedButtonTouch:(id)sender{
    [self performSegueWithIdentifier:@"CreatePostViewController" sender:sender];
}


-(void)loadInterface{
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    int objectWidth = screenWidth - OBJECT_BREAK*2;
    int tagBoxHeight = (objectWidth/2-OBJECT_BREAK*2)*3/5;
    int textHeight = screenHeight/20;
    int ingLabelStart = OBJECT_BREAK*6 + objectWidth/2 + textHeight*3;
    
    UIScrollView *scrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    scrollView_.backgroundColor = [UIColor customGrayColor];
    self.scrollView = scrollView_;
    [self.view addSubview:scrollView_];
    
    UIImageView *recipeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(OBJECT_BREAK, OBJECT_BREAK, (objectWidth-OBJECT_BREAK)/2, objectWidth/2)];
    recipeImageView.image = [UIImage imageNamed:@"recipedefault.png"];
    [self.scrollView addSubview:recipeImageView];
    
    UITagBox *tagBox = [[UITagBox alloc]initWithFrame:CGRectMake(OBJECT_BREAK*2+objectWidth/2, OBJECT_BREAK, tagBoxHeight, tagBoxHeight)];
    [self.scrollView addSubview:tagBox];

    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(OBJECT_BREAK*2+objectWidth/2, OBJECT_BREAK*2 + tagBoxHeight, (objectWidth-OBJECT_BREAK)/2, tagBoxHeight/3)];
    [self.scrollView addSubview:timeLabel];
    
    UILabel *portionLabel = [[UILabel alloc]initWithFrame:CGRectMake(OBJECT_BREAK*2+objectWidth/2, OBJECT_BREAK*3 + tagBoxHeight + textHeight, (objectWidth-OBJECT_BREAK)/2, tagBoxHeight/3)];
    [self.scrollView addSubview:portionLabel];
    
    UIView *timePortionLine = [[UIView alloc]initWithFrame:CGRectMake(OBJECT_BREAK, OBJECT_BREAK*2 + objectWidth/2, objectWidth - OBJECT_BREAK*2, 1)];
    timePortionLine.backgroundColor = [UIColor lineColor];
    [self.scrollView addSubview:timePortionLine];
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(OBJECT_BREAK, OBJECT_BREAK*3 + objectWidth/2, objectWidth, textHeight*2)];
    descLabel.adjustsFontSizeToFitWidth = TRUE;
    [self.scrollView addSubview:descLabel];
    
    UIView *descLine = [[UIView alloc]initWithFrame:CGRectMake(OBJECT_BREAK, OBJECT_BREAK*4 + objectWidth/2 + textHeight*2, objectWidth, 1)];
    descLine.backgroundColor = [UIColor lineColor];
    [self.scrollView addSubview:descLine];

    
    UILabel *ingredientsLabel = [[UILabel alloc]initWithFrame:CGRectMake(OBJECT_BREAK, OBJECT_BREAK*5 + objectWidth/2 + textHeight*2, objectWidth/2, textHeight)];
    [ingredientsLabel setText:@"Ingredients"];
    [self.scrollView addSubview:ingredientsLabel];
    
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Cooked!" style:UIBarButtonItemStylePlain target:self action:@selector(cookedButtonTouch:)];
    self.navigationItem.rightBarButtonItem = createButton;
    
    DataClass *obj = [DataClass getInstance];
    if (self.recipe == nil){
        self.recipe = [obj getRecipeFromCookbook:self.recipeID];
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.recipe.title];
    NSString *post = [NSString stringWithFormat:@"userID=%@&recipeID=%@",obj.userId,self.recipeID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"getRecipe"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSString *ret_ = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"ret = %@",ret_);
        
        NSDictionary *recipeDict = [NSJSONSerialization JSONObjectWithData:postData options:kNilOptions error:&error];
        NSDictionary *recipeInfoDict = [recipeDict objectForKey:@"recipeInfo"];
        NSArray *ingredientAry = [recipeDict objectForKey:@"ingredientInfo"];
        NSArray *tagAry = [recipeDict objectForKey:@"tagInfo"];
        NSArray *stepAry = [recipeDict objectForKey:@"stepInfo"];
        
        
        for (int i=0;i<stepAry.count;i++){
            //UILabel *stpLabel
        }
        
        NSMutableArray *tagNumAry = [[NSMutableArray alloc]init];
        for (int ii=0;ii<tagAry.count;ii++){
            NSDictionary *tagDict = [tagAry objectAtIndex:ii];
            if ([tagDict objectForKey:@"tagID"] != (id)[NSNull null]){
                [tagNumAry addObject:[tagDict objectForKey:@"tagID"]];
                NSLog(@"tagID = %@",[tagDict objectForKey:@"tagID"]);
                NSLog(@"tagAry count inside ii loop = %lu",(unsigned long)tagAry.count);
            }

        }

        
        //Fill in everything
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            //add Ingredients
            int ingredientHeight = 0;
            for (int i=0;i<ingredientAry.count;i++){
                UILabel *ingLabel = [[UILabel alloc]init];
                if (i%2 == 0){
                    [ingLabel setFrame:CGRectMake(OBJECT_BREAK, ingLabelStart + textHeight*(i/2) + OBJECT_BREAK*(i/2), (objectWidth-OBJECT_BREAK)/2, textHeight)];
                    ingredientHeight = ingredientHeight + textHeight + OBJECT_BREAK;
                }
                else{
                    [ingLabel setFrame:CGRectMake(OBJECT_BREAK*2 +objectWidth/2 , ingLabelStart + textHeight*(i-1)/2 + OBJECT_BREAK*(i-1)/2, (objectWidth-OBJECT_BREAK)/2, textHeight)];
                }
                NSDictionary *ingredientDict = [ingredientAry objectAtIndex:i];
                NSString *unitName = [ingredientDict objectForKey:@"unitName"];
                NSString *unitQuantity = [ingredientDict objectForKey:@"unitQuantity"];
                NSString *ingredientName = [ingredientDict objectForKey:@"title"];
                ingLabel.text = [NSString stringWithFormat:@"%@ %@ %@", unitQuantity, unitName, ingredientName];
                ingLabel.backgroundColor = [UIColor whiteColor];
                ingLabel.layer.cornerRadius = CORNER_RADIUS;
                ingLabel.clipsToBounds = YES;
                NSLog(@"ingredient array components %@ %@ %@", unitQuantity, unitName, ingredientName);
                [self.scrollView addSubview:ingLabel];
            }
            
            UIView *ingLine = [[UIView alloc]initWithFrame:CGRectMake(OBJECT_BREAK, ingLabelStart + ingredientHeight, objectWidth, 1)];
            ingLine.backgroundColor = [UIColor lineColor];
            [self.scrollView addSubview:ingLine];
            
            UILabel *stepsLabel = [[UILabel alloc]initWithFrame:CGRectMake(OBJECT_BREAK, ingLabelStart + ingredientHeight + OBJECT_BREAK, objectWidth, textHeight)];
            stepsLabel.text = [NSString stringWithFormat:@"Steps"];
            [self.scrollView addSubview:stepsLabel];

            for(int i=0;i<stepAry.count;i++){
                UILabel *stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(OBJECT_BREAK, ingLabelStart + ingredientHeight + textHeight + OBJECT_BREAK*2 + OBJECT_BREAK*i + textHeight*i, objectWidth, textHeight)];
                NSDictionary *stepDict = [stepAry objectAtIndex:i];
                NSString *stepDesc = [stepDict objectForKey:@"stepDescription"];
                stepLabel.backgroundColor = [UIColor whiteColor];
                stepLabel.layer.cornerRadius = CORNER_RADIUS;
                stepLabel.clipsToBounds = YES;
                stepLabel.adjustsFontSizeToFitWidth = TRUE;
                stepLabel.text = [NSString stringWithFormat:@"%d) %@", i+1, stepDesc];
                [self.scrollView addSubview:stepLabel];
            }
            

            
            //resize scrollview to fit contents
            CGRect contentRect = CGRectZero;
            for (UIView *view in self.scrollView.subviews) {
                contentRect = CGRectUnion(contentRect, view.frame);
            }
            contentRect.size.height = contentRect.size.height + OBJECT_BREAK;
            self.scrollView.contentSize = contentRect.size;
            
            timeLabel.text = [NSString stringWithFormat:@"Prep: %@  Cook: %@",[recipeInfoDict objectForKey:@"recipeTimePrep"],[recipeInfoDict objectForKey:@"recipeTimeCook"]];
            portionLabel.text = [NSString stringWithFormat:@"Portions: %@",[recipeInfoDict objectForKey:@"recipePortions"]];
            descLabel.text = [NSString stringWithFormat:@"%@",[recipeInfoDict objectForKey:@"recipeDescription"]];
            [tagBox addTags:tagNumAry];
            if (self.recipe.image != nil){
                [recipeImageView setImage:self.recipe.image];
            }
            else if (![self.recipe.imageName  isEqual: @""]) {
                void (^addImageCompletion)(NSData *postData, NSURLResponse *response, NSError *error);
                addImageCompletion = ^(NSData *postData, NSURLResponse *response, NSError *error){
                    self.recipe.image = [UIImage imageWithData:postData];
                    NSLog(@"adding image with imagename = %@",self.recipe.imageName);
                    if (self.recipe.image) {
                        [recipeImageView setImage:self.recipe.image];
                    }
                };
                
                [Helper getImageWithName:self.recipe.imageName withCompletion:addImageCompletion];
            }
        });
    }];
    [dataTask resume];
    
}

@end
