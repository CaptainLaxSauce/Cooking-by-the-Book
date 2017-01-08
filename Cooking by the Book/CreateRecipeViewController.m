//
//  CreateRecipeViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "TabBarControllerDelegate.h"
#import "CreateRecipeViewController.h"
#import "UIColor+CustomColors.h"
#import "UICreateIngredientCell.h"
#import "UICreateStepCell.h"
#import "Helper.h"
#import "DataClass.h"
#import "Recipe.h"

@implementation CreateRecipeViewController

static int objectBreak = 8;
static int cornerRadius = 3;
int objectWidth;
int textHeight;
int titleHeight;
int timeHeight;
int portionsHeight;
int ingredientHeight;
int imageViewHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
}

-(void)timeFieldChanged{
    self.totTime = [self.prepTimeField.text intValue] + [self.cookTimeField.text intValue];
    self.totTimeLabel.text = [NSString stringWithFormat:@"Total: %d minutes",self.totTime];
}

-(void)submitRecipeTouch:(id)sender{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview: activityView];
    activityView.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [activityView startAnimating];
    self.view.userInteractionEnabled = FALSE;
    self.navigationController.view.userInteractionEnabled = FALSE;
    self.tabBarController.view.userInteractionEnabled = FALSE;

     
    //create dictionary of objects to send
    NSLog(@"ingredientAry = %@",self.ingredientAry);
    NSLog(@"stepAry = %@",self.stepAry);
    
    NSMutableArray *ingredientAryJson = [[NSMutableArray alloc]init];
    for (int i = 1; i<=self.ingredientAry.count; i++){
        NSMutableDictionary *ingredientDictJson = [[NSMutableDictionary alloc]init];
        UICreateIngredientCell *tempIngredient = [self.ingredientAry objectAtIndex:i-1];
        [ingredientDictJson setObject:tempIngredient.titleTextField.text forKey:@"ingredientID"]; //Need to change this to do discrete lookup
        [ingredientDictJson setObject:tempIngredient.unitTextField.text forKey:@"ingredientUnitID"];
        [ingredientDictJson setObject:tempIngredient.quantityTextField.text forKey:@"ingredientUnitQuantity"];
        [ingredientAryJson addObject:ingredientDictJson];
    }
    
    NSMutableArray *stepAryJson = [[NSMutableArray alloc]init];
    for (int i = 1; i<=self.stepAry.count; i++){
        NSMutableDictionary *stepDictJson = [[NSMutableDictionary alloc]init];
        UICreateStepCell *tempStep = [self.stepAry objectAtIndex:i-1];
        [stepDictJson setObject:tempStep.textField.text forKey:@"stepDescription"];
        [stepAryJson addObject:stepDictJson];
        }
    
    NSMutableArray *tagAryJson = [[NSMutableArray alloc]init]; //there's probably a more elegant way to do this
    NSMutableArray *tagAry = [[NSMutableArray alloc]init];
    if (self.quickTag.tagged == TRUE){
        [tagAryJson addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"tagID", nil]];
        [tagAry addObject:[NSNumber numberWithInteger:0]];
    }
    if (self.simpleTag.tagged == TRUE){
        [tagAryJson addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"tagID", nil]];
        [tagAry addObject:[NSNumber numberWithInteger:1]];
    }
    if (self.vegetarianTag.tagged == TRUE){
        [tagAryJson addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"tagID", nil]];
        [tagAry addObject:[NSNumber numberWithInteger:2]];
    }
    if (self.veganTag.tagged == TRUE){
        [tagAryJson addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"3",@"tagID", nil]];
        [tagAry addObject:[NSNumber numberWithInteger:3]];
    }
    
    NSMutableDictionary* recipeDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.titleTextField.text,@"recipeTitle",
                                       self.descTextField.text,@"recipeDescription",
                                       self.portionNumLabel.text,@"recipePortionQuantity",
                                       self.prepTimeField.text,@"recipePrepTime",
                                       self.cookTimeField.text,@"recipeCookTime",
                                       [NSString stringWithFormat:@"%d",self.totTime],@"recipeTotalTime",
                                       ingredientAryJson,@"recipeIngredients",
                                       stepAryJson,@"recipeSteps",
                                       tagAryJson,@"recipeTags",
                                       nil];
    
    DataClass *obj = [DataClass getInstance];
    
    NSLog(@"userID in create recipe = %@",obj.userId);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:recipeDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [NSString stringWithFormat:@"userID=%@&recipeID=%@",obj.userId,jsonStr];
    NSLog(@"jsonStr = %@",jsonStr);
    NSData *postData = [jsonStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [Helper setupPost:postData withURLEnd:@"createRecipe"];
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [activityView stopAnimating];
            self.view.userInteractionEnabled = TRUE;
            self.navigationController.view.userInteractionEnabled = TRUE;
            self.tabBarController.view.userInteractionEnabled = TRUE;
        });
        
        NSString *recipeID = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        [self uploadImage:recipeID];
        
        
        NSLog(@"ret = %@",recipeID);
        NSLog(@"response = %@",response);
        if ([recipeID intValue] > 0) {
            NSLog(@"Successful recipe post, id = %@",recipeID);
            //fix this to send images
            Recipe *newRecipe = [[Recipe alloc]initDetailedWithTitle:self.titleTextField.text withID:recipeID withDesc:self.descTextField.text withImageName:nil withTagAry:tagAry withPrepTime:(NSNumber*)self.prepTimeField.text withCookTime:(NSNumber*)self.cookTimeField.text withTotTime:[NSNumber numberWithInt:self.totTime] withPortionNum:(NSNumber*)self.portionNumLabel.text withIngredientAry:ingredientAryJson withStepAry:stepAryJson withImage:[self.recipeImageView image]];
            [obj addRecipe:newRecipe];
            
            NSString *post2 = [NSString stringWithFormat:@"userID=%@&recipeID=%@",obj.userId,recipeID];
            NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSMutableURLRequest *request2 = [Helper setupPost:postData2 withURLEnd:@"addCookbookRecipe"];
            NSURLSession *session2 = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask2 = [session2 dataTaskWithRequest:request2 completionHandler:^(NSData *postData2, NSURLResponse *response2, NSError *error2) {
                
                NSString *ret2 = [[NSString alloc] initWithData:postData2 encoding:NSUTF8StringEncoding];
                NSLog(@"ret2 (recipe successfully added to cookbook) = %@",ret2);
                
                
            }];
            [dataTask2 resume];

            
            dispatch_async(dispatch_get_main_queue(), ^(void){
            
           [[self navigationController] popViewControllerAnimated:YES];
                });
            }
        else{
            NSLog(@"Recipe post failed");
                //Include discrete error reasons
            dispatch_async(dispatch_get_main_queue(), ^(void){
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Recipe Submission Failed"
                                            message:[NSString stringWithFormat:@"%@\r%@",@"The recipe could not be submitted.",@"Please try again."]
                                            preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }];
    
    [dataTask resume];
    
    
}

