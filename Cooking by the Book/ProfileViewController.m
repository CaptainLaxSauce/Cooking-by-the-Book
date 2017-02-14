//
//  ProfileViewController.m
//  Cooking by the Book
//
//  Created by Jack Smith on 2/13/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Friend name in PVC = %@",self.frd.username);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
