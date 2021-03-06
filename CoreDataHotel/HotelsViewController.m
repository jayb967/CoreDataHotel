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

#import "RoomViewController.h"
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"
#import "AutoLayout.h"


@interface HotelsViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) NSArray *allHotels;
@property(strong, nonatomic) UITableView *tableView;



@end

@implementation HotelsViewController

-(void)loadView{
    [super loadView];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self allHotels];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    

    
    // Do any additional setup after loading the view.
}

-(NSArray *)allHotels{
    if (!_allHotels) {
        
        AppDelegate *appDelagate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSManagedObjectContext *context = appDelagate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        
        NSError *fetchError;
        
        NSArray *hotels = [context executeFetchRequest:request error:&fetchError];
        
        if (fetchError) {
            NSLog(@"There was an error fetching hotels from Core Data");
        }
        
        _allHotels = hotels;
    }
    return _allHotels;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Hotel *hotel = _allHotels[indexPath.row];
    cell.textLabel.text = hotel.name;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allHotels.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//write method for rooms here
    RoomViewController *roomVC = [[RoomViewController alloc] init];
    
    roomVC.selectedHotel = self.allHotels[indexPath.row];
    
    [self.navigationController pushViewController:roomVC animated:YES];
}

@end