-(void)uploadImage:(NSString *)recipeID{
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@"1.0" forKey:@"ver"];
    [_params setObject:@"en" forKey:@"lan"];
    //[_params setObject:[NSString stringWithFormat:@"%d", userId] forKey:@"userId"];
    //[_params setObject:[NSString stringWithFormat:@"%@",title] forKey:[NSString stringWithString:@"title"]];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----WebKitFormBoundaryEPRzw3WzbhDJRoYn"];
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"image";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:@"http://75.135.74.26:8080/addImageToRecipe.php"];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation([self.recipeImageView image], 1.0);
    if (imageData) {
        NSLog(@"image data contains something");
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"recipeID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", recipeID] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *dataString = [[NSString alloc]initWithData:body encoding:NSUTF8StringEncoding];
    NSLog(@"dataString = %@",dataString);
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *postData, NSURLResponse *response, NSError *error) {
        NSString *ret = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"the image return is!!!: %@",ret);
    }];
    [dataTask resume];
    
    NSLog(@"image send attempted");
    NSLog(@"postLength = %@",postLength);

}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)stepperValueChange:(id)sender{
    self.portionNumLabel.text = [NSString stringWithFormat:@"%d",(int)self.portionStepper.value];
}

-(void)addIngredientTouch{
    UICreateIngredientCell *ingredient = [[UICreateIngredientCell alloc]initWithFrame:self.addIngredientButton.frame withDelBtn:YES];
    self.ingredientIdx = self.ingredientIdx+1;
    [ingredient.delButton addTarget:self action:@selector(delIngredientTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.moveAry insertObject:ingredient atIndex:self.ingredientIdx];
    [self shiftObjectsDown:self.ingredientIdx];
    [self.recipeScrollView addSubview:ingredient];
    [self.ingredientAry addObject:ingredient];
}

-(void)delIngredientTouch:(id)sender{
    UIButton *tempButton = [sender self];
    NSInteger index = [self.moveAry indexOfObject:tempButton.superview];
    [self.moveAry removeObjectAtIndex:index];
    [self shiftObjectsUp:index];
    [self.ingredientAry removeObject:tempButton.superview];
    self.ingredientIdx = self.ingredientIdx-1;
}

-(void)addStepTouch{
    UICreateStepCell *step = [[UICreateStepCell alloc]initWithFrame:self.addStepButton.frame withNumber:self.stepAry.count+1 withDelBtn:TRUE];
    [step.delButton addTarget:self action:@selector(delStepTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger moveIndex = self.ingredientIdx+self.stepAry.count+4;
    [self.moveAry insertObject:step atIndex:moveIndex];
    [self shiftObjectsDown:moveIndex];
    [self.recipeScrollView addSubview:step];
    [self.stepAry addObject:step];
}

-(void)delStepTouch:(id)sender{
    UIButton *tempButton = [sender self];
    NSInteger moveIndex = [self.moveAry indexOfObject:tempButton.superview];
    [self.moveAry removeObjectAtIndex:moveIndex];
    [self shiftObjectsUp:moveIndex];

    NSInteger stepIndex = [self.stepAry indexOfObject:tempButton.superview];
    [self.stepAry removeObjectAtIndex:stepIndex];
    
    for (NSInteger i = stepIndex-1;i<self.stepAry.count;i++){
        UICreateStepCell *tempStepCell = [self.stepAry objectAtIndex:i];
        [tempStepCell updateNum:i+1];
    }
}

-(void)shiftObjectsUp:(NSInteger)index{
    
    for (NSInteger i=index; i<self.moveAry.count;i++){
        UIView *currView = [self.moveAry objectAtIndex:i];
        currView.frame = CGRectMake(currView.frame.origin.x, currView.frame.origin.y - textHeight - objectBreak, currView.frame.size.width, currView.frame.size.height);
    }
    [self.recipeScrollView setContentSize:CGSizeMake(self.view.frame.size.width,self.recipeScrollView.contentSize.height - textHeight - objectBreak)];
}

-(void)shiftObjectsDown:(NSInteger)index{
    for (NSInteger i=self.moveAry.count-1; i>index;i--){
        UIView *currView = [self.moveAry objectAtIndex:i];
        currView.frame = CGRectMake(currView.frame.origin.x, currView.frame.origin.y + textHeight + objectBreak, currView.frame.size.width, currView.frame.size.height);
        
        //shift down in moveAry
        [self.moveAry insertObject:[self.moveAry objectAtIndex:i] atIndex:i+1];
        [self.moveAry removeObjectAtIndex:i];
    }
    [self.recipeScrollView setContentSize:CGSizeMake(self.view.frame.size.width,self.recipeScrollView.contentSize.height + textHeight + objectBreak)];
}

-(void)imageTouch:(id)sender{
    NSLog(@"Image Touch");
    
    //[self performSegueWithIdentifier:@"ImagePickerViewController" sender:sender];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)cameraTouch:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.recipeImageView.image = chosenImage;
    self.recipeImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)loadInterface {
    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    objectWidth = screenWidth - objectBreak*2;
    textHeight = screenHeight/20;
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    int navBarHeight = self.navigationController.navigationBar.frame.size.height;
    int stepperWidth = 94;
    int tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    int scrollHeight = screenHeight-statusBarHeight-navBarHeight-textHeight-objectBreak*2-tabBarHeight;
    int labelWidth = (screenWidth-objectBreak*2)/10;
    int tagWidth = (screenWidth-objectBreak*3)/2;
    
    titleHeight = objectBreak*3+textHeight*2;
    timeHeight = objectBreak*2+textHeight;
    portionsHeight = objectBreak*2+textHeight+titleHeight+timeHeight;
    ingredientHeight = textHeight*3+objectBreak*4;
    imageViewHeight = screenWidth+textHeight;
    
    self.view.backgroundColor = [UIColor primaryColor];
    self.navigationItem.title = @"Create Recipe";
    
    //add non-viewable objects
    NSMutableArray *moveAry_ = [[NSMutableArray alloc]init];
    NSMutableArray *ingredientAry_ = [[NSMutableArray alloc]init];
    NSMutableArray *stepAry_ = [[NSMutableArray alloc]init];
    
    //add scroll view
    UIScrollView *recipeScrollView_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight+navBarHeight, screenWidth, scrollHeight)];
    recipeScrollView_.backgroundColor = [UIColor customGrayColor];
    recipeScrollView_.contentSize = CGSizeMake(screenWidth, titleHeight+timeHeight+portionsHeight+ingredientHeight*2+imageViewHeight);
    recipeScrollView_.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:recipeScrollView_];
    self.recipeScrollView = recipeScrollView_;
    
    //add title and description
    UITextField *titleTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, objectBreak, objectWidth, textHeight)];
    titleTextField_.placeholder = @"Title";
    titleTextField_.backgroundColor = [UIColor whiteColor];
    titleTextField_.layer.cornerRadius = cornerRadius;
    titleTextField_.clipsToBounds = YES;
    [self.recipeScrollView addSubview:titleTextField_];
    self.titleTextField = titleTextField_;
    
    UITextField *descTextField_ = [[UITextField alloc]initWithFrame:CGRectMake(objectBreak, objectBreak*2 + textHeight, objectWidth, textHeight)];
    descTextField_.placeholder = @"Description (optional)";
    descTextField_.backgroundColor = [UIColor whiteColor];
    descTextField_.backgroundColor = [UIColor whiteColor];
    descTextField_.layer.cornerRadius = cornerRadius;
    [self.recipeScrollView addSubview:descTextField_];
    self.descTextField = descTextField_;
    
    UIView *titleLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, titleHeight, objectWidth, 1)];
    titleLine_.backgroundColor = [UIColor lineColor];
    [self.recipeScrollView addSubview:titleLine_];
    
    //add times
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, titleHeight+objectBreak, labelWidth*1.6, textHeight)];
    timeLabel.text = @"Time";
    [self.recipeScrollView addSubview:timeLabel];
    
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(objectBreak+labelWidth*1.6, titleHeight+objectBreak, labelWidth*4, textHeight)];
    timeView.backgroundColor = [UIColor whiteColor];
    timeView.layer.cornerRadius = cornerRadius;
    timeView.clipsToBounds = YES;
    [self.recipeScrollView addSubview:timeView];
    
    UITextField *prepTimeField_ = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, timeView.frame.size.width/2, timeView.frame.size.height)];
    prepTimeField_.placeholder = @"Prep";
    [prepTimeField_ addTarget:self action:@selector(timeFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [prepTimeField_ setKeyboardType:UIKeyboardTypeNumberPad];
    [timeView addSubview:prepTimeField_];
    self.prepTimeField = prepTimeField_;
    
    UITextField *cookTimeField_ = [[UITextField alloc]initWithFrame:CGRectMake(timeView.frame.size.width/2, 0, timeView.frame.size.width/2, timeView.frame.size.height)];
    cookTimeField_.placeholder = @"Cook";
    [cookTimeField_ addTarget:self action:@selector(timeFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [cookTimeField_ setKeyboardType:UIKeyboardTypeNumberPad];
    [timeView addSubview:cookTimeField_];
    self.cookTimeField = cookTimeField_;
    
    UILabel *totTimeLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak*2+labelWidth*6, titleHeight+objectBreak, labelWidth*5, textHeight)];
    totTimeLabel_.text = @"Total: 0 minutes";
    [self.recipeScrollView addSubview:totTimeLabel_];
    self.totTimeLabel = totTimeLabel_;
    
    UIView *timeLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, titleHeight+objectBreak*2+textHeight, objectWidth, 1)];
    timeLine_.backgroundColor = [UIColor lineColor];
    [self.recipeScrollView addSubview:timeLine_];
    
    //add portions
    UIStepper *portionStepper_ = [[UIStepper alloc]initWithFrame:CGRectMake(screenWidth-objectBreak-stepperWidth, objectBreak+titleHeight+timeHeight+2, 0, 0)];
    portionStepper_.minimumValue = 1;
    portionStepper_.value = 4;
    [portionStepper_ addTarget:self action:@selector(stepperValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.recipeScrollView addSubview:portionStepper_];
    self.portionStepper = portionStepper_;
    
    UILabel *portionNumLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-objectBreak*2-stepperWidth-labelWidth, objectBreak+titleHeight+timeHeight, labelWidth, textHeight)];
    portionNumLabel_.text = [NSString stringWithFormat:@"%d",(int)self.portionStepper.value];
    [self.recipeScrollView addSubview:portionNumLabel_];
    self.portionNumLabel = portionNumLabel_;
    
    UILabel *portionLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, objectBreak+titleHeight+timeHeight, labelWidth*4, textHeight)];
    portionLabel_.text = @"Portions";
    [self.recipeScrollView addSubview:portionLabel_];
    
    UIView *portionLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight, objectWidth, 1)];
    portionLine_.backgroundColor = [UIColor lineColor];
    [self.recipeScrollView addSubview:portionLine_];
    
    //add ingredients
    UILabel *ingredientLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+objectBreak, labelWidth*4, textHeight)];
    ingredientLabel_.text = @"Ingredients";
    [self.recipeScrollView addSubview:ingredientLabel_];
    
    UICreateIngredientCell *ingredient_ = [[UICreateIngredientCell alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+objectBreak*2+textHeight, objectWidth, textHeight) withDelBtn:FALSE];
    [self.recipeScrollView addSubview:ingredient_];
    [ingredientAry_ addObject:ingredient_];
    [moveAry_ addObject:ingredient_];
    
    UIButton *addIngredientButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+objectBreak*3+textHeight*2, objectWidth, textHeight)];
    [addIngredientButton_ addTarget:self action:@selector(addIngredientTouch) forControlEvents:UIControlEventTouchUpInside];
    [addIngredientButton_ setTitle:@"Add Ingredient" forState:UIControlStateNormal];
    addIngredientButton_.backgroundColor = [UIColor secondaryColor];
    addIngredientButton_.layer.cornerRadius = cornerRadius;
    addIngredientButton_.clipsToBounds = YES;
    [self.recipeScrollView addSubview:addIngredientButton_];
    self.addIngredientButton = addIngredientButton_;
    [moveAry_ addObject:addIngredientButton_];
    
    UIView *ingredientLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight, objectWidth, 1)];
    ingredientLine_.backgroundColor = [UIColor lineColor];
    [self.recipeScrollView addSubview:ingredientLine_];
    [moveAry_ addObject:ingredientLine_];
    self.ingredientIdx=0;
    
    //add steps
    UILabel *stepLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight+objectBreak, objectWidth, textHeight)];
    stepLabel_.text = @"Steps";
    [self.recipeScrollView addSubview:stepLabel_];
    [moveAry_ addObject:stepLabel_];
    
    UICreateStepCell *step_ = [[UICreateStepCell alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight+objectBreak*2+textHeight, objectWidth, textHeight) withNumber:1 withDelBtn:FALSE];
    [self.recipeScrollView addSubview:step_];
    [stepAry_ addObject:step_];
    [moveAry_ addObject:step_];
    
    UIButton *addStepButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight+objectBreak*3+textHeight*2, objectWidth, textHeight)];
    [addStepButton_ addTarget:self action:@selector(addStepTouch) forControlEvents:UIControlEventTouchUpInside];
    [addStepButton_ setTitle:@"Add Step" forState:UIControlStateNormal];
    addStepButton_.backgroundColor = [UIColor secondaryColor];
    addStepButton_.layer.cornerRadius = cornerRadius;
    addStepButton_.clipsToBounds = YES;
    [self.recipeScrollView addSubview:addStepButton_];
    self.addStepButton = addStepButton_;
    [moveAry_ addObject:addStepButton_];
    
    UIView *stepLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight+objectBreak*4+textHeight*3, objectWidth, 1)];
    stepLine_.backgroundColor = [UIColor lineColor];
    [self.recipeScrollView addSubview:stepLine_];
    [moveAry_ addObject:stepLine_];
    
    //add tags
    UILabel *tagLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight*2+objectBreak, objectWidth, textHeight)];
    tagLabel_.text = @"Tags";
    [self.recipeScrollView addSubview:tagLabel_];
    [moveAry_ addObject:tagLabel_];
    
    UIToggleTagButton *quickTag_ = [[UIToggleTagButton alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight*2+objectBreak*2+textHeight, tagWidth, textHeight) withTagType:0 withTagged:FALSE];
    [self.recipeScrollView addSubview:quickTag_];
    [moveAry_ addObject:quickTag_];
    self.quickTag = quickTag_;
    
    UIToggleTagButton *simpleTag_ = [[UIToggleTagButton alloc]initWithFrame:CGRectMake(objectBreak*2+tagWidth, portionsHeight+ingredientHeight*2+objectBreak*2+textHeight, tagWidth, textHeight) withTagType:1 withTagged:FALSE];
    [self.recipeScrollView addSubview:simpleTag_];
    [moveAry_ addObject:simpleTag_];
    self.simpleTag = simpleTag_;
    
    UIToggleTagButton *vegetarianTag_ = [[UIToggleTagButton alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight*2+objectBreak*3+textHeight*2, tagWidth, textHeight) withTagType:2 withTagged:FALSE];
    [self.recipeScrollView addSubview:vegetarianTag_];
    [moveAry_ addObject:vegetarianTag_];
    self.vegetarianTag = vegetarianTag_;
    
    UIToggleTagButton *veganTag_ = [[UIToggleTagButton alloc]initWithFrame:CGRectMake(objectBreak*2+tagWidth, portionsHeight+ingredientHeight*2+objectBreak*3+textHeight*2, tagWidth, textHeight) withTagType:3 withTagged:FALSE];
    [self.recipeScrollView addSubview:veganTag_];
    [moveAry_ addObject:veganTag_];
    self.veganTag = veganTag_;
    
    //add imageSelectView
    UIView *imageLine_ = [[UIView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight*2+objectBreak*4+textHeight*3,screenWidth - objectBreak*2, 1)];
    imageLine_.backgroundColor = [UIColor lineColor];
    [self.recipeScrollView addSubview:imageLine_];
    [moveAry_ addObject:imageLine_];
    
    UILabel *imageLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight*2+objectBreak*5+textHeight*3,objectWidth, textHeight)];
    imageLabel_.text = @"Image";
    [self.recipeScrollView addSubview:imageLabel_];
    [moveAry_ addObject:imageLabel_];
    
    UIImageView *imageSelectView = [[UIImageView alloc]initWithFrame:CGRectMake(objectBreak, portionsHeight+ingredientHeight*2+objectBreak*6+textHeight*4, screenWidth - objectBreak*2, screenWidth - objectBreak*2)];
    [imageSelectView setImage:[UIImage imageNamed:@"addimage.png"]];
    imageSelectView.contentMode = UIViewContentModeCenter;
    imageSelectView.userInteractionEnabled = YES;
    [[imageSelectView layer] setBorderWidth:2.0];
    [[imageSelectView layer] setBorderColor:[UIColor blackColor].CGColor];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTouch:)];
    [imageSelectView addGestureRecognizer:imageTap];
    [self.recipeScrollView addSubview:imageSelectView];
    
    UIImageView *cameraImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageSelectView.frame.size.width - imageSelectView.frame.size.width/8 - 5, 0, imageSelectView.frame.size.width/8, imageSelectView.frame.size.width/8)];
    [cameraImageView setImage:[UIImage imageNamed:@"cameraicon.png"]];
    cameraImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *cameraTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraTouch:)];
    [cameraImageView addGestureRecognizer:cameraTap];
    [imageSelectView addSubview:cameraImageView];
    
    self.recipeImageView = imageSelectView;
    [moveAry_ addObject:imageSelectView];
    
    //assign arrays to properties
    self.ingredientAry = ingredientAry_;
    self.stepAry = stepAry_;
    self.moveAry = moveAry_;
    NSLog(@"end of loadInterface stepAry cnt = %lu",(unsigned long)self.stepAry.count);
    
    //add buttons
    UIButton *submitRecipeButton_ = [[UIButton alloc]initWithFrame:CGRectMake(objectBreak , screenHeight-objectBreak-textHeight-tabBarHeight, objectWidth, textHeight)];
    [submitRecipeButton_ addTarget:self action:@selector(submitRecipeTouch:) forControlEvents:UIControlEventTouchUpInside];
    [submitRecipeButton_ setTitle:@"Submit Recipe" forState:UIControlStateNormal];
    [submitRecipeButton_ setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    //[createRecipeButton_ setBackgroundImage:[UIImage imageNamed:@"app_logo.png"] forState: UIControlStateHighlighted];
    //[createRecipeButton_ setBackgroundImage:[UIImage imageNamed:@"app_logo.png"] forState: UIControlStateSelected];
    submitRecipeButton_.backgroundColor = [UIColor secondaryColor];
    submitRecipeButton_.layer.cornerRadius = cornerRadius;
    submitRecipeButton_.clipsToBounds = YES;
    [self.view addSubview:submitRecipeButton_];
    self.submitRecipeButton = submitRecipeButton_;

}

@end
