//
//  BookViewController.h
//  CoreDataHotel
//
//  Created by Rio Balderas on 4/25/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room+CoreDataClass.h"


@interface BookViewController : UIViewController

@property(strong, nonatomic) NSDate *startDate;
@property(strong, nonatomic) NSDate *endDate;
@property(strong, nonatomic) Room *selectedAvailableRoom;


@end
