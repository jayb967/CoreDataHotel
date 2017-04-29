//
//  LookUpRerservationController.h
//  CoreDataHotel
//
//  Created by Rio Balderas on 4/26/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room+CoreDataClass.h"
#import "Guest+CoreDataClass.h"

@interface LookUpRerservationController : UIViewController

@property(strong, nonatomic) NSDate *startDate;
@property(strong, nonatomic) NSDate *endDate;

@property(strong, nonatomic) Room *reservedRoom;

@end
