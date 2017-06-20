//
//  ViewController.m
//  MVPTest
//
//  Created by 李龙 on 2017/6/13.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "ViewController.h"
#import "BlogHomeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)ShowBlogBtnHandler:(id)sender {
    [self.navigationController pushViewController:[BlogHomeView instanceWithUserId:123] animated:YES];

}



@end
