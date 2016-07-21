//
//  DataClass.h
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject{

//NSString *userId;

}

@property(nonatomic,retain) NSMutableArray *cookbookAry;
@property(nonatomic,retain) NSString *userId;

+(DataClass*)getInstance;
-(void)initCookbookAry:(NSArray *)jsonCookbookAry_;
-(NSMutableArray *)alphebetizeAry:(NSMutableArray *)theArray withKey:(NSString *)key;

@end
