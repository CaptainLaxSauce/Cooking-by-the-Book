//
//  DataClass.m
//  Cooking by the Book
//
//  Created by Jack Smith on 6/26/16.
//  Copyright © 2016 EthanJack. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass
@synthesize userId;

static DataClass *instance = nil;

+(DataClass *)getInstance{
    
    @synchronized (self) {
        if (instance == nil)
        {
            instance = [DataClass new];
        }
    }
    return instance;
}

@end
