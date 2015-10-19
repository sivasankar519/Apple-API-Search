//
//  DataTableViewController.m
//  AppleSearchAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/16/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import "DataTableViewController.h"
#import "DataManager.h"
#import "DataTableViewCell.h"
#import "DetailViewController.h"
#import "DataFetch.h"
#import "AppDelegate.h"
@interface DataTableViewController ()
{
    NSArray *results;
    UIActivityIndicatorView *activity;
   
}

@end

@implementation DataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if([UIAppDelegate Network]){
        activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.hidesWhenStopped = YES;
        activity.center = CGPointMake(self.view.center.x, self.view.center.y- 2*self.navigationController.navigationBar.frame.size.height) ;
        [self.view addSubview:activity];
        [activity startAnimating];
       [self callService];
        
    }else{
        
        results  = [[DataFetch sharedInstance] getResultsWithSearchKey:self.searchString];
    }
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = self.searchString;
}



#pragma mark - Custom UI section
-(void)callService{
    
    NSString *urlString = [NSString stringWithFormat:
                           @"https://itunes.apple.com/search?term=%@&limit=20",[self.searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [[DataManager sharedInstance] loadURLRequestWithURLString:urlString completionHandler:^(NSData *data) {
        
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            [DataManager sharedInstance].dataArray = dict[@"results"];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [activity setHidden:YES];
                [activity removeFromSuperview];
            });
            
            if([dict[@"results"] count]){
                
                dispatch_queue_t myQueue = dispatch_queue_create("myCustomQueue",NULL);
                dispatch_async(myQueue, ^{
                    
                    // save to database
                    [DataFetch sharedInstance].searchKey = self.searchString;
                    [[DataFetch sharedInstance] saveData:dict[@"results"]];
                });
            }
        }
    }];
}

 #pragma mark - Navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowDetail"]) {
        
        // Get destination view
        DetailViewController *destinationController = [segue destinationViewController];
        
        NSInteger row = [self.tableView indexPathForSelectedRow].row;
        
        if([UIAppDelegate Network]){
            
            destinationController.detailInfo = [DataManager sharedInstance].dataArray[row];
            
        }else{
            
            destinationController.detailInfo = results[row];
        }
        
        
        DataTableViewCell *cell = (DataTableViewCell*)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        destinationController.image = cell.imageView.image;
        
       
    }
}
 
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return  1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if([UIAppDelegate Network]){
        
        return [[DataManager sharedInstance].dataArray count];
        
    }else{
        
        return results.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if([UIAppDelegate Network]){
        cell.textLabel.text = [DataManager sharedInstance].dataArray[indexPath.row][@"trackName"];
        cell.detailTextLabel.text = [DataManager sharedInstance].dataArray[indexPath.row][@"artistName"];
        cell.imageURLString = [[DataManager sharedInstance] getImageURL:indexPath.item];
        [cell setUpTableCell];
        
    }else{
        cell.textLabel.text = [results[indexPath.row] valueForKey:@"trackName"];
        cell.detailTextLabel.text = [results[indexPath.row] valueForKey:@"artistName"];
        cell.imageView.image = [UIImage imageWithData:[results[indexPath.row] valueForKey:@"image"]];
    }
   
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end
