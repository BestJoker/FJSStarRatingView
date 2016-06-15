//
//  RootViewController.m
//  练习
//
//  Created by 付金诗 on 15/12/17.
//  Copyright © 2015年 www.fujinshi.com. All rights reserved.
//

#import "RootViewController.h"
#import "FJSStarRatingView.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FJSStarRatingView * startView = [FJSStarRatingView new];
//    startView.backgroundColor = [UIColor blackColor];
    startView.starScore = ^(CGFloat score)
    {
        self.navigationItem.title = [NSString stringWithFormat:@"%.1f",score];
    };
    [self.view addSubview:startView];
    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.right.equalTo(self.view).with.offset(-40);
        make.top.equalTo(self.view).with.offset(100);
    }];
        
}



- (void)didReceiveMemoryWarning {
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
