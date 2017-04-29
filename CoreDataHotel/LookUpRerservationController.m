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
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"
#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"

@interface LookUpRerservationController () <UITableViewDataSource, UISearchBarDelegate>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *reservations;
@property (strong, nonatomic)UISearchBar *searchBar;
@property (strong, nonatomic)NSMutableArray *filteredResults;
@property BOOL isSearching;
@property(strong, nonatomic) UITextField *firstName;
@property(strong, nonatomic) UITextField *lastName;
@property(strong, nonatomic) Guest *reservation;

@end

@implementation LookUpRerservationController

-(NSArray *)reservations{
    if (!_reservations) {
        
        AppDelegate *appDelagate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSManagedObjectContext *context = appDelagate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        
        NSError *fetchError;
        
        NSArray *reservations = [context executeFetchRequest:request error:&fetchError];
        
        if (fetchError) {
            NSLog(@"There was an error fetching hotels from Core Data");
        }
        
        _reservations = reservations;
    }
    return _reservations;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)loadView{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setUpSearchBar];
    [self setupTableView];
}
-(void) setUpSearchBar {
    self.searchBar = [[UISearchBar alloc]init];
    [[self searchBar] setPlaceholder:@"Search Name"];
    [[self searchBar]setDelegate:self];
    self.searchBar.delegate = self;
    [[self searchBar] setShowsCancelButton:YES];
    [[self searchBar] setShowsSearchResultsButton:YES];
    [[self view] addSubview:[self searchBar]];
    
    [AutoLayout leadingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout trailingConstraintFrom:self.searchBar toView:self.view];
    
    [self.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [self.searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.isSearching = YES;
    
    
    [[self tableView] reloadData];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.isSearching = YES;
    if ([searchText isEqual: @""]) {
        self.isSearching = NO;
        self.filteredResults = nil;
    }else{
        self.filteredResults = [[NSMutableArray alloc] init];
        self.filteredResults = [[self.reservations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"guest.lastName CONTAINS %@ or guest.firstName CONTAINS %@", searchText, searchText]] mutableCopy];
    }
//        [self.filteredResults setArray:[[self.filteredResults filteredArrayUsingPredicate:[self filterByFirstName:@"guest.firstName" andLastName:@"guest.lastName" usingSearchTerms:searchBar.text]]mutableCopy]];

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
        [self.filteredResults setArray:[[self.filteredResults filteredArrayUsingPredicate:[self filterByFirstName:@"guest.firstName" andLastName:@"guest.lastName" usingSearchTerms:searchBar.text]]mutableCopy]];
    }
    self.isSearching = NO;
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc]init];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = self.searchBar;
    [self.tableView layoutIfNeeded];
    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [AutoLayout fullScreenContraintsWithVFLForView:self.tableView];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isSearching) {
        return self.filteredResults.count;
    }
    else {
        return 1;
    }
    
    
//    return self.reservations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
//    Reservation *reservation = self.reservations[indexPath.row];
    
    Reservation *reservation = [self.filteredResults objectAtIndex:indexPath.row];
    Guest *guest = [reservation guest];
    
    
    if (self.filteredResults == nil) {
     cell.textLabel.text = @"No Names shown for your/other guest's security";
    } else {
        reservation = self.filteredResults [indexPath.row];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm a"];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Guest: %@ %@, Staying in Room: %hd         from:%@ to %@ ", guest.firstName, guest.lastName, reservation.room.number, [dateFormat stringFromDate:reservation.startDate],[dateFormat stringFromDate:reservation.endDate]];
    }
    
 
    
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

-(NSPredicate *)filterByFirstName:(NSString *)firstName
                      andLastName:(NSString *)lastName
                 usingSearchTerms:(NSString *)searchTerms{
    return [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@ || %K CONTAINS[cd] %@"
                              argumentArray:@[firstName, searchTerms, lastName, searchTerms]];
}



@end
