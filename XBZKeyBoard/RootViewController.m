//
//  RootViewController.m
//  XBZKeyBoard_Demo
//
//  Created by BigKing on 2018/11/1.
//  Copyright © 2018 BigKing. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "TableViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, self.view.width-200.f, 44)];
    [button1 setTitle:@"进入ViewController" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor redColor];
    button1.tag = 100;
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, self.view.width-200.f, 44)];
    [button2 setTitle:@"进入TableViewController" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button2.backgroundColor = [UIColor redColor];
    button2.tag = 200;
    [self.view addSubview:button2];
}

- (void)click:(UIButton *)sender {
    if (sender.tag == 100) {
        
        ViewController *controller = [ViewController new];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else {
        TableViewController *controller = [TableViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
