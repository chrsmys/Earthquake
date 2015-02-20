//
//  ViewController.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

//determines whether Master is displayed in compact enviornment
@property (nonatomic) BOOL collapseSecondaryViewOnPrimary;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    
    self.splitViewController.delegate=self;
    [self setCollapseSecondaryViewOnPrimary:true];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma MARK - SplitViewControllerDelegate

-(BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController{
    return self.collapseSecondaryViewOnPrimary;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
