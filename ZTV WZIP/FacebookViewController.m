//
//  FacebookViewController.m
//  ZTV WZIP
//
//  Created by Timothy Transue on 11/3/14.
//  Copyright (c) 2014 University of Akron. All rights reserved.
//

#import "FacebookViewController.h"
//#import <FacebookSDK/FacebookSDK.h>
//#import <Bolts/Bolts.h>
//@import Social;

@interface FacebookViewController ()

@end

@implementation FacebookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURLRequest *socialRequest = [NSURLRequest requestWithURL:self.socialURL];
    [self.facebookWebView loadRequest:socialRequest];
    //self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end