//
//  CalendarView.m
//  JKCanendar
//
//  Created by Cain on 2017/9/15.
//  Copyright © 2017年 Goldian. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarCell.h"

@interface CalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UILabel *monthLabel;
@property (nonatomic , strong) UIButton *previousButton;
@property (nonatomic , strong) UIButton *nextButton;
@property (nonatomic , strong) NSArray *weekDayArray;
@property (nonatomic , strong) UIView *mask;

@end

@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.monthLabel];
        
        [self addSubview:self.collectionView];
        
        [self addSubview:self.previousButton];
        
        [self addSubview:self.nextButton];
        
    }
    return self;
}

//MARK: -
//MARK: --点击上个月按钮
- (void)previousMonth
{
    [UIView transitionWithView:self.collectionView duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        self.date = [self lastMonthWithDate:self.date];
    } completion:^(BOOL finished) {
    
    }];
}

//MARK: -
//MARK: --点击下个月按钮
- (void)nextMonth
{
    [UIView transitionWithView:self.collectionView duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        self.date = [self nextMonthWIthDate:self.date];
    } completion:^(BOOL finished) {
        
    }];
}

//MARK: -
//MARK: --计算上个月的日期
- (NSDate *)lastMonthWithDate:(NSDate *)date
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:_date options:0];
    return newDate;
}

//MARK: -
//MARK: --计算下个月的日期
- (NSDate *)nextMonthWIthDate:(NSDate *)date
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:_date options:0];
    return newDate;
}

//MARK: -
//MARK: --日期赋值
- (void)setDate:(NSDate *)date
{
    _date = date;
    [_monthLabel setText:[NSString stringWithFormat:@"%.2ld-%li",(long)[self month:date],(long)[self year:date]]];
    [_collectionView reloadData];
}

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

//MARK: -
//MARK: --计算这个月的第一天是星期几
- (NSInteger)firstDayInThisMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [components setDay:1];
    //将时间设置为这个月的1号
    NSDate *firstDayDate = [calendar dateFromComponents:components];
    NSInteger firstDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayDate];
    //星期几
    return firstDay - 1;
}

//MARK: -
//MARK: --计算这个月有多少天
- (NSInteger)totalDaysInMonth:(NSDate *)date
{
    NSRange totalDaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totalDaysInMonth.length;
}

//MARK: -
//MARK: --UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.weekDayArray.count;
    }else{
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CalendarCell class]) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.dateLabel.text = self.weekDayArray[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.dateLabel.text = nil;
        cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        
        NSInteger daysInThisMonth = [self totalDaysInMonth:self.date];
        NSInteger firstWeekday = [self firstDayInThisMonth:self.date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        //上个月最后一周的天数
        if (i < firstWeekday) {
            cell.dateLabel.text = @"";
            //下个月的天数
        }else if (i > firstWeekday + daysInThisMonth - 1){
            cell.dateLabel.text = @"";
        }else{
            //这个月的天数
            day = i - firstWeekday + 1;
            cell.dateLabel.text = [NSString stringWithFormat:@"%ld",day];
        }
    }
    
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.monthLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    
    self.collectionView.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height - 40);
    
    self.previousButton.frame = CGRectMake(0, 0, 100, 40);
    
    self.nextButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 0, 100, 40);
}

- (UIButton *)previousButton
{
    if (!_previousButton) {
        _previousButton = [[UIButton alloc] init];
        [_previousButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previousButton setTitle:@"上个月" forState:UIControlStateNormal];
        [_previousButton addTarget:self action:@selector(previousMonth) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousButton;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton  = [[UIButton alloc] init];
        [_nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nextButton setTitle:@"下个月" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _monthLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 7, [UIScreen mainScreen].bounds.size.height / 7);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:NSStringFromClass([CalendarCell class])];
    
    }
    return _collectionView;
}

- (NSArray *)weekDayArray
{
    if (!_weekDayArray) {
        _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    }
    return _weekDayArray;
}

@end
