//
//  DatePickerViewController.m
//  CoreDataHotel
//
//  Created by Rio Balderas on 4/25/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "Reservation+CoreDataProperties.h"
#import "Reservation+CoreDataClass.h"
#import "AppDelegate.h"
#import "AvailabilityViewController.h"
#import "AutoLayout.h"


@interface DatePickerViewController ()

@property(strong, nonatomic) UIDatePicker *endDate;
@property(strong, nonatomic) UIDatePicker *startDate;

@end

@implementation DatePickerViewController

-(void)loadView{
    [super loadView];
    
    [self setupDatePickers];
    [self setupDoneButton];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}
-(void)setupDoneButton{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
}
-(void)doneButtonPressed{
    
    NSDate *endDate = self.endDate.date;
    //this references the current time right NOW
    if ([[NSDate date] timeIntervalSinceReferenceDate] > [endDate timeIntervalSinceReferenceDate]) {
        self.endDate.date = [NSDate date];
        NSLog(@"This date is in the past!");
        return;
    }
//    if ([endDate] < [_startDate date]) {
//        self.startDate.date = [NSDate
//                               date];
//        NSLog(@"This date is in the past!");
//        return;
//    }
    
    AvailabilityViewController *availabilityController = [[AvailabilityViewController alloc]imn,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,nit];
    availabilityController.startDate = [self.startDate date];
    availabilityController.endDate = [self.endDate date];
    
    [self.navigationController pushViewController:availabilityController animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupDatePickers{
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat dateHeight = ((windowHeight - topMargin) / 2);
    
    self.startDate = [[UIDatePicker alloc]init];
    self.startDate.datePickerMode = UIDatePickerModeDateAndTime;
    
    
    //endDate
    self.endDate = [[UIDatePicker alloc]init];
    self.endDate.datePickerMode = UIDatePickerModeDateAndTime;
    [self.view addSubview:self.startDate];
    [self.view addSubview:self.endDate];
    
    NSDictionary *viewDictionary =@{@"startDate": self.startDate, @"endDate": self.endDate};
    NSDictionary *metricsDictionary =@{@"topMargin": [NSNumber numberWithFloat:topMargin], @"dateHeight": [NSNumber numberWithFloat:dateHeight]};
    NSString *visualFormatString = @"V:|-topMargin-[startDate(==dateHeight)][endDate(startDate)]|";
    
    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary forMetricsDictionary:metricsDictionary withOptions:0 withVisualFormat:visualFormatString];
    
    //makes sure to use these constraint defined above
    [self.startDate setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.endDate setTranslatesAutoresizingMaskIntoConstraints:NO];

}

@end
