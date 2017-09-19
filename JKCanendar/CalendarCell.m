//
//  CalendarCell.m
//  JKCanendar
//
//  Created by Cain on 2017/9/15.
//  Copyright © 2017年 Goldian. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.dateLabel];
        
    }
    return self;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

@end
