//
//  AvailabilityViewController.m
//  CoreDataHotel
//
//  Created by Rio Balderas on 4/25/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "AutoLayout.h"

#import "AppDelegate.h"
#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"
#import "BookViewController.h"


@interface AvailabilityViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UITableView *tableView;
//                             changed from array and added NSSort descriptor below to fix some array problems
@property(strong, nonatomic) NSFetchedResultsController *availableRooms;

@end

@implementation AvailabilityViewController

-(NSFetchedResultsController *)availableRooms{
    if (!_availableRooms) {
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        request.predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", self.endDate, self.startDate];
        
        NSError *roomError;
        NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&roomError];
        
        NSMutableArray *unavailableRooms = [[NSMutableArray alloc]init];
        
        for (Reservation *reservation in results) {
            [unavailableRooms addObject:reservation.room];
        }
        
        NSFetchRequest *roomRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
        roomRequest.predicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", unavailableRooms];
        
        //going to make the sections out of the hotel name with this line.
        NSSortDescriptor *roomSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hotel.name" ascending:YES];
        
        roomRequest.sortDescriptors = @[roomSortDescriptor];
        
        
        NSError *availableRoomError;
        
        _availableRooms = [[NSFetchedResultsController alloc] initWithFetchRequest:roomRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"hotel.name" cacheName:nil];
        
        [_availableRooms performFetch:&availableRoomError];
        
//        _availableRooms = [appDelegate.persistentContainer.viewContext executeFetchRequest:roomRequest error:&availableRoomError];
        
    }

    return _availableRooms;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}


-(void)loadView{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupTableView];

}


-(void)setupTableView{
    self.tableView = [[UITableView alloc]init];
    
    [self.view addSubview:self.tableView];
    
     self.tableView.dataSource = self;
     self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [AutoLayout fullScreenContraintsWithVFLForView:self.tableView];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.availableRooms sections]objectAtIndex:section];
    
    return sectionInfo.numberOfObjects;
    

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
//    Room *currentRoom = self.availableRooms[indexPath.row];
    Room *currentRoom = [self.availableRooms objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Room #: %i (%i beds, $%0.2f per night)", currentRoom.number, currentRoom.beds, currentRoom.rate];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Room *reservedRoom = [self.availableRooms objectAtIndexPath:indexPath];
    
    
    BookViewController *bookViewController = [[BookViewController alloc] init];
    
//    bookViewController.selectedAvailableRoom = self.availableRooms[indexPath.row];
    
    bookViewController.reservedRoom = reservedRoom;
    bookViewController.startDate = self.startDate;
    bookViewController.endDate = self.endDate;
    [self.navigationController pushViewController:bookViewController animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.availableRooms.sections.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.availableRooms.sections objectAtIndex:section];
    
    return sectionInfo.name;
    }



@end
