//
//  DataFetch.m
//  AppleSearchAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/18/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import "DataFetch.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "SearchItem.h"
#import "DetailInfo.h"
#import "DataManager.h"
@interface DataFetch ()
{
    DetailInfo *detailManagedObj;
    NSString *imageURLString;
}
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation DataFetch
@synthesize managedObjectContext = _managedObjectContext;

+ (DataFetch *)sharedInstance {
    static DataFetch *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataFetch alloc] init];
    });
    
    return sharedInstance;
}
- (id)init {
    self = [super init];
    
    if (self) {
        // custom initialization
    }
    
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
  
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return delegate.managedObjectContext;
}

-(void)save{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate saveContext];
}

-(NSArray*)fetchSearchList{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SearchItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // error handling code
    }
    return [[fetchedObjects reverseObjectEnumerator] allObjects];;
    
}


-(NSArray*)getResultsWithSearchKey:(NSString*)searchString{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DetailInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"searchItem.searchItem == %@",searchString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // error
    }
    
    return fetchedObjects;
}


-(void)saveData:(NSArray*)results{
    
    [self removeSearchItem:self.searchKey];
    
    SearchItem *searchManagedObj = [NSEntityDescription insertNewObjectForEntityForName:@"SearchItem" inManagedObjectContext:self.managedObjectContext];
    searchManagedObj.searchItem = self.searchKey;
    
    for (int index = 0; index < results.count; index++) {
        
        detailManagedObj = [NSEntityDescription insertNewObjectForEntityForName:@"DetailInfo" inManagedObjectContext:self.managedObjectContext];
    
        imageURLString = [[DataManager sharedInstance] getImageURL:index];
        detailManagedObj.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLString]];
        detailManagedObj.artistName = results[index][@"artistName"];
        detailManagedObj.collectionName = results[index][@"collectionName"];
        detailManagedObj.releaseDate = results[index][@"releaseDate"];
        detailManagedObj.kind = results[index][@"kind"];
        detailManagedObj.previewUrl = results[index][@"previewUrl"];
        detailManagedObj.trackPrice = results[index][@"trackPrice"] ;
        detailManagedObj.trackTimeMillis = results[index][@"trackTimeMillis"];
        detailManagedObj.trackName = results[index][@"trackName"];
        detailManagedObj.trackViewUrl = results[index][@"trackViewUrl"];
        
        [searchManagedObj addDetailInfoObject:detailManagedObj];
        
    }
    [self save];
}

-(void)removeSearchItem:(NSString*)searchString{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SearchItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"searchItem == %@",searchString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // error
    }
    
    for (NSManagedObject *managedObject in fetchedObjects) {
        [self.managedObjectContext deleteObject:managedObject];
    }

}
@end
