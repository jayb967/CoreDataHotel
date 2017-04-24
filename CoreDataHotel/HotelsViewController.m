//
//  HotelsViewController.m
//  CoreDataHotel
//
//  Created by Rio Balderas on 4/24/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

#import "HotelsViewController.h"
#import "AppDelegate.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

@interface HotelsViewController () <UITableViewDataSource>

@property(strong, nonatomic) NSArray *allHotels;
@property(strong, nonatomic) UITableView *tableView;



@end

@implementation HotelsViewController

-(void)loadView{
    [super loadView];
    //asdd tableView as subView and apply constraints
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // Do any additional setup after loading the view.
}

-(NSArray *)allHotels{
    if (!_allHotels) {
        
        AppDelegate *appDelagate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSManagedObjectContext *context = appDelagate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotels"];
        
        NSError *fetchError;
        
        NSArray *hotels = [context executeFetchRequest:request error:&fetchError];
        
        if (fetchError) {
            NSLog(@"There was an error fetching hotels from Core Data");
        }
        
        _allHotels = hotels;
    }
    return _allHotels;
}


@end
