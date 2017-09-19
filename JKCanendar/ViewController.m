//
//  ViewController.m
//  JKCanendar
//
//  Created by Cain on 2017/9/15.
//  Copyright © 2017年 Goldian. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CalendarView *calendarView = [[CalendarView alloc] init];
    calendarView.today = [NSDate date];
    calendarView.date = calendarView.today;
    calendarView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 352);
    [self.view addSubview:calendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
