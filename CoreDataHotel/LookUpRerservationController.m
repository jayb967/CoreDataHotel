//
//  LookUpRerservationController.m
//  CoreDataHotel
//
//  Created by Rio Balderas on 4/26/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

#import "LookUpRerservationController.h"
#import "AppDelegate.h"
#import "AutoLayout.h"
#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"
#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"

@interface LookUpRerservationController () <UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) UITableView *tableView;
//                             changed from array and added NSSort descriptor below to fix some array problems
@property(strong, nonatomic) NSMutableArray *roomReserved;
@property (strong, nonatomic)UISearchBar *searchBar;
@property (strong, nonatomic)NSMutableArray *filteredResults;
@property BOOL isSearching;


@end

@implementation LookUpRerservationController
-(NSFetchedResultsController *)roomReserved{
    if (!_roomReserved) {
       
        
        

        
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        request.predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", self.endDate, self.startDate];
        
        NSError *roomError;
        NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&roomError];
        
        NSMutableArray *guestReservations = [[NSMutableArray alloc]init];
        
        for (Reservation *reservation in results) {
            [guestReservations addObject:reservation.room];
        }
        
        NSFetchRequest *guestRequest = [NSFetchRequest fetchRequestWithEntityName:@"Guest"];
        guestRequest.predicate = [NSPredicate predicateWithFormat:@"self IN %@", guestReservations];
        
        //going to make the sections out of the hotel name with this line.
        NSSortDescriptor *guestSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"guest.name" ascending:YES];
        
        guestRequest.sortDescriptors = @[guestSortDescriptor];
        
        
        NSError *guestError;
        
        _roomReserved = [[NSFetchedResultsController alloc] initWithFetchRequest:guestRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"hotel.name" cacheName:nil];
        
        [_roomReserved performFetch:&guestError];
    }
    return _roomReserved;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)loadView{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupTableView];
}
-(void) setUpSearchBar {
    self.searchBar = [[UISearchBar alloc]init];
    [[self searchBar] setPlaceholder:@"Search Reservations by name"];
    [[self searchBar]setDelegate:self];
    [[self searchBar] setShowsCancelButton:YES];
    [[self searchBar] setShowsSearchResultsButton:YES];
    [[self view] addSubview:[self searchBar]];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.isSearching = YES;
    self.filteredResults = [[NSMutableArray alloc] init];
    
    [self.filteredResults setArray:[[self.roomReserved filteredArrayUsingPredicate:[self filterByFirstName:@"guest.firstName" andLastName:@"guest.lastName" usingSearchTerms:searchBar.text]]mutableCopy]];
    [[self tableView] reloadData];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.isSearching = YES;
    [self.filteredResults setArray:[[self.roomReserved filteredArrayUsingPredicate:[self filterByFirstName:@"guest.firstName" andLastName:@"guest.lastName" usingSearchTerms:searchBar.text]]mutableCopy]];
    [[self tableView] reloadData];
}



-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.isSearching = NO;
    self.filteredResults = nil;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text != nil) {
        self.filteredResults = [[NSMutableArray alloc]init];
        [self.filteredResults setArray:[[self.roomReserved filteredArrayUsingPredicate:[self filterByFirstName:@"guest.firstName" andLastName:@"guest.lastName" usingSearchTerms:searchBar.text]]mutableCopy]];
    }
    self.isSearching = NO;
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
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.roomReserved sections]objectAtIndex:section];
    
    return sectionInfo.numberOfObjects;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    //    Room *currentRoom = self.availableRooms[indexPath.row];
    Guest *guestName = [self.roomReserved objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Guest: %@, Staying in Room: %@ from:%@ to %@ ", guestName.name, self.reservedRoom, self.startDate, self.endDate];
    
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.roomReserved.count;
}
-(NSPredicate *)filterByFirstName:(NSString *)firstName
                      andLastName:(NSString *)lastName
                 usingSearchTerms:(NSString *)searchTerms{
    return [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@ || %K CONTAINS[cd] %@"
                              argumentArray:@[firstName, searchTerms, lastName, searchTerms]];
}



@end
