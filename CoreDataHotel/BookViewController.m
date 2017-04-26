//
//  BookViewController.m
//  CoreDataHotel
//
//  Created by Rio Balderas on 4/25/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

#import "BookViewController.h"
#import "RoomViewController.h"
#import "HotelsViewController.h"
#import "AppDelegate.h"
#import "AutoLayout.h"
#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"


@interface BookViewController ()
@property(strong, nonatomic) UITextField *firstName;
@property(strong, nonatomic) UITextField *lastName;
@property(strong, nonatomic) UITextField *email;

@end

@implementation BookViewController
-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTextFields];
    [self setupLabels];
}

-(void)setupTextFields{
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat textViewHeight = 50;
   
    
    UITextField *firstName = [[UITextField alloc]init];
    [self.view addSubview:firstName];
    firstName.placeholder = @"Type in first name.";
    firstName.backgroundColor = [UIColor grayColor];
    [AutoLayout leadingConstraintFrom: firstName toView: self.view];
    [AutoLayout trailingConstraintFrom: firstName toView: self.view];

    UITextField *lastName = [[UITextField alloc]init];
    [self.view addSubview:lastName];
    lastName.placeholder = @"Type in last name.";
    lastName.backgroundColor = [UIColor grayColor];
    [AutoLayout leadingConstraintFrom: lastName toView: self.view];
    [AutoLayout trailingConstraintFrom: lastName toView: self.view];
    
    UITextField *email = [[UITextField alloc]init];
    [self.view addSubview:email];
    email.placeholder = @"Enter your Email";
    email.backgroundColor = [UIColor grayColor];
    [AutoLayout leadingConstraintFrom: email toView: self.view];
    [AutoLayout trailingConstraintFrom: email toView: self.view];
    
    
    
    NSDictionary *viewDictionary = @{@"firstName": firstName, @"lastName": lastName, @"email": email};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin + 30], @"textViewHeight": [NSNumber numberWithFloat:textViewHeight]};
    NSString *visualFormatString = @"V:|-topMargin-[firstName(==textViewHeight)]-15-[lastName(==textViewHeight)]-15-[email(==textViewHeight)]";
    
    [AutoLayout constraintsWithVFLForViewDictionary: viewDictionary forMetricsDictionary: metricsDictionary withOptions: 0 withVisualFormat: visualFormatString];
   
    
    [firstName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [lastName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [email setTranslatesAutoresizingMaskIntoConstraints:NO];
    
}
-(void)setupLabels{
    UILabel *startDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 300, 200, 30)];
    UILabel *endDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 350, 200, 30)];
    
    endDataLabel.backgroundColor = [UIColor grayColor];
    startDateLabel.backgroundColor = [UIColor grayColor];

    [self.view addSubview:startDateLabel];
    [self.view addSubview:endDataLabel];
    
//    [startDateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [endDataLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm a"];
    startDateLabel.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:self.startDate]];
    endDataLabel.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:self.endDate]];
    
    
    // layout
}

- (void)viewDidLoad {
    [super viewDidLoad];

}




@end